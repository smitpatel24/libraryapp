import { useState } from 'react';
import styles from '../styles/create.module.css'; // Import CSS module for styling

export default function UsersSearchHelp({ users, onUserSelect }) {
  const [userInput, setUserInput] = useState("");
  const [filteredUsers, setFilteredUsers] = useState(users);
  const [selectedBarcode, setSelectedBarcode] = useState("");
  const [showSearchHelp, setShowSearchHelp] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);

  const handleInputChange = (e) => {
    const inputValue = e.target.value.toLowerCase();
    const filtered = users.filter((user) => {
      return (
        user.firstname.toLowerCase().includes(inputValue) ||
        user.lastname.toLowerCase().includes(inputValue) ||
        user.username.toLowerCase().includes(inputValue) ||
        user.barcode.toLowerCase().includes(inputValue)
      );
    });
    setFilteredUsers(filtered);
    setShowSearchHelp(true);
    setUserInput(inputValue); // Update userInput
  };

  const handleUserSelect = (user) => {
    setSelectedBarcode(user.barcode);
    setShowSearchHelp(false);
    setUserInput(user.username); // Update userInput with selected username
    setSelectedUser(user);
    onUserSelect(user); // Pass selected user to the parent component
  };

  return (
    <div>
      <label htmlFor="userInput">User Barcode/Username:</label>

      <div className={styles.searchHelpContainer}>
        <input
          type="text"
          id="userInput"
          name="userInput"
          onChange={handleInputChange}
          value={userInput}
          className={styles.userInput}
          placeholder="Enter user's Barcode OR username"
        />
        {showSearchHelp && (
          <div className={styles.searchHelp}>
            {filteredUsers.map((user) => (
              <div
                key={user.userid}
                className={styles.user}
                onClick={() => handleUserSelect(user)}
              >
                <span>
                  {user.firstname} {user.lastname} ({user.username}) -{" "}
                  {user.barcode}
                </span>
              </div>
            ))}
          </div>
        )}
        <input type="hidden" id="selectedBarcode" value={selectedBarcode} />
      </div>
      {selectedUser && (
        <div className={styles.userInfo}>
          <p>First Name: {selectedUser.firstname}</p>
          <p>Last Name: {selectedUser.lastname}</p>
          <p>Username: {selectedUser.username}</p>
          <p>Barcode: {selectedUser.barcode}</p>
        </div>
      )}
    </div>
  );
}
