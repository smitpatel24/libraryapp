import 'dart:developer';

import 'package:libraryapp/models/user_dto.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8.encode
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // For formatting dates

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
      await _setLoginState(true, user['usertype'], user['userid']);
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
  Future<void> _setLoginState(bool loggedIn, int userType, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', loggedIn);
    await prefs.setInt('userType', userType);
    await prefs.setInt('userId', userId);
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

  // Method to get user type from SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Method to log out user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedIn');
    await prefs.remove('userType');
    await prefs.remove('userId');
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
  Future<void> addBook(String title, int authorId, String barcode) async {
    // Check if barcode already exists
    var duplicateCheck = await client
        .from('bookcopies')
        .select('barcode')
        .eq('barcode', barcode);

    if ((duplicateCheck as List).isNotEmpty) {
      throw Exception('Barcode $barcode already exists');
    }

    // Insert new book and get the generated bookId
    var response = await client
        .from('books')
        .insert({'title': title, 'authorid': authorId})
        .select('bookid')
        .single();

    int bookId = response['bookid'];

    // Add a new entry to the bookcopies table
    await client
        .from('bookcopies')
        .insert({'bookid': bookId, 'barcode': barcode, 'available': true});
  }

  // Method to add a book copy
  Future<void> addBookCopy(String existingBarcode, String newBarcode) async {
    // Get the book ID from existing barcode
    var bookIdResponse;
    try {
      bookIdResponse = await client
          .from('bookcopies')
          .select('bookid')
          .eq('barcode', existingBarcode)
          .single();
    } catch (e) {
      throw Exception('Book with barcode $existingBarcode not found');
    }

    int bookId = bookIdResponse['bookid'];

    // Check if new barcode already exists
    var duplicateCheck = await client
        .from('bookcopies')
        .select('barcode')
        .eq('barcode', newBarcode);

    if ((duplicateCheck as List).isNotEmpty) {
      throw Exception('Barcode $newBarcode already exists');
    }

    // Create new copy with found book ID
    await client
        .from('bookcopies')
        .insert({
          'bookid': bookId,
          'barcode': newBarcode,
          'available': true
        });
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
    required String barcode,
  }) async {
    log('Creating reader: $firstName $lastName');
    try {
      // call sql function to create user
      final response = await client.rpc(
        'create_reader',
        params: {
          'first_name': firstName,
          'last_name': lastName,
          'user_name': username,
          'password_hash': '', // Password is not required for readers
          'reader_barcode': barcode,
        },
      );

      log('Reader created: $response');
    } catch (e) {
      // Log the error or throw it to be caught by the calling method
      throw Exception('Failed to create reader: $e');
    }
  }

  // Method to create a new user as a librarain
  Future<void> createUserAsALibrarian({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String barcode,
  }) async {
    log('Creating Reader: $firstName $lastName');
    try {
      // Hash the password before storing it in the database
      final passwordHash = _hashPassword(password);

      // call sql function to create user
      final response = await client.rpc(
        'create_librarian',
        params: {
          'first_name': firstName,
          'last_name': lastName,
          'user_name': username,
          'password_hash': passwordHash,
          'barcode': barcode,
        },
      );

      log('Librarian created: $response');
    } catch (e) {
      // Log the error or throw it to be caught by the calling method
      throw Exception('Failed to create Librarian: $e');
    }
  }

  // Method to fetch all readers
  Future<List<UserDTO>> fetchAllReaders() async {
    try {
      final response = await client.rpc('get_readers');
      final List data = response as List;
      return data.map((user) => UserDTO.fromSupabase(user)).toList();
    } catch (e) {
      throw Exception('Failed to fetch readers: $e');
    }
  }

  // Method to fetch all librarians
  Future<List<UserDTO>> fetchAllLibrarians() async {
    try {
      final response = await client.from('librarianinfo').select();
      final List data = response as List;
      return data.map((user) => UserDTO.fromSupabase(user)).toList();
    } catch (e) {
      throw Exception('Failed to fetch readers: $e');
    }
  }

  // Method to update reader details
  Future<void> updateUser({
    required int userId,
    required String firstname,
    required String lastname,
    required String username,
    required String userBarcode,
  }) async {
    try {
      final response = await client.rpc(
        'update_user',
        params: {
          'user_id': userId,
          'first_name': firstname,
          'last_name': lastname,
          'username': username,
          'user_barcode': userBarcode,
        },
      );

      log('User updated: $response');
    } catch (e) {
      throw Exception('Failed to update User: $e');
    }
  }

  // Method to delete a user
  Future<void> deleteUser(int userId) async {
    try {
      log('Deleting reader with ID: $userId');
      final response =
          await client.rpc('delete_user', params: {'user_id': userId});

      log('Delete response: ${response.toString()}');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<void> setUserPassword(
      {required int userId, required String userPassword}) async {
    try {
      final passwordHash = _hashPassword(userPassword);
      final response = await client.rpc(
        'update_user_password',
        params: {
          'user_id': userId,
          'hashed_password': passwordHash,
        },
      );

      log('Password set for user ID $userId: $response');
    } catch (e) {
      throw Exception('Failed to set user password: $e');
    }
  }

  Future<UserDTO> fetchLibrarianById(int currentUserId) {
    try {
      return client
          .from('librarianinfo')
          .select()
          .eq('id', currentUserId)
          .single()
          .then((data) => UserDTO.fromSupabase(data));
    } catch (e) {
      throw Exception('Failed to fetch librarian: $e');
    }
  }

  // Method to checkout book
  Future<void> checkoutBook(String bookBarcode, String userBarcode, String dueDate) async {
    try {
      // Check if the book copy is available
      var bookCopy = await client
          .from('bookcopies')
          .select('copyid, available')
          .eq('barcode', bookBarcode)
          .single();

      if (bookCopy == null) {
        throw Exception("Book copy not found.");
      }

      if (!bookCopy['available']) {
        throw Exception("Book is not available for checkout.");
      }

      // Fetch the user ID using the user barcode
      var user = await client
          .from('users')
          .select('userid')
          .eq('barcode', userBarcode)
          .single();

      if (user == null) {
        throw Exception("User not found.");
      }

      var userId = user['userid'];
      var copyId = bookCopy['copyid'];

      // Get today's date in YYYY-MM-DD format
      String transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Insert the transaction into the transactions table
      var transactionResponse = await client.from('transactions').insert({
        'userid': userId,
        'transactiontype': 1, // 1 for checkout
        'transactiondate': transactionDate,
        'duedate': dueDate,
        'copyid': copyId
      });

      print("Checkout successful.");
    } catch (e) {
      throw Exception(e.toString()); // Rethrow the error to be handled by caller
    }
  }

  // Method to fetch checkout details
  Future<Map<String, dynamic>> fetchCheckoutDetails(
    String bookBarcode,
    String readerBarcode,
  ) async {
    try {
      // Fetch book details from the bookcopiesview table
      final bookResponse = await client
          .from('bookcopiesview')
          .select('booktitle, authorname')
          .eq('barcode', bookBarcode)
          .single();

      // Fetch reader details from the readers table
      final readerResponse = await client
          .from('readers')
          .select('fname, lname')
          .eq('barcode', readerBarcode)
          .single();

      // Extract the data from the responses
      final bookData = bookResponse;
      final readerData = readerResponse;

      // Return the combined data as a map
      return {
        'bookTitle': bookData['booktitle'],
        'author': bookData['authorname'],
        'readerFirstName': readerData['fname'],
        'readerLastName': readerData['lname'],
      };
    } catch (error) {
      print('Error fetching checkout details: $error');
      throw error;  // Rethrow error to be handled by calling code
    }
  }

  // Method to return book
  Future<void> returnBook(String bookBarcode) async {
    try {
      // First fetch the copyid and available status from bookcopies table using barcode
      final copyResponse = await client
          .from('bookcopies')
          .select('copyid, available')
          .eq('barcode', bookBarcode)
          .maybeSingle();

      if (copyResponse == null) {
        throw Exception('No book found with barcode: $bookBarcode');
      }

      final copyId = copyResponse['copyid'];
      final bool isAvailable = copyResponse['available'];

      if (isAvailable) {
        throw Exception('This book is already in the library');
      }

      // Get current date for transaction
      final transactionDate = DateTime.now().toIso8601String();

      // Insert return transaction
      await client.from('transactions').insert({
        'transactiontype': 2, // 2 for return
        'transactiondate': transactionDate,
        'copyid': copyId
      });

      print("Book return successful.");
    } catch (e) {
      print('Error returning book: $e');
      throw Exception(e.toString()); // Rethrow the error to be handled by caller
    }
  }

  // Method to fetch checked out books
  Future<List<Map<String, dynamic>>> fetchCheckedOutBooks() async {
    try {
      final response = await client
          .from('checkedoutbooks')
          .select()
          .order('duedate', ascending: true);

      if (response == null) {
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print('Error fetching checked out books: $error');
      throw error; // Rethrow error to be handled by calling code
    }
  }

  // Fetch all copies of a book by bookId
  Future<List<Map<String, dynamic>>> fetchBookCopies(int bookId) async {
    try {
      final response = await client
          .from('bookcopies')
          .select()
          .eq('bookid', bookId)
          .order('copyid');

      if (response == null) {
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print('Error fetching book copies: $error');
      throw error;
    }
  }
  // Method to update book copy barcode
  Future<void> updateBookCopyBarcode(int copyId, String newBarcode) async {
    try {
      // Check if barcode already exists
      var duplicateCheck = await client
          .from('bookcopies')
          .select('barcode')
          .eq('barcode', newBarcode);

      if ((duplicateCheck as List).isNotEmpty) {
        throw Exception('Barcode $newBarcode already exists');
      }

      // Update the barcode for the given copyId
      await client
          .from('bookcopies')
          .update({'barcode': newBarcode})
          .eq('copyid', copyId);
    } catch (error) {
      print('Error updating book copy barcode: $error');
      throw error;
    }
  }
  // Method to delete a book copy
  Future<void> deleteBookCopy(int copyId) async {
    try {
      // Check if book is currently checked out
      final bookCopy = await client
          .from('bookcopies')
          .select('available, bookid')
          .eq('copyid', copyId)
          .single();

      if (!bookCopy['available']) {
        throw Exception("Cannot delete a checked out book");
      }

      // First delete any related transactions
      await client
          .from('transactions')
          .delete()
          .eq('copyid', copyId);

      // Then delete any related bookstatus records
      await client
          .from('bookstatus')
          .delete()
          .eq('copyid', copyId);

      // Then delete the book copy
      await client
          .from('bookcopies')
          .delete()
          .eq('copyid', copyId);

      // Check total copies after deletion
      final bookInfo = await client
          .from('allbooksinfo')
          .select('totalcopies')
          .eq('bookid', bookCopy['bookid'])
          .single();

      // If no copies remain, delete the book
      if (bookInfo['totalcopies'] == 0) {
        await client
            .from('books')
            .delete()
            .eq('bookid', bookCopy['bookid']);
      }
    } catch (error) {
      print('Error deleting book copy: $error');
      throw error;
    }
  }
}
  

