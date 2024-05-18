import { useState, useEffect } from "react";
import { supabase } from "../../lib/supabase";
import styles from "../../styles/Books.module.css"; // Import CSS module for styling

export default function BooksCopies() {
  const [copies, setCopies] = useState([]);
  const [filteredCopies, setFilteredCopies] = useState([]);
  const [filters, setFilters] = useState({
    copyId: "",
    bookId: "",
    bookTitle: "",
    authorName: "",
    barcode: "",
    available: "",
  });
  const [statusOptions, setStatusOptions] = useState([]);

  useEffect(() => {
    fetchCopies();
    fetchStatusOptions();
  }, []);

  async function fetchCopies() {
    try {
      const { data, error } = await supabase.from("bookcopiesview").select("*");
      if (error) throw error;
      setCopies(data);
      setFilteredCopies(data); // Initialize filtered copies with all copies
    } catch (error) {
      console.error("Error fetching book copies:", error.message);
    }
  }

  async function fetchStatusOptions() {
    try {
      const { data, error } = await supabase
        .from("bookstatustypes")
        .select("status");
      if (error) throw error;
      setStatusOptions(data);
      console.log(data);
    } catch (error) {
      console.error("Error fetching status options:", error.message);
    }
  }

  // Function to handle filtering based on input value
  const handleFilter = (column, value) => {
    const filtered = copies.filter((copy) => {
      console.log(copy); // Log the copy object
      if (column === "bookId" || column === "copyId") {
        if (value === "") return true; // Show all copies when ID is empty
        return parseInt(copy[column]) === parseInt(value);
      } else if (column === "available") {
        if (value === "" || value === "all") return true; // Show all copies when available filter is empty
        const available = value === "yes" || value === "true";
        return copy[column] === available;
      } else if (column === "status") {
        if (value === "" || value === "all") return true; // Show all copies when status filter is empty
        return copy.status === value;
      } else {
        const fieldValue = copy[column].toLowerCase();
        return fieldValue.includes(value.toLowerCase());
      }
    });
    setFilteredCopies(filtered);
  };
  console.log("copies", copies);
  console.log("StatusOptions", statusOptions);
  return (
    <div>
      <h1>Book Copies</h1>
      <div className={styles.tableContainer}>
        <table className={styles.table}>
          <thead>
            <tr>
              <th>Copy ID</th>
              <th>Book ID</th>
              <th>Book Title</th>
              <th>Author Name</th>
              <th>Barcode</th>
              <th>Available</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <input
                  type="number"
                  onChange={(e) => handleFilter("copyId", e.target.value)}
                  className={styles.input}
                  placeholder="ID"
                />
              </td>
              <td>
                <input
                  type="number"
                  onChange={(e) => handleFilter("bookId", e.target.value)}
                  className={styles.input}
                  placeholder="ID"
                />
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("booktitle", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Book Title"
                />
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("authorname", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Author Name"
                />
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("barcode", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Barcode"
                />
              </td>
              <td>
                <select
                  value={filters.available}
                  onChange={(e) => handleFilter("available", e.target.value)}
                >
                  <option value="">Filter by Available</option>
                  <option value="yes">Yes</option>
                  <option value="no">No</option>
                  <option value="all">All</option>
                </select>
              </td>
              <td>
                <select
                  value={filters.status}
                  onChange={(e) => handleFilter("status", e.target.value)}
                >
                  <option value="">Filter by Status</option>
                  {statusOptions.map((status, index) => (
                    <option key={index} value={status.status}>
                      {status.status}
                    </option>
                  ))}
                  <option value="all">All</option>
                </select>
              </td>
            </tr>
            {filteredCopies.map((copy, index) => (
              <tr key={index}>
                <td>{copy.copyid}</td>
                <td>{copy.bookid}</td>
                <td>{copy.booktitle}</td>
                <td>{copy.authorname}</td>
                <td>{copy.barcode}</td>
                <td>{copy.available ? "Yes" : "No"}</td>
                <td>{copy.status}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
