  import { supabase } from '../lib/supabase';

  export async function createBookCopy(bookId, barcode) {
    try {
      const { data, error } = await supabase
        .from('bookcopies')
        .insert([{ bookid: bookId, barcode: barcode }]);
      if (error) throw error;
      console.log('Book copy created successfully:', data);
      return { success: true, message: 'Book copy created successfully' };
    } catch (error) {
      console.error('Error creating book copy:', error.message);
      return { success: false, message: `Error creating book copy: ${error.message}` };
    }
  }
