import { supabase } from "../lib/supabase";

export async function createBook(title, authorId) {
  try {
    const { data, error } = await supabase
      .from("books")
      .insert([{ title, authorid: authorId }])
      .select("*");
    if (error) throw error;

    // Extract the bookId from the response data
    const bookId = data[0]?.bookid;
    if (!bookId) throw new Error("Book ID not found in response.");

    console.log("Book created successfully:", bookId);
    return { success: true, bookId, message: "Book created successfully" };
  } catch (error) {
    console.error("Error creating book:", error.message);
    return { success: false, message: `Error creating book: ${error.message}` };
  }
}
