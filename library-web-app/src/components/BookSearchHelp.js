import { useState, useEffect } from "react";
import styles from "../styles/create.module.css"; // Import CSS module for styling

export default function BookSearchHelp({ books, selectedBook, onBookSelect }) {
  const [showSearchHelp, setShowSearchHelp] = useState(false);
  const [filteredBooks, setFilteredBooks] = useState(books);
  const [bookInput, setBookInput] = useState("");
  // const [selectedBook, setSelectedBook] = useState(null);

  useEffect(() => {
    if (selectedBook) {
      setBookInput(selectedBook.title);
    }
  }, [selectedBook]);

  const handleInputChange = (e) => {
    const inputValue = e.target.value;
    const filtered = books.filter((book) =>
      book.title.toLowerCase().includes(inputValue.toLowerCase())
    );
    setFilteredBooks(filtered);
    setShowSearchHelp(true);
    setBookInput(inputValue);
    onBookSelect(inputValue);
    // Reset selectedBook when typing
    // setSelectedBook(inputValue);
  };

  const handleBookSelect = (book) => {
    setShowSearchHelp(false);
    setBookInput(book.title);
    // setSelectedBook(book);
    onBookSelect(book);
  };

  console.log("selectedBook", selectedBook);
  return (
    <div>
      <label htmlFor="bookInput">Book Title:</label>
      <div className={styles.searchHelpContainer}>
        <input
          type="text"
          id="bookInput"
          name="bookInput"
          onChange={handleInputChange}
          value={bookInput}
          className={styles.userInput}
          placeholder="Enter book's title"
        />
        {showSearchHelp && (
          <div className={styles.searchHelp}>
            {filteredBooks.map((book) => (
              <div
                key={book.bookid}
                className={styles.user}
                onClick={() => handleBookSelect(book)}
              >
                <span>{book.title}</span>
              </div>
            ))}
          </div>
        )}
      </div>
      {selectedBook && (
        <div className={styles.userInfo}>
          <p>Book Title: {selectedBook.title}</p>
          <p>Book ID: {selectedBook.bookid}</p>
        </div>
      )}
    </div>
  );
}
