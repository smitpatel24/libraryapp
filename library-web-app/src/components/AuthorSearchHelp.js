import { useState, useEffect } from "react";
import styles from "../styles/create.module.css"; // Import CSS module for styling

export default function AuthorSearchHelp({
  authors,
  selectedAuthor,
  onAuthorSelect,
}) {
  const [showSearchHelp, setShowSearchHelp] = useState(false);
  const [filteredAuthors, setFilteredAuthors] = useState(authors);
  const [authorInput, setAuthorInput] = useState("");

  useEffect(() => {
    if (selectedAuthor) {
      setAuthorInput(selectedAuthor.authorname);
    }
  }, [selectedAuthor]);

  const handleInputChange = (e) => {
    const inputValue = e.target.value;
    const filtered = authors.filter((author) =>
      author.authorname.toLowerCase().includes(inputValue.toLowerCase())
    );
    setFilteredAuthors(filtered);
    setShowSearchHelp(true);
    setAuthorInput(inputValue);
    // Reset selectedAuthor when typing
    onAuthorSelect(inputValue);
    // setSelectedAuthor(inputValue);
  };

  const handleAuthorSelect = (author) => {
    setShowSearchHelp(false);
    setAuthorInput(author.authorname);
    onAuthorSelect(author);
    // setSelectedAuthor(author);
  };

  console.log("selectedAuthor", selectedAuthor);
  return (
    <div>
      <label htmlFor="authorInput" className={styles.label}>
        Author Name:
      </label>
      <div className={styles.searchHelpContainer}>
        <input
          type="text"
          id="authorInput"
          name="authorInput"
          onChange={handleInputChange}
          value={authorInput}
          className={styles.userInput}
          placeholder="Enter author's name"
        />
        {showSearchHelp && (
          <div className={styles.searchHelp}>
            {filteredAuthors.map((author) => (
              <div
                key={author.authorid}
                className={styles.searchItem}
                onClick={() => handleAuthorSelect(author)}
              >
                <span>{author.authorname}</span>
              </div>
            ))}
          </div>
        )}
      </div>
      {selectedAuthor && (
        <div className={styles.userInfo}>
          <p>Author Name: {selectedAuthor.authorname}</p>
          <p>Author ID: {selectedAuthor.authorid}</p>
        </div>
      )}
    </div>
  );
}
