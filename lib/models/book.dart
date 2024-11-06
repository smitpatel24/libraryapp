// Book represents a physical copy in the library
class Book {
  final int bookId;    // Reference to the general book information
  final int copyId;    // Unique identifier for this physical copy
  final String title;
  final String authorName;
  final int? authorId;
  final String barcode;

  Book({
    required this.bookId,
    required this.copyId,
    required this.title,
    required this.authorName,
    this.authorId,
    required this.barcode,
  });

  // Factory constructor from bookcopiesview
  factory Book.fromView(Map<String, dynamic> json) => Book(
    bookId: json['bookid'],
    copyId: json['copyid'],
    title: json['booktitle'],
    authorName: json['authorname'],
    authorId: json['authorid'],
    barcode: json['barcode'],
  );

  // Useful getter to combine bookId and copyId if needed
  String get uniqueIdentifier => '$bookId-$copyId';
}

// DTO for book transaction (checkout/return)
class BookTransaction {
  final int bookId;
  final int copyId;
  final int userId;
  final DateTime transactionDate;
  final TransactionType type;
  
  // Fields specific to returns
  final DateTime? returnDate;
  final String? returnNotes;

  BookTransaction({
    required this.bookId,
    required this.copyId,
    required this.userId,
    required this.transactionDate,
    required this.type,
    this.returnDate,
    this.returnNotes,
  });

  Map<String, dynamic> toJson() {
  return {
    'bookId': bookId,
    'copyId': copyId,
    'userId': userId,
    'transactionDate': transactionDate.toIso8601String(),
    'transactionType': type.value,
    'returnDate': returnDate?.toIso8601String(),
    'returnNotes': returnNotes,
  };
}
}

enum TransactionType {
  checkout(1),
  returnTransaction(2);

  final int value;
  const TransactionType(this.value);

  factory TransactionType.fromValue(int value) {
    return TransactionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => TransactionType.checkout,
    );
  }
}