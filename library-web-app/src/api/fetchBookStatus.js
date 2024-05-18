import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

export function useBookStatusView() {
  const [bookStatus, setBookStatus] = useState([]);

  useEffect(() => {
    fetchBookStatus();
  }, []);

  async function fetchBookStatus() {
    try {
      const { data, error } = await supabase
        .from('bookstatusview')
        .select('*');
      if (error) throw error;
      setBookStatus(data);
    } catch (error) {
      console.error('Error fetching book status:', error.message);
    }
  }

  return bookStatus;
}
