import { useState } from "react";
import styles from '../../styles/create.module.css';
import { createAuthor } from '../../api/createAuthor';

export default function CreateAuthor() {
  const [authorName, setAuthorName] = useState("");
  const [message, setMessage] = useState("");

  const handleChange = (e) => {
    setAuthorName(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const { success, error } = await createAuthor(authorName);
    if (success) {
      setMessage("");
      // Redirect to the authors page after creating a new author
      window.location.href = "/GET/authors";
    } else {
      setMessage(`Error creating author: ${error}`);
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
            value={authorName}
            onChange={handleChange}
          />
        </div>
        <button type="submit">Create Author</button>
      </form>
      {message && <p className={styles.message}>{message}</p>}
    </div>
  );
}
