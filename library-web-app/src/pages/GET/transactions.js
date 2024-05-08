import { useState, useEffect } from "react";
import { supabase } from "../../lib/supabase";
import styles from "../../styles/Transactions.module.css"; // Import CSS module for styling

export default function Transactions() {
  const [transactions, setTransactions] = useState([]);
  const [transactionTypes, setTransactionTypes] = useState([]);
  const [filteredTransactions, setFilteredTransactions] = useState([]);
  const [transactionTypeFilter, setTransactionTypeFilter] = useState("");
  const [transactionDateRange, setTransactionDateRange] = useState({
    startDate: "",
    endDate: "",
  });
  const [dueDateRange, setDueDateRange] = useState({
    startDate: "",
    endDate: "",
  });
  const [returnDateRange, setReturnDateRange] = useState({
    startDate: "",
    endDate: "",
  });

  useEffect(() => {
    fetchTransactions();
    fetchTransactionTypes();
  }, []);

  async function fetchTransactions() {
    try {
      const { data, error } = await supabase
        .from("transactionsview")
        .select("*");
      if (error) throw error;
      setTransactions(data);
      setFilteredTransactions(data); // Initialize filtered transactions with all transactions
    } catch (error) {
      console.error("Error fetching transactions:", error.message);
    }
  }

  async function fetchTransactionTypes() {
    try {
      const { data, error } = await supabase
        .from("transactiontypes")
        .select("*");
      if (error) throw error;
      setTransactionTypes(data);
    } catch (error) {
      console.error("Error fetching transaction types:", error.message);
    }
  }
  const handleFilter = (column, value) => {
    const filterValue = value.toLowerCase();

    const filtered = transactions.filter((transaction) => {
      if (column === "transactionid" || column === "copyid") {
        if (value === "") return true; // Show all transactions
        return parseInt(transaction[column]) === parseInt(value);
      } else {
        // console.log("transaction", transaction);
        const fieldValue = transaction[column].toLowerCase();
        return fieldValue.includes(filterValue);
      }
    });

    setFilteredTransactions(filtered);
  };

  const handleTransactionTypeFilter = (value) => {
    setTransactionTypeFilter(value);
    if (value === "") {
      setFilteredTransactions(transactions);
    } else {
      const filtered = transactions.filter((transaction) => {
        return transaction.transactiontype === value;
      });
      setFilteredTransactions(filtered);
    }
  };

  const handleTransactionDateRangeFilter = () => {
    const endDate = transactionDateRange.endDate
      ? transactionDateRange.endDate
      : new Date().toISOString().split("T")[0];

    const filtered = filteredTransactions.filter((transaction) => {
      const transactionDate = new Date(transaction.transactiondate);
      const dueDate = new Date(transaction.duedate);
      const returnDate = new Date(transaction.returndate);

      const isWithinTransactionDateRange = isDateWithinRange(
        transactionDate,
        transactionDateRange.startDate,
        endDate // Use today's date if end date is not provided
      );
      const isWithinDueDateRange = isDateWithinRange(
        dueDate,
        dueDateRange.startDate,
        dueDateRange.endDate
      );
      const isWithinReturnDateRange = isDateWithinRange(
        returnDate,
        returnDateRange.startDate,
        returnDateRange.endDate
      );

      return (
        isWithinTransactionDateRange &&
        isWithinDueDateRange &&
        isWithinReturnDateRange
      );
    });
    setFilteredTransactions(filtered);
  };

  const isDateWithinRange = (date, startDate, endDate) => {
    if (!startDate || !endDate) return true; // If no date range specified, consider all dates

    return date >= new Date(startDate) && date <= new Date(endDate);
  };
  return (
    <div>
      <h1>All Transactions</h1>
      <div className={styles.filters}>
        <div className={styles.filter}>
          <label>Transaction Date Range:</label>
          <input
            type="date"
            value={transactionDateRange.startDate}
            onChange={(e) =>
              setTransactionDateRange({
                ...transactionDateRange,
                startDate: e.target.value,
              })
            }
          />
          <input
            type="date"
            value={transactionDateRange.endDate}
            onChange={(e) =>
              setTransactionDateRange({
                ...transactionDateRange,
                endDate: e.target.value,
              })
            }
          />
        </div>
        <div className={styles.filter}>
          <label>Due Date Range:</label>
          <input
            type="date"
            value={dueDateRange.startDate}
            onChange={(e) =>
              setDueDateRange({ ...dueDateRange, startDate: e.target.value })
            }
          />
          <input
            type="date"
            value={dueDateRange.endDate}
            onChange={(e) =>
              setDueDateRange({ ...dueDateRange, endDate: e.target.value })
            }
          />
        </div>
        <div className={styles.filter}>
          <label>Return Date Range:</label>
          <input
            type="date"
            value={returnDateRange.startDate}
            onChange={(e) =>
              setReturnDateRange({
                ...returnDateRange,
                startDate: e.target.value,
              })
            }
          />
          <input
            type="date"
            value={returnDateRange.endDate}
            onChange={(e) =>
              setReturnDateRange({
                ...returnDateRange,
                endDate: e.target.value,
              })
            }
          />
        </div>
        <button
          className={styles.filterButton}
          onClick={handleTransactionDateRangeFilter}
        >
          Apply Filters
        </button>
      </div>
      <div className={styles.tableContainer}>
        <table className={styles.table}>
          <thead>
            <tr>
              <th>Transaction ID</th>
              <th>Copy ID</th>
              <th>Username</th>
              <th>Book Name</th>
              <th>Author Name</th>
              <th>Transaction Type</th>
              <th>Transaction Date</th>
              <th>Due Date</th>
              <th>Return Date</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <input
                  type="number"
                  onChange={(e) =>
                    handleFilter("transactionid", e.target.value)
                  }
                  className={styles.input}
                  placeholder="Dilter by Transaction ID"
                ></input>
              </td>
              <td>
                <input
                  type="number"
                  onChange={(e) => handleFilter("copyid", e.target.value)}
                  className={styles.input}
                  placeholder="Filter on Copy ID"
                ></input>
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("username", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Username"
                ></input>
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("bookname", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Book Name"
                ></input>
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("authorname", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Author Name"
                ></input>
              </td>
              <td>
                <select
                  value={transactionTypeFilter}
                  onChange={(e) => handleTransactionTypeFilter(e.target.value)}
                  className={styles.input}
                >
                  <option value="">Filter by Transaction Type</option>
                  {transactionTypes.map((type) => (
                    <option key={type.id} value={type.type}>
                      {type.type}
                    </option>
                  ))}
                </select>
              </td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
            {filteredTransactions.map((transaction, index) => (
              <tr key={index}>
                <td>{transaction.transactionid}</td>
                <td>{transaction.copyid}</td>
                <td>{transaction.username}</td>
                <td>{transaction.bookname}</td>
                <td>{transaction.authorname}</td>
                <td>{transaction.transactiontype}</td>
                <td>{transaction.transactiondate}</td>
                <td>{transaction.duedate}</td>
                <td>{transaction.returndate}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
