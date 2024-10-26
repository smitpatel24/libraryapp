import 'dart:developer';

import 'package:libraryapp/models/reader.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8.encode
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  static const String supabaseUrl = 'https://dravtxcouwimsuugpdbc.supabase.co';
  static const String supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRyYXZ0eGNvdXdpbXN1dWdwZGJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQ4NDkyODEsImV4cCI6MjAzMDQyNTI4MX0.yKPZgxXOP7jHQSVpauh8suDZygE22JcFEnyLETMr990';

  // Singleton instance
  static final SupabaseManager _instance = SupabaseManager._internal();

  // Client instance
  late final SupabaseClient client;

  // Initialization flag
  bool _isInitialized = false;

  // Private constructor
  SupabaseManager._internal() {
    _initializeClient();
  }

  // Factory constructor for backwards compatibility
  @Deprecated("Use SupabaseManager.instance instead")
  factory SupabaseManager() {
    log('Warning: Use SupabaseManager.instance instead of constructor');
    return _instance;
  }

  // Singleton accessor
  static SupabaseManager get instance => _instance;

  // Initialize the Supabase client
  void _initializeClient() {
    client = SupabaseClient(supabaseUrl, supabaseKey);
  }

  // Ensure initialization
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      try {
        // Test connection
        await client.from('users').select().limit(1);
        _isInitialized = true;
        log('SupabaseManager initialized successfully');
      } catch (e) {
        log('Failed to initialize SupabaseManager: $e');
        rethrow;
      }
    }
  }

  // Clean up resources
  void dispose() {
    client.dispose();
    _isInitialized = false;
    log('SupabaseManager disposed');
  }

  // Method to authenticate user and fetch user details
  Future<Map<String, dynamic>?> authenticateUser(
      String username, String password) async {
    final response =
        await client.from('users').select().eq('username', username).single();

    final user = response;
    final passwordHash = _hashPassword(password);
    if (passwordHash == user['passwordhash']) {
      await _setLoginState(true, user['usertype']);
      return user;
    }

    return null;
  }

  // Method to hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // data being hashed
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Method to set login state in SharedPreferences
  Future<void> _setLoginState(bool loggedIn, int userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', loggedIn);
    await prefs.setInt('userType', userType);
  }

  // Method to get login state from SharedPreferences
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  // Method to get user type from SharedPreferences
  Future<int?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userType');
  }

  // Method to log out user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedIn');
    await prefs.remove('userType');
  }

  // Method to find or add an author and return the authorId
  Future<int?> ensureAuthorExists(String authorName, int bookId) async {
    var checkBookId =
        await client.from('books').select('bookid').eq('bookid', bookId);

    if (checkBookId.length != 0) {
      return -1;
    }
    var checkResponse = await client
        .from('authors')
        .select('authorid')
        .eq('authorname', authorName);
    if (checkResponse.length != 0 && checkResponse.isNotEmpty) {
      // Correctly accessing data
      return checkResponse[0]['authorid'];
    } else {
      // Insert new author if not found
      var insertResponse =
          await client.from('authors').insert({'authorname': authorName});

      var getAuthorId = await client
          .from('authors')
          .select('authorid')
          .eq('authorname', authorName);
      return getAuthorId[0]['authorid'];
    }
  }

  // New method specifically for the EditBookPage
  Future<int?> findOrAddAuthor(String authorName) async {
    var checkResponse = await client
        .from('authors')
        .select('authorid')
        .eq('authorname', authorName);

    if ((checkResponse as List).isNotEmpty) {
      return checkResponse[0]['authorid'];
    } else {
      await client.from('authors').insert({'authorname': authorName});

      var getAuthorId = await client
          .from('authors')
          .select('authorid')
          .eq('authorname', authorName);

      return getAuthorId[0]['authorid'];
    }
  }

  // Method to update a book's title and authorId
  Future<void> updateBookDetails(
      String bookId, String title, String authorName) async {
    int? authorId = await findOrAddAuthor(authorName);
    if (authorId != null) {
      await client
          .from('books')
          .update({'title': title, 'authorid': authorId}).eq('bookid', bookId);
    }
  }

  // Method to add a book with authorId
  Future<void> addBook(String bookId, String title, int authorId) async {
    var response = await client
        .from('books')
        .insert({'bookid': bookId, 'title': title, 'authorid': authorId});

    // Add a new entry to the bookcopies table
    var copyResponse = await client
        .from('bookcopies')
        .insert({'bookid': bookId, 'available': true});
  }

  /// Method to fetch all books info from the view
  Future<List<Map<String, dynamic>>> fetchAllBooksInfo() async {
    var response = await client.from('allbooksinfo').select();
    return response;
  }

  // Method to search books by keyword
  Future<List<Map<String, dynamic>>> searchBooks(String keyword) async {
    final response = await client
        .from('allbooksinfo')
        .select()
        .or('bookname.ilike.%$keyword%,authorname.ilike.%$keyword%');

    final bookIdResponse = await client
        .from('allbooksinfo')
        .select()
        .eq('bookid', int.tryParse(keyword) ?? -1);

    final combinedResults = List<Map<String, dynamic>>.from(response)
      ..addAll(List<Map<String, dynamic>>.from(bookIdResponse));
    return combinedResults.toSet().toList(); // Removing duplicate
  }

  // Method to create a new user as a reader
  Future<void> createUserAsAReader({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String barcode,
  }) async {
    try {
      // Hash the password before storing it in the database
      final passwordHash = _hashPassword(password);

      // Insert the new user into the 'users' table with usertype = 3 (reader)
      final response = await client.from('users').insert({
        'firstname': firstName,
        'lastname': lastName,
        'username': username,
        'passwordhash': passwordHash, // Store the hashed password
        'usertype': 3, // usertype 3 is for a reader
        'barcode': barcode,
      }).select(); // Use select() to return the inserted user

      // Handle the response if needed
      if (response.isNotEmpty) {
        // User created successfully
        log('User created: ${response[0]}');
      } else {
        // Handle the case where the user was not created
        log('User creation failed.');
      }
    } catch (e) {
      // Log the error or throw it to be caught by the calling method
      throw Exception('Failed to create user: $e');
    }
  }

  // Method to fetch all readers
  Future<List<Reader>> fetchAllReaders() async {
  try { 
    final response = await client.from('readers').select();
    final List data = response as List;
    return data.map((user) => Reader.fromSupabase(user)).toList();
  } catch (e) {
    throw Exception('Failed to fetch readers: $e');
  } 
}
}
