# API Contract

## Readers/ Admin/ Librarians can perform the following actions

1. **Get all books in the library**
   - **Request:** GET /books
   - **Response:** Array of objects containing book ID, book name, author name, total copies, and available copies.

2. **Get a specific book**
   - **Request:** GET /books/:bookId
   - **Response:** Object containing book ID, book name, author name, total copies, and availability status.

3. **Get all available books**
   - **Request:** GET /availableBooks
   - **Response:** Array of objects containing copy ID, book name, author name, and barcode for available books.

4. **Get books by author**
   - **Request:** GET /booksByAuthor/:authorName
   - **Response:** Array of objects containing book ID, book name, and author name for books by a specific author.

## Only Admin/Librarian can perform the following actions:

5. **Get all copies info**
   - **Request:** GET /bookCopies
   - **Response:** Array of objects containing copy ID, book ID, book title, author name, barcode, and availability.

6. **Get all checked-out books**
   - **Request:** GET /checkedOutBooks
   - **Response:** Array of objects containing copy ID, book name, author name, barcode, checkout date, and due date.

7. **Get all readers**
   - **Request:** GET /readers
   - **Response:** Array of objects containing first name, last name, username, password, and barcode for all readers.

8. **Get all librarians**
   - **Request:** GET /librarians
   - **Response:** Array of objects containing first name, last name, username, password, and barcode for all librarians.

9. **Get all transactions**
    - **Request:** GET /transactions
    - **Response:** Array of objects containing transaction ID, copy ID, username, book name, author name, transaction type, transaction date, due date, and return date for all transactions.

10. **Get a specific transaction**
    - **Request:** GET /transactions/:transactionId
    - **Response:** Object containing transaction ID, copy ID, username, book name, author name, transaction type, transaction date, due date, and return date for a specific transaction.

11. **Create a user**
    - **Request:** POST/users
    - **Request Body:** Object containing user details (first name, last name, username, password, barcode, and user type).
    - **Response:** Success message or error message.

12. **Create authors**
    - **Request:** POST/authors
    - **Request Body:** Object containing author details (author name).
    - **Response:** Success message or error message.

13. **Create book copies**
    - **Request:** POST/bookCopies
    - **Request Body:** Object containing book copy details (book ID, barcode, availability).
    - **Response:** Success message or error message.

14. **Create transactions**
    - **Request:** POST/transactions
    - **Request Body:** Object containing transaction details (user ID, copy ID, transaction type, transaction date, due date, return date).
    - **Response:** Success message or error message.

15. **Update/delete a user**
    - **Request:** PUT or DELETE /users/:userId
    - **Request Body:** Object containing updated user details.
    - **Response:** Success message or error message.

16. **Update/delete authors**
    - **Request:** PUT or DELETE /authors/:authorID
    - **Request Body:** Object containing author details (author name).
    - **Response:** Success message or error message.

17. **Update/delete book copies**
    - **Request:** PUT or DELETE /bookCopies/:copyId
    - **Request Body:** Object containing book copy details (book ID, barcode, availability).
    - **Response:** Success message or error message.

## Only Admins

18. **Get all admins**
   - **Request:** GET /admins
   - **Response:** Array of objects containing first name, last name, username, password, and barcode for all admins.

19. **Get all users**
    - **Request:** GET /users
    - **Response:** Array of objects containing first name, last name, username, password, and barcode for all users.

20. **Update/Delete transactions**
    - **Request:** DELETE /transactions/:transactionId
    - **Response:** Success message or error message.
