import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import styles from '../../styles/Books.module.css'; // Import CSS module for styling

export default function Books() {
  const [books, setBooks] = useState([]);
  const [filteredBooks, setFilteredBooks] = useState([]);
  const [totalCopiesFilter, setTotalCopiesFilter] = useState({ min: '', max: '' });
  const [availableCopiesFilter, setAvailableCopiesFilter] = useState({ min: '', max: '' });

  useEffect(() => {
    fetchBooks();
  }, []);

  async function fetchBooks() {
    try {
      const { data, error } = await supabase
        .from('allbooksinfo')
        .select('*');
      if (error) throw error;
      setBooks(data);
      setFilteredBooks(data); // Initialize filtered books with all books
    } catch (error) {
      console.error('Error fetching books:', error.message);
    }
  }

  // Function to handle filtering based on input value
  const handleFilter = (column, value) => {
    const filtered = books.filter(book => {
      if (column === 'bookid') {
        if (value === '') return true; // Show all books when book ID is empty
        return parseInt(book[column]) === parseInt(value);
      } else {
        const fieldValue = book[column].toLowerCase();
        return fieldValue.includes(value.toLowerCase());
      }
    });
    setFilteredBooks(filtered);
  };

  // Function to handle range filtering for total copies
  const handleTotalCopiesFilter = () => {
    const filtered = books.filter(book => {
      const totalCopies = parseInt(book.totalcopies);
      const min = totalCopiesFilter.min !== '' ? parseInt(totalCopiesFilter.min) : 0;
      const max = totalCopiesFilter.max !== '' ? parseInt(totalCopiesFilter.max) : Number.MAX_SAFE_INTEGER;
      return totalCopies >= min && totalCopies <= max;
    });
    setFilteredBooks(filtered);
  };

  // Function to handle range filtering for available copies
  const handleAvailableCopiesFilter = () => {
    const filtered = books.filter(book => {
      const availableCopies = parseInt(book.available);
      const min = availableCopiesFilter.min !== '' ? parseInt(availableCopiesFilter.min) : 0;
      const max = availableCopiesFilter.max !== '' ? parseInt(availableCopiesFilter.max) : Number.MAX_SAFE_INTEGER;
      return availableCopies >= min && availableCopies <= max;
    });
    setFilteredBooks(filtered);
  };

  return (
    <div>
      <h1>All Books</h1>
      <div className={styles.tableContainer}>
        <table className={styles.table}>
          <thead>
            <tr>
              <th>Book ID</th>
              <th>Book Name</th>
              <th>Author Name</th>
              <th>Total Copies</th>
              <th>Available Copies</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <input
                  type="number"
                  onChange={e => handleFilter('bookid', e.target.value)}
                  className={styles.input}
                  placeholder="ID"
                />
              </td>
              <td>
                <input
                  type="text"
                  onChange={e => handleFilter('bookname', e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Book Name"
                />
              </td>
              <td>
                <input
                  type="text"
                  onChange={e => handleFilter('authorname', e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Author Name"
                />
              </td>
              <td>
                <input
                  type="number"
                  value={totalCopiesFilter.min}
                  onChange={e => setTotalCopiesFilter({ ...totalCopiesFilter, min: e.target.value })}
                  onBlur={handleTotalCopiesFilter}
                  placeholder="Min"
                  className={styles.input}
                />
                {' to '}
                <input
                  type="number"
                  value={totalCopiesFilter.max}
                  onChange={e => setTotalCopiesFilter({ ...totalCopiesFilter, max: e.target.value })}
                  onBlur={handleTotalCopiesFilter}
                  placeholder="Max"
                  className={styles.input}
                />
              </td>
              <td>
                <input
                  type="number"
                  value={availableCopiesFilter.min}
                  onChange={e => setAvailableCopiesFilter({ ...availableCopiesFilter, min: e.target.value })}
                  onBlur={handleAvailableCopiesFilter}
                  placeholder="Min"
                  className={styles.input}
                />
                {' to '}
                <input
                  type="number"
                  value={availableCopiesFilter.max}
                  onChange={e => setAvailableCopiesFilter({ ...availableCopiesFilter, max: e.target.value })}
                  onBlur={handleAvailableCopiesFilter}
                  placeholder="Max"
                  className={styles.input}
                />
              </td>
            </tr>
            {filteredBooks.map((book, index) => (
              <tr key={index}>
                <td>{book.bookid}</td>
                <td>{book.bookname}</td>
                <td>{book.authorname}</td>
                <td>{book.totalcopies}</td>
                <td>{book.available}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
