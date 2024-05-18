import { useState, useEffect } from "react";
import { useAuthors } from "@/api/fetchAuthors";
import { createBook } from "@/api/fetchAuthors";
import styles from "../../styles/create.module.css";

export default function CreateBookPage() {
  const [book, setBook] = useState({ title: "", authorId: "" });
  const authors = useAuthors();
  const [message, setMessage] = useState("");

  const handleChange = (e) => {
    const { name, value } = e.target;
    setBook((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const { success, message } = await createBook(book.title, book.authorId);
      setMessage(message);
      if (success) {
        setBook({ title: "", authorId: "" }); // Clear form after successful submission
        // Redirect to the authors page after creating a new book
        window.location.href = "/GET/books";
      }
    } catch (error) {
      console.error("Error creating book:", error.message);
      setMessage(`Error creating book: ${error.message}`);
    }
  };

  return (
    <div className={styles.container}>
      <h1>Create New Book</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="title">Title:</label>
          <input
            type="text"
            id="title"
            name="title"
            value={book.title}
            onChange={handleChange}
          />
        </div>
        <div>
          <label htmlFor="authorId">Author:</label>
          <select
            id="authorId"
            name="authorId"
            value={book.authorId}
            onChange={handleChange}
          >
            <option value="">Select Author</option>
            {authors.map((author) => (
              <option key={author.authorid} value={author.authorid}>
                {author.authorname}
              </option>
            ))}
          </select>
        </div>
        <button type="submit">Create Book</button>
      </form>
      {message && <p className={styles.message}>{message}</p>}
    </div>
  );
}
