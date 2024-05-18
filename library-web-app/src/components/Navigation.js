import Link from "next/link";
import styles from "../styles/Navigation.module.css"; // Import CSS module for styling

const Navigation = () => {
  return (
    <nav className={styles.nav}>
      {/* Create Section */}
      <div className={styles.navItem}>
        <h2 className={styles.sectionTitle}>Create</h2>
        <ul className={styles.subNavList}>
          <li className={styles.subNavItem}>
            <Link href="/POST/createAuthorPage">Create Author</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/POST/createBookPage">Create Book</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/POST/createBookCopyPage">Create Book Copy</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/POST/createTransactionPage">Create Transaction</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/POST/createUserPage">Create User</Link>
          </li>
        </ul>
      </div>

      {/* Read Section */}
      <div className={styles.navItem}>
        <h2 className={styles.sectionTitle}>View</h2>
        <ul className={styles.subNavList}>
          <li className={styles.subNavItem}>
            <Link href="/GET/authors">View Authors</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/GET/books">View Books</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/GET/booksCopies">View Book Copies</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/GET/bookStatus">View Books' Status</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/GET/transactions">View Transactions</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/GET/users">View Users</Link>
          </li>
        </ul>
      </div>

      {/* Update Section */}
      <div className={styles.navItem}>
        <h2 className={styles.sectionTitle}>Update</h2>
        <ul className={styles.subNavList}>
          <li className={styles.subNavItem}>
            <Link href="/PUT/updateAuthor">Update Author</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/PUT/updateBooks">Update Books</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/PUT/updateBookCopy">Update Book Copy</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/PUT/updateTransaction">Update Transaction</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/PUT/updateUsers">Update Users</Link>
          </li>
        </ul>
      </div>

      {/* Delete Section */}
      <div className={styles.navItem}>
        <h2 className={styles.sectionTitle}>Delete</h2>
        <ul className={styles.subNavList}>
          <li className={styles.subNavItem}>
            <Link href="/DELETE/deleteAuthor">Delete Author</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/DELETE/deleteBook">Delete Book</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/DELETE/deleteBook">Delete Book Copy</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/DELETE/deleteTransaction">Delete Transaction</Link>
          </li>
          <li className={styles.subNavItem}>
            <Link href="/DELETE/deleteUser">Delete User</Link>
          </li>
        </ul>
      </div>
    </nav>
  );
};

export default Navigation;
