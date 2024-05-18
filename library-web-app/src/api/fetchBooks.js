import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

export function useBooks() {
  const [books, setBooks] = useState([]);

  useEffect(() => {
    fetchBooks();
  }, []);

  async function fetchBooks() {
    try {
      const { data, error } = await supabase
        .from('books')
        .select('bookid, title, authorid'); // Include authorid in the selection
      if (error) throw error;
      setBooks(data);
    } catch (error) {
      console.error('Error fetching books:', error.message);
    }
  }

  return books;
}
