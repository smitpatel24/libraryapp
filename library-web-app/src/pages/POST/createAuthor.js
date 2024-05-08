// CreateAuthor.js

import { useState } from "react";
import { supabase } from "../../lib/supabase";
import styles from '../../styles/create.module.css';

export default function CreateAuthor() {
  const [author, setAuthor] = useState({ authorid: "", authorname: "" });
  const [message, setMessage] = useState("");

  const handleChange = (e) => {
    const { name, value } = e.target;
    setAuthor((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const { data, error } = await supabase
        .from("authors")
        .insert([{ authorname: author.authorname }]); // Corrected insertion
      if (error) throw error;
      console.log("Author created successfully:", data);
      setMessage('');
      // Redirect to the authors page after creating a new author
      window.location.href = "/GET/authors";
    } catch (error) {
      console.error("Error creating author:", error.message);
      setMessage(`Error creating author: ${error.message}`);
    }
  };

  return (
    <div className={styles.container}>
      <h1>Create New Author</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="authorname">Author Name:</label>
          <input
            type="text"
            id="authorname"
            name="authorname"
            value={author.authorname}
            onChange={handleChange}
          />
        </div>
        <button type="submit">Create Author</button>
      </form>
      {message && <p className={styles.message}>{message}</p>}
    </div>
  );
}
