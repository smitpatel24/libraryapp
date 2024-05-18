import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import styles from '../../styles/Authors.module.css'; // Import CSS module for styling
import { useAuthors } from "@/api/fetchAuthors";

export default function Authors() {
  // const [authors, setAuthors] = useState([]);
  const authors = useAuthors();
  const [filteredAuthors, setFilteredAuthors] = useState([]); // Corrected variable name

  useEffect(() => {
    setFilteredAuthors(authors);
  }, [authors]);

  // Function to handle filtering based on input value
  const handleFilter = (column, value) => {
    const filtered = authors.filter(author => {
      if (column === 'authorid') { // Corrected column name
        if (value === '') return true; // Show all authors when author ID is empty
        return parseInt(author[column]) === parseInt(value);
      } else {
        const fieldValue = author[column].toLowerCase();
        return fieldValue.includes(value.toLowerCase());
      }
    });
    setFilteredAuthors(filtered);
  };

  return (
    <div>
      <h1>All authors</h1>
      <div className={styles.tableContainer}>
        <table className={styles.table}>
          <thead>
            <tr>
              <th>Author ID</th>
              <th>Author Name</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <input
                  type="number"
                  onChange={e => handleFilter('authorid', e.target.value)}
                  className={styles.input}
                  placeholder="filter by Author ID"
                />
              </td>
              <td>
                <input
                  type="text"
                  onChange={e => handleFilter('authorname', e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Author Name"
                />
              </td>
            </tr>
            {filteredAuthors.map((author, index) => ( // Corrected variable name
              <tr key={index}>
                <td>{author.authorid}</td>
                <td>{author.authorname}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
