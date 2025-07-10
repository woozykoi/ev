import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import classes from './UserList.scss';

const UserList = ({ users, roles }) => {
  const [selectedRoles, setSelectedRoles] = useState([]);

  const handleRoleChange = (role) => {
    setSelectedRoles((prev) =>
      prev.includes(role)
        ? prev.filter((r) => r !== role)
        : [...prev, role]
    );
  };

  const filteredUsers = selectedRoles.length
    ? users.filter((user) => {
        return user.roles.some((r) => selectedRoles.includes(r));
      })
    : users;

  return (
    <div>
      <h2>User List</h2>
      <div className="filters">
        Filter by roles:
        {roles.map((role, idx) => (
          <label key={idx}>
            <input
              type="checkbox"
              checked={selectedRoles.includes(role)}
              onChange={() => handleRoleChange(role)}
            />
            {role}
          </label>
        ))}
      </div>
      <table>
        <thead>
          <tr>
            <th>Full name</th>
            <th>Roles</th>
            <th>Email</th>
          </tr>
        </thead>
        <tbody>
          {filteredUsers.length > 0 ? (
            filteredUsers.map((user, idx) => (
              <tr className="user" key={idx}>
                <td>{user.name}</td>
                <td>{user.roles.join(', ')}</td>
                <td>{user.email}</td>
              </tr>
            ))
          ) : null}
          {filteredUsers.length <= 0 ? (
            <tr className="no-users">
              <td colSpan="3">No users found</td>
            </tr>
          ) : null}
        </tbody>
      </table>
    </div>
  );
};

export default UserList;

const userList = document.getElementById('user-list');

if (userList) {
  const users = JSON.parse(userList.dataset.users);
  const roles = JSON.parse(userList.dataset.roles);

  ReactDOM.render(<UserList users={users} roles={roles} />, userList);
}
