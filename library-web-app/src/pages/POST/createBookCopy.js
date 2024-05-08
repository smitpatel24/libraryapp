import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import styles from '../../styles/create.module.css';
export default function CreateBookCopy() {
  const [bookCopy, setBookCopy] = useState({ bookId: '', barcode: '' });
  const [books, setBooks] = useState([]);
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetchBooks();
  }, []);

  async function fetchBooks() {
    try {
      const { data, error } = await supabase
        .from('books')
        .select('bookid, title');
      if (error) throw error;
      setBooks(data);
      console.log(data);
    } catch (error) {
      console.error('Error fetching books:', error.message);
    }
  }

  const handleChange = (e) => {
    const { name, value } = e.target;
    setBookCopy((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const { data, error } = await supabase
        .from('bookcopies')
        .insert([{ bookid: bookCopy.bookId, barcode: bookCopy.barcode }]);
      if (error) throw error;
      console.log('Book copy created successfully:', data);
      setMessage('Book copy created successfully');
      setBookCopy({ bookId: '', barcode: '' }); // Clear form after successful submission
      // Redirect to the authors page after creating a new author
      window.location.href = "/GET/booksCopies";
    } catch (error) {
      console.error('Error creating book copy:', error.message);
      setMessage(`Error creating book copy: ${error.message}`);
    }
  };

  return (
    <div className={styles.container}>
      <h1>Create New Book Copy</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="bookId">Book:</label>
          <select
            id="bookId"
            name="bookId"
            value={bookCopy.bookId}
            onChange={handleChange}
          >
            <option value="">Select Book</option>
            {books.map((book) => (
              <option key={book.bookid} value={book.bookid}>
                {book.title}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label htmlFor="barcode">Barcode:</label>
          <input
            type="text"
            id="barcode"
            name="barcode"
            value={bookCopy.barcode}
            onChange={handleChange}
          />
        </div>
        <button type="submit">Create Book Copy</button>
      </form>
      {message && <p className={styles.message}>{message}</p>}
    </div>
  );
}
