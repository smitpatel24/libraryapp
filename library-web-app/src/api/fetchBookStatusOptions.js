import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase'; // Adjust the path as necessary

export function useStatusOptions() {
  const [statusOptions, setStatusOptions] = useState([]);

  useEffect(() => {
    async function fetchStatusOptions() {
      try {
        const { data, error } = await supabase
          .from('bookstatustypes')
          .select('status');
        if (error) throw error;
        setStatusOptions(data);
      } catch (error) {
        console.error('Error fetching status options:', error.message);
      }
    }

    fetchStatusOptions();
  }, []);

  return statusOptions;
}
