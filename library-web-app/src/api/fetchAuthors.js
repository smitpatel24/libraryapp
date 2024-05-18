import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

export function useAuthors() {
  const [authors, setAuthors] = useState([]);

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

  return authors;
}
