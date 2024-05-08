import { useState } from "react";
import styles from "../styles/create.module.css"; // Import CSS module for styling

export default function BookCopySearchHelp({
  bookCopies,
  users,
  onBookSelect,
}) {
  const [showSearchHelp, setShowSearchHelp] = useState(false);
  const [filteredBookCopies, setFilteredBookCopies] = useState(bookCopies);
  const [selectedBarcode, setSelectedBarcode] = useState("");
  const [bookCopyInput, setBookCopyInput] = useState("");
  const [selectedBookCopy, setSelectedBookCopy] = useState(null);

  const handleInputChange = (e) => {
    const inputValue = e.target.value.toLowerCase();
    const filtered = bookCopies.filter((bookCopy) => {
      return (
        bookCopy.booktitle.toLowerCase().includes(inputValue) ||
        bookCopy.authorname.toLowerCase().includes(inputValue) ||
        bookCopy.barcode.toLowerCase().includes(inputValue)
      );
    });
    setFilteredBookCopies(filtered);
    setShowSearchHelp(true);
    setBookCopyInput(inputValue); // Update bookCopyInput
  };

  const handleBookCopySelect = (bookCopy) => {
    setSelectedBarcode(bookCopy.barcode);
    setShowSearchHelp(false);
    setBookCopyInput(bookCopy.barcode); // Update bookCopyInput with selected barcode
    setSelectedBookCopy(bookCopy); // Update selectedBookCopy with selected bookCopy
    onBookSelect(bookCopy); // Update selectedBookCopy with selected bookCopy
  };

  return (
    <div>
      <label htmlFor="bookCopyInput">Book Barcode/Title/Author:</label>

      <div className={styles.searchHelpContainer}>
        <input
          type="text"
          id="bookCopyInput"
          name="bookCopyInput"
          onChange={handleInputChange}
          value={bookCopyInput}
          className={styles.userInput}
          placeholder="Enter book's Barcode, Title, or Author"
        />
        {showSearchHelp && (
          <div className={styles.searchHelp}>
            {filteredBookCopies.map((bookCopy) => (
              <div
                key={bookCopy.copyid}
                className={styles.user}
                onClick={() => handleBookCopySelect(bookCopy)}
              >
                <span>
                  {bookCopy.booktitle} by {bookCopy.authorname} -{" "}
                  {bookCopy.barcode}
                </span>
              </div>
            ))}
          </div>
        )}
        <input type="hidden" id="selectedBarcode" value={selectedBarcode} />
      </div>
      {selectedBookCopy && (
        <div className={styles.userInfo}>
          <p>Book Title: {selectedBookCopy.booktitle}</p>
          <p>Author Name: {selectedBookCopy.authorname}</p>
          <p>Barcode: {selectedBookCopy.barcode}</p>
          <p>
            {selectedBookCopy.available
              ? "Available: Yes"
              : `Borrowed by username: ${
                  users.find((user) => user.userid === selectedBookCopy.userid)
                    .username
                } (userId: ${selectedBookCopy.userid})`}
          </p>
        </div>
      )}
    </div>
  );
}
