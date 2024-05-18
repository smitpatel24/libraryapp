import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

export function useBookCopies() {
  const [bookCopies, setBookCopies] = useState([]);

  useEffect(() => {
    fetchBookCopies();
  }, []);

  async function fetchBookCopies() {
    try {
      const { data, error } = await supabase
        .from('bookcopiesview')
        .select('*');
        // .select('CopyID, BookID, Barcode');
      if (error) throw error;
      setBookCopies(data);
    } catch (error) {
      console.error('Error fetching book copies:', error.message);
    }
  }

  return bookCopies;
}
