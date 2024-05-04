# API Contract

1. **Get all books in the library**
   - **Request:** GET /books
   - **Response:** Array of objects containing book ID, book name, author name, total copies, and available copies.

2. **Get a specific book**
   - **Request:** GET /books/:bookId
   - **Response:** Object containing book ID, book name, author name, total copies, and availability status.

3. **Get all copies info**
   - **Request:** GET /bookCopies
   - **Response:** Array of objects containing copy ID, book ID, book title, author name, barcode, and availability.

4. **Get all checked-out books**
   - **Request:** GET /checkedOutBooks
   - **Response:** Array of objects containing copy ID, book name, author name, barcode, checkout date, and due date.

5. **Get all available books**
   - **Request:** GET /availableBooks
   - **Response:** Array of objects containing copy ID, book name, author name, and barcode for available books.

6. **Get books by author**
   - **Request:** GET /booksByAuthor/:authorName
   - **Response:** Array of objects containing book ID, book name, and author name for books by a specific author.

7. **Get all readers**
   - **Request:** GET /readers
   - **Response:** Array of objects containing first name, last name, username, password, and barcode for all readers.

8. **Get all librarians**
   - **Request:** GET /librarians
   - **Response:** Array of objects containing first name, last name, username, password, and barcode for all librarians.

9. **Get all admins**
   - **Request:** GET /admins
   - **Response:** Array of objects containing first name, last name, username, password, and barcode for all admins.

10. **Get all users**
    - **Request:** GET /users
    - **Response:** Array of objects containing first name, last name, username, password, and barcode for all users.

11. **Get all transactions**
    - **Request:** GET /transactions
    - **Response:** Array of objects containing transaction ID, copy ID, username, book name, author name, transaction type, transaction date, due date, and return date for all transactions.

12. **Get a specific transaction**
    - **Request:** GET /transactions/:transactionId
    - **Response:** Object containing transaction ID, copy ID, username, book name, author name, transaction type, transaction date, due date, and return date for a specific transaction.

Only admin or librarian can perform the following actions:

13. **Create a user**
    - **Request:** POST /users
    - **Request Body:** Object containing user details (first name, last name, username, password, barcode, and user type).
    - **Response:** Success message or error message.

14. **Update a user**
    - **Request:** PUT /users/:userId
    - **Request Body:** Object containing updated user details.
    - **Response:** Success message or error message.

15. **Delete a user**
    - **Request:** DELETE /users/:userId
    - **Response:** Success message or error message.

16. **Create/update/delete authors**
    - **Request:** POST/PUT/DELETE /authors
    - **Request Body:** Object containing author details (author name).
    - **Response:** Success message or error message.

17. **Create/update/delete book copies**
    - **Request:** POST/PUT/DELETE /bookCopies
    - **Request Body:** Object containing book copy details (book ID, barcode, availability).
    - **Response:** Success message or error message.

18. **Create/update transactions**
    - **Request:** POST/PUT /transactions
    - **Request Body:** Object containing transaction details (user ID, copy ID, transaction type, transaction date, due date, return date).
    - **Response:** Success message or error message.

19. **Delete transactions**
    - **Request:** DELETE /transactions/:transactionId
    - **Response:** Success message or error message.
