import { useState, useEffect } from "react";
import { supabase } from "../../lib/supabase";
import styles from "../../styles/create.module.css";
import AuthorSearchHelp from "@/components/AuthorSearchHelp";
import BookSearchHelp from "@/components/BookSearchHelp";
import { useAuthors } from "@/api/fetchAuthors";
import { createAuthor } from "@/api/createAuthor";
import { useBooks } from "@/api/fetchBooks";
import { createBook } from "@/api/createBook";
import { useBookCopies } from "@/api/fetchBookCopies";
import { createBookCopy } from "@/api/createBookCopy";

export default function CreateBookCopy() {
  const [bookCopy, setBookCopy] = useState({ bookId: "", barcode: "" });
  const [message, setMessage] = useState("");
  const [selectedAuthor, setSelectedAuthor] = useState(null);
  const [selectedBook, setSelectedBook] = useState(null);
  const [barcode, setBarcode] = useState("");

  const books = useBooks();
  const bookCopies = useBookCopies();
  const authors = useAuthors();

  const handleAuthorSelect = (author) => {
    setSelectedAuthor(author);
    // Additional logic can be added here if needed
  };

  const handleBookSelect = (book) => {
    setSelectedBook(book); // Set the selected book ID in bookCopy
    if (book) {
      const author = authors.find(
        (author) => author.authorid === book.authorid
      );
      if (author) {
        setSelectedAuthor(author);
      }
    }
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    if (name === "barcode") {
      setBarcode(value);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // Check if selectedBook, selectedAuthor, and barcode are not null or empty
      if (!selectedBook) {
        setMessage("Please select a book");
        return;
      }
      if (!selectedAuthor) {
        setMessage("Please select an author");
        return;
      }
      if (!barcode) {
        setMessage("Please share a barcode.");
        return;
      }
  
      console.log(
        "Creating a book copy: ",
        selectedBook,
        selectedAuthor,
        barcode
      );
  
      // Check if barcode already exists in bookCopies
      const existingBookCopy = bookCopies.find(
        (copy) => copy.barcode === barcode
      );
      if (existingBookCopy) {
        setMessage(
          `Barcode already exists for Book ID: ${existingBookCopy.BookID}, Book Title: ${existingBookCopy.BookTitle}, Author Name: ${existingBookCopy.AuthorName}`
        );
        return;
      }
  
      let selectedAuthorId, selectedBookId;
      if (!selectedAuthor.authorid) {
        // Create author if not found
        const newAuthor = await createAuthor(selectedAuthor);
        if (!newAuthor.success) {
          setMessage(`Error creating author: ${newAuthor.message}`);
          return;
        }
        // Use the newly created author's ID
        selectedAuthorId = newAuthor.authorId;
      } else {
        // Use the existing author's ID
        selectedAuthorId = selectedAuthor.authorid;
      }
  
      // Check if selected book exists in books
      // const existingBook = books.find((book) => book.title === selectedBook);
      if (!selectedBook.bookId) {
        // Create book if not found
        const newBook = await createBook(selectedBook, selectedAuthorId);
        if (!newBook.success) {
          setMessage(`Error creating book: ${newBook.message}`);
          return;
        }
        // Use the newly created book's ID
        selectedBookId = newBook.bookId;
      } else {
        // Use the existing book's ID
        selectedBookId = selectedBook.bookId
      }
      
      console.log(
        "Creating a book copy: ",
        selectedBookId,
        selectedAuthorId,
        barcode)
      // Create book copy
      const { success, message } = await createBookCopy(selectedBookId, barcode);
      if (success) {
        setMessage(message);
        setBookCopy({ bookId: selectedBookId, barcode: barcode });
      } else {
        setMessage(`Error creating book copy: ${message}`);
      }
    } catch (error) {
      console.error("Error creating book copy:", error.message);
      setMessage(`Error creating book copy: ${error.message}`);
    }
  };
  

  return (
    <div className={styles.container}>
      <h1>Create New Book Copy</h1>
      <form onSubmit={handleSubmit}>
        <BookSearchHelp
          books={books}
          onBookSelect={handleBookSelect}
          selectedBook={selectedBook}
        />
        <AuthorSearchHelp
          authors={authors}
          onAuthorSelect={handleAuthorSelect}
          selectedAuthor={selectedAuthor}
        />
        <div>
          <label htmlFor="barcode">Barcode:</label>
          <input
            type="text"
            id="barcode"
            name="barcode"
            value={barcode}
            onChange={handleChange} // Use handleChange for barcode input
          />
        </div>

        <button type="submit">Create Book Copy</button>
      </form>
      {message && <p className={styles.message}>{message}</p>}
    </div>
  );
}
