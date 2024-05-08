import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import styles from '../../styles/create.module.css';

export default function CreateBook() {
  const [book, setBook] = useState({ title: '', authorId: '' });
  const [authors, setAuthors] = useState([]);
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetchAuthors();
  }, []);

  async function fetchAuthors() {
    try {
      const { data, error } = await supabase
        .from('authors')
        .select('authorid, authorname');
      if (error) throw error;
      setAuthors(data);
    } catch (error) {
      console.error('Error fetching authors:', error.message);
    }
  }

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
      const { data, error } = await supabase
        .from('books')
        .insert([{ title: book.title, authorid: book.authorId }]);
      if (error) throw error;
      console.log('Book created successfully:', data);
      setMessage('Book created successfully');
      setBook({ title: '', authorId: '' }); // Clear form after successful submission
      // Redirect to the authors page after creating a new author
      window.location.href = "/GET/books";
    } catch (error) {
      console.error('Error creating book:', error.message);
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
