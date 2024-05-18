import { supabase } from "../lib/supabase";

export async function createAuthor(authorName) {
  try {
    console.log("Creating author with name:", authorName);

    // Insert author into the "authors" table and select the inserted data
    const { data, error } = await supabase
      .from("authors")
      .insert([{ authorname: authorName }])
      .select("*");

    if (error) throw error;

    if (data && data.length > 0) {
      const authorId = data[0]?.authorid; // Get the authorId from the response

      console.log("Author created successfully with ID:", authorId);
      return { success: true, authorId };
    } else {
      console.error("Author creation failed: No data returned.");
      return { success: false, message: "Author creation failed." };
    }
  } catch (error) {
    console.error("Error creating author:", error.message);
    return { success: false, error: error.message };
  }
}
