import React, { useState, useEffect } from "react";
import { useBookStatusView } from "@/api/fetchBookStatus";
import styles from "../../styles/Books.module.css"; // Import CSS module for styling
import { useStatusOptions } from "@/api/fetchBookStatusOptions";

export default function BookStatus() {
  const bookStatus = useBookStatusView();
  const statusOptions = useStatusOptions();
  const [filteredStatus, setFilteredStatus] = useState([]);

  const today = new Date();
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 2);

  const [filters, setFilters] = useState({
    copyId: "",
    bookId: "",
    bookTitle: "",
    authorName: "",
    barcode: "",
    status: "",
    startDate: new Date(0).toISOString().split('T')[0], // Most previous date possible
    endDate: tomorrow.toISOString().split('T')[0], // Tomorrow's date
  });

  useEffect(() => {
    setFilteredStatus(bookStatus);
  }, [bookStatus]);

  const handleFilter = (column, value) => {
    setFilters((prevFilters) => ({ ...prevFilters, [column]: value }));

    const filtered = bookStatus.filter((copy) => {
      console.log(copy, column, value); // Log the copy object
      if (column === "bookid" || column === "copyid") {
        if (value < 1) return true; // Show all copies when ID is empty
        return parseInt(copy[column]) === parseInt(value);
      } else if (column === "available") {
        if (value === "" || value === "all") return true; // Show all copies when available filter is empty
        const available = value === "yes" || value === "true";
        return copy[column] === available;
      } else if (column === "status") {
        if (value === "" || value === "all") return true; // Show all copies when status filter is empty
        return copy.status === value;
      } else if (column === "startDate" || column === "endDate") {
        const startDate = column === "startDate" ? new Date(value) : new Date(filters.startDate);
        const endDate = column === "endDate" ? new Date(value) : new Date(filters.endDate);
        const copyDate = new Date(copy.statusdate);

        console.log("copyDate:", copyDate);
        console.log("startDate:", startDate);
        console.log("endDate:", endDate);

        if (startDate && endDate) {
          console.log(
            "copyDate >= startDate && copyDate <= endDate",
            copyDate >= startDate && copyDate <= endDate
          );
          return copyDate >= startDate && copyDate <= endDate;
        } else if (startDate) {
          console.log("copyDate >= startDate", copyDate >= startDate);
          return copyDate >= startDate;
        } else if (endDate) {
          console.log("copyDate <= endDate", copyDate <= endDate);
          return copyDate <= endDate;
        }
        return true;
        const fieldValue = copy[column].toLowerCase();
        return fieldValue.includes(value.toLowerCase());
      }
    });
    setFilteredStatus(filtered);
  };
  console.log("filtered", filteredStatus);
  return (
    <div>
      <h1>Book Status</h1>
      <div className={styles.tableContainer}>
        <table className={styles.table}>
          <thead>
            <tr>
              <th>Copy ID</th>
              <th>Book ID</th>
              <th>Book Title</th>
              <th>Author Name</th>
              <th>Barcode</th>
              <th>Status</th>
              <th>Status Date</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <input
                  type="number"
                  onChange={(e) => handleFilter("copyid", e.target.value)}
                  className={styles.input}
                  placeholder="ID"
                />
              </td>
              <td>
                <input
                  type="number"
                  onChange={(e) => handleFilter("bookid", e.target.value)}
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
              <td>
                <input
                  type="date"
                  onChange={(e) => handleFilter("startDate", e.target.value)}
                  className={styles.input}
                  placeholder="Start Date"
                />
                to
                <input
                  type="date"
                  onChange={(e) => handleFilter("endDate", e.target.value)}
                  className={styles.input}
                  placeholder="End Date"
                />
              </td>
            </tr>
            {filteredStatus.map((status, index) => (
              <tr key={index}>
                <td>{status.copyid}</td>
                <td>{status.bookid}</td>
                <td>{status.booktitle}</td>
                <td>{status.authorname}</td>
                <td>{status.barcode}</td>
                <td>{status.status}</td>
                <td>{new Date(status.statusdate).toLocaleDateString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
