import { useState, useEffect } from "react";
import { supabase } from "../../lib/supabase";
import styles from "../../styles/create.module.css";
import UsersSearchHelp from "@/components/UsersSearchHelp";
import BookCopySearchHelp from "@/components/BookCopySearchHelp";

export default function CreateTransactionPage() {
  const [txTypes, setTxTypes] = useState([]);
  const [transactionType, setTransactionType] = useState("");
  const [users, setUsers] = useState([]);
  const [books, setBooks] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [selectedBookCopy, setSelectedBookCopy] = useState(null);
  const [message, setMessage] = useState("");

  useEffect(() => {
    fetchTransactionTypes();
    fetchUsers();
    fetchBooks();
  }, []);

  async function fetchTransactionTypes() {
    try {
      const { data, error } = await supabase
        .from("transactiontypes")
        .select("*");
      if (error) throw error;
      setTxTypes(data);
      console.log("transactionTypes", data);
    } catch (error) {
      console.error("Error fetching transaction types:", error.message);
    }
  }

  async function fetchUsers() {
    try {
      const { data, error } = await supabase
        .from("users")
        .select("userid, firstname, lastname, barcode, username");
      if (error) throw error;
      setUsers(data);
      console.log("users", data);
    } catch (error) {
      console.error("Error fetching users:", error.message);
    }
  }

  async function fetchBooks() {
    try {
      const { data, error } = await supabase
        .from("bookcopiesview")
        .select("copyid, booktitle, authorname, barcode, available,userid");
      if (error) throw error;
      setBooks(data);
      console.log("books", data);
    } catch (error) {
      console.error("Error fetching books:", error.message);
    }
  }
  // Function to handle selected user
  const handleUserSelection = (user) => {
    console.log("Selected user:", user);
    setSelectedUser(user);
  };
  const handleBookCopySelection = (bookCopy) => {
    console.log("Selected bookCopy:", bookCopy);
    setSelectedBookCopy(bookCopy);
  };

  const handleTransactionTypeChange = (e) => {
    setTransactionType(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
        console.log("Transaction",transactionType, "user",selectedUser, "book", selectedBookCopy);
      if (!transactionType || !selectedUser || !selectedBookCopy) {
        throw new Error("Please select transaction type, user, and book copy.");
      }

      if (transactionType === 1 && !selectedBookCopy.available) {
        throw new Error("This book copy is already with someone.");
      }

      // Insert transaction into the database
      const { data, error } = await supabase.from("transactions").insert([
        {
          userid: selectedUser.userid,
          copyid: selectedBookCopy.copyid,
          transactiontype: transactionType,
          transactiondate: new Date().toISOString(),
          duedate:
            transactionType === 1
              ? new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString()
              : null,
          returndate: null,
        },
      ]);

      if (error) throw error;

      setMessage("Transaction created successfully");
      window.location.href = "/GET/transactions";
    } catch (error) {
      console.error("Error creating transaction:", error.message);
      setMessage(`Error creating transaction: ${error.message}`);
    }
  };
  console.log(transactionType);
  return (
    <div className={styles.container}>
      <h1>Create New Transaction</h1>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="transactionType">Transaction Type:</label>
          <select
            id="transactionType"
            name="transactionType"
            onChange={handleTransactionTypeChange}
            value={transactionType}
          >
            <option value="">Select Transaction Type</option>
            {txTypes.map((ttype) => (
              <option key={ttype.id} value={ttype.id}>
                {ttype.transactiontype}
              </option>
            ))}
          </select>
        </div>
        <UsersSearchHelp users={users} onUserSelect={handleUserSelection} />
        <BookCopySearchHelp
          bookCopies={books}
          users={users}
          onBookSelect={handleBookCopySelection}
        />
        <button type="submit">
          {transactionType === 1
            ? "Checkout"
            : transactionType === 2
            ? "Return"
            : "Create Transaction"}
        </button>
      </form>
      {message && <p className={styles.message}>{message}</p>}
    </div>
  );
}
