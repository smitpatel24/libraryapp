import { useState, useEffect } from "react";
import { supabase } from "../../lib/supabase";
import styles from "../../styles/Books.module.css"; // Import CSS module for styling

export default function Users() {
  const [users, setUsers] = useState([]);
  const [userTypes, setUserTypes] = useState([]);
  const [filteredUsers, setFilteredUsers] = useState([]);
  const [userTypeFilter, setUserTypeFilter] = useState("");

  useEffect(() => {
    fetchUsers();
    fetchUserTypes();
  }, []);

  async function fetchUsers() {
    try {
      const { data, error } = await supabase.from("users").select("*");
      if (error) throw error;
      setUsers(data);
      console.log(data);
      setFilteredUsers(data); // Initialize filtered users with all users
    } catch (error) {
      console.error("Error fetching users:", error.message);
    }
  }

  async function fetchUserTypes() {
    try {
      const { data, error } = await supabase.from("usertypes").select("*");
      if (error) throw error;
      setUserTypes(data);
      console.log(data);
    } catch (error) {
      console.error("Error fetching users:", error.message);
    }
  }
  // Function to handle filtering based on input value
  const handleFilter = (column, value) => {
    // Convert the value to lowercase for case-insensitive filtering
    const filterValue = value.toLowerCase();

    // Filter the users based on the specified column and filter value
    const filtered = users.filter((user) => {
      // Convert the column value to lowercase for consistency
      const fieldValue = user[column].toLowerCase();

      // Check if the field value includes the filter value
      return fieldValue.includes(filterValue);
    });

    // Update the filtered users state
    setFilteredUsers(filtered);
  };

  // Function to handle filtering based on user type
  const handleUserTypeFilter = (value) => {
    setUserTypeFilter(value);
    if (value === "") {
      setFilteredUsers(users); // Reset filter
    } else {
      const filtered = users.filter((user) => {
        //   console.log("User:", user);
        //   console.log("User Type:", user.usertype);
        //   console.log("Value:", value);
        return user.usertype === parseInt(value, 10); // Convert value to number
      });
      // console.log("Filtered", filtered);
      setFilteredUsers(filtered);
    }
  };

  return (
    <div>
      <h1>All Users</h1>
      <div className={styles.tableContainer}>
        <table className={styles.table}>
          <thead>
            <tr>
              <th>User ID</th>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Username</th>
              <th>User Type</th>
              <th>Barcode</th>
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
                ></input>
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("firstname", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by First Name"
                ></input>
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("lastname", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Last Name"
                ></input>
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("username", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by UserName"
                ></input>
              </td>
              <td>
                <select
                  value={userTypeFilter}
                  onChange={(e) => handleUserTypeFilter(e.target.value)}
                  className={styles.input}
                >
                  <option value="">Filter by User Type</option>

                  {userTypes.map((type, index) => (
                    <option value={type.id}>{type.type}</option>
                  ))}
                </select>
              </td>
              <td>
                <input
                  type="text"
                  onChange={(e) => handleFilter("barcode", e.target.value)}
                  className={styles.input}
                  placeholder="Filter by Barcode"
                ></input>
              </td>
            </tr>
            {filteredUsers.map((user, index) => (
              <tr key={index}>
                <td>{user.userid}</td>
                <td>{user.firstname}</td>
                <td>{user.lastname}</td>
                <td>{user.username}</td>
                <td>
                  {userTypes.find((type) => type.id === user.usertype)?.type ||
                    ""}
                </td>
                <td>{user.barcode}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
