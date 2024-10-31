import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:libraryapp/services/local_database_service.dart';
import 'package:libraryapp/services/connectivity_service.dart';
import 'package:libraryapp/models/sync_operation.dart';
import 'package:libraryapp/services/supabase_manager.dart';

class OfflineEnabledSupabaseManager {
  // Singleton instance
  static final OfflineEnabledSupabaseManager _instance =
      OfflineEnabledSupabaseManager._internal();

  // Factory constructor to return the singleton instance
  factory OfflineEnabledSupabaseManager() {
    return _instance;
  }

  // Private named constructor
  OfflineEnabledSupabaseManager._internal() {
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    // Get initial connectivity state
    _isConnected = await _connectivityService.checkConnectivity();
    log('Initial connectivity status: $_isConnected');

    // Then listen to changes
    _connectivityService.connectivityStream.listen((isConnected) {
      log('OfflineEnabledSupabaseManager finds Connectivity status changed: $isConnected');
      _isConnected = isConnected;
      if (_isConnected) {
        _syncPendingOperations();
      }
    });
  }

  final SupabaseManager _supabaseManager = SupabaseManager.instance;
  final LocalDatabaseService _localDatabaseService =
      LocalDatabaseService.instance;
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  Future<void> _syncPendingOperations() async {
    final pendingOperations =
        await _localDatabaseService.getPendingOperations();
    log('Syncing ${pendingOperations.length} pending operations');
    _showToast('Syncing ${pendingOperations.length} operations...');
    for (var operation in pendingOperations) {
      log('Executing operation: ${operation.id}');
      try {
        // Dispatch each operation to Supabase
        await _executeOperation(operation);
        await _localDatabaseService.updateOperationStatus(
            operation.id, 'completed');
      } catch (e) {
        log('Failed to execute operation ${operation.id}: $e');
      }
    }
  }

  Future<void> _executeOperation(SyncOperation operation) async {
    // Route to the correct Supabase function based on operation details
    switch (operation.functionName) {
      case 'createUserAsAReader':
        await _supabaseManager.createUserAsAReader(
          firstName: operation.params['first_name'],
          lastName: operation.params['last_name'],
          username: operation.params['username'],
          barcode: operation.params['barcode'],
        );
        break;

      case 'createUserAsALibrarian':
        await _supabaseManager.createUserAsALibrarian(
          firstName: operation.params['first_name'],
          lastName: operation.params['last_name'],
          username: operation.params['username'],
          password: operation.params['password'],
          barcode: operation.params['barcode'],
        );
        break;

      case 'updateUser':
        await _supabaseManager.updateUser(
          userId: operation.params['userId'],
          firstname: operation.params['firstname'],
          lastname: operation.params['lastname'],
          username: operation.params['username'],
          userBarcode: operation.params['userBarcode'],
        );
        break;

      case 'setUserPassword':
        await _supabaseManager.setUserPassword(
          userId: operation.params['userId'],
          userPassword: operation.params['userPassword'],
        );
        break;

      default:
        throw UnsupportedError(
            'Unsupported operation: ${operation.functionName}');
    }
  }

  Future<void> createUserAsAReader({
    required String firstName,
    required String lastName,
    required String username,
    required String barcode,
  }) async {
    final isCurrentlyConnected = await _connectivityService.checkConnectivity();
    log('Creating user: $firstName $lastName');
    if (isCurrentlyConnected) {
      log('Creating user: $firstName $lastName, using Supabase');
      await _supabaseManager.createUserAsAReader(
        firstName: firstName,
        lastName: lastName,
        username: username,
        barcode: barcode,
      );
      return;
    } else {
      log('Creating user: $firstName $lastName, queuing operation');
      await _queueOperation('createUserAsAReader', {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'barcode': barcode,
      });
      return;
    }
  }

  Future<void> createUserAsALibrarian({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String barcode,
  }) async {
    final isCurrentlyConnected = await _connectivityService.checkConnectivity();
    log('Creating user: $firstName $lastName');
    if (isCurrentlyConnected) {
      log('Creating user: $firstName $lastName, using Supabase');
      await _supabaseManager.createUserAsALibrarian(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        barcode: barcode,
      );
      return;
    } else {
      log('Creating user: $firstName $lastName, queuing operation');
      await _queueOperation('createUserAsALibrarian', {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'password': password,
        'barcode': barcode,
      });
      return;
    }
  }

  Future<void> updateUser({
    required int userId,
    required String firstname,
    required String lastname,
    required String username,
    required String barcode,
  }) async {
    final isCurrentlyConnected = await _connectivityService.checkConnectivity();
    if (isCurrentlyConnected) {
      log('Updating reader: $userId, using Supabase');
      await _supabaseManager.updateUser(
        userId: userId,
        firstname: firstname,
        lastname: lastname,
        username: username,
        userBarcode: barcode,
      );
    } else {
      log('Updating user: $userId, queuing operation');
      await _queueOperation('updateUser', {
        'userId': userId,
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'useBarcode': barcode,
      });
    }
  }

  Future<void> _queueOperation(
      String functionName, Map<String, dynamic> params) async {
    final operation = SyncOperation(
      id: _generateUniqueId(),
      functionName: functionName,
      params: params,
      timestamp: DateTime.now(),
    );
    await _localDatabaseService.insertOperation(operation);
    log('Operation queued, showing toast'); // Add this log
    _showToast();
    log('Toast should be visible now');
  }

  Future<void> deleteReader(int readerId) async {
    final isCurrentlyConnected = await _connectivityService.checkConnectivity();

    if (isCurrentlyConnected) {
      log('Deleting reader: $readerId, using Supabase');
      await _supabaseManager.deleteUser(readerId);
    } else {
      log('Deleting reader: $readerId, queuing operation');
      await _queueOperation('deleteReader', {
        'readerId': readerId,
      });
    }
  }

  Future<void> setUserPassword(
      {required int userId, required String userPassword}) async {
    final isCurrentlyConnected = await _connectivityService.checkConnectivity();
    if (isCurrentlyConnected) {
      log('Setting password for user: $userId, using Supabase');
      await _supabaseManager.setUserPassword(
        userId: userId,
        userPassword: userPassword,
      );
    } else {
      log('Setting password for user: $userId, queuing operation');
      await _queueOperation('setUserPassword', {
        'userId': userId,
        'userPassword': userPassword,
      });
    }
  }

  String _generateUniqueId() {
    return DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // Simplistic unique ID generation
  }

  // show toast message
  void _showToast([String? message]) {
    BotToast.showText(
        text: message ?? "Curretnly offline mode, operation queued",
        duration: const Duration(seconds: 2),
        contentColor: Colors.green);
  }
}
