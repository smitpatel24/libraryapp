import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  ConnectivityService._internal() {
    _initializeConnectivityListener();
  }

  // Stream controller to broadcast connectivity status updates
  final StreamController<bool> _connectivityStreamController = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  // Instance of InternetConnection to check connectivity
  final InternetConnection _internetChecker = InternetConnection();
  
  // Variable to hold the current connection status
  bool _isConnected = true;

  void _initializeConnectivityListener() {
    // Listen to changes in connectivity status
    _internetChecker.onStatusChange.listen((InternetStatus status) {
      final isConnected = status == InternetStatus.connected;

      // Only update and notify when there is a change in status
      if (_isConnected != isConnected) {
        _isConnected = isConnected;
        _connectivityStreamController.add(isConnected);

        // Show toast notification for connectivity changes
        BotToast.showSimpleNotification(
          title: isConnected ? "Devices back online. Syncing the changes." 
          : "Device offline",
          backgroundColor: isConnected ? Colors.green : Colors.red,
          duration: Duration(seconds: 4),
        );
      }
    });
  }

  // Synchronous connectivity check
  Future<bool> checkConnectivity() async {
    return await _internetChecker.hasInternetAccess;
  }

  // Dispose method to release resources
  void dispose() {
    _connectivityStreamController.close();
  }
}
