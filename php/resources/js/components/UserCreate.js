import React, { useRef } from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';
import classes from './UserCreate.scss';

const UserCreate = ({ roles }) => {
  const formRef = useRef();

  const onSubmit = async (e) => {
    e.preventDefault();

    const form = formRef.current;
    const formData = new FormData(form);
    const data = {
      name: formData.get('name'),
      email: formData.get('email'),
      roles: formData.getAll('roles'),
    };

    try {
      await axios.post(window.location.href, data, { headers: { 'Accept': 'application/json' } });

      window.location.href = '/list';
    } catch (error) {
      let message = error.response?.data?.message || 'An error occurred.';

      if (error.response?.data?.errors) {
        const errors = error.response.data.errors;
        message += `\n● ${Object.values(errors).flat().join("\n● ")}`;
      }

      alert(message);
    }
  };

  return (
    <div>
      <h2>Create User</h2>
      <form ref={formRef} onSubmit={onSubmit}>
        <div className="fields">
          <div className="field">
            <label>Full name</label>
            <input type="text" name="name" placeholder="Enter name" />
          </div>
          <div className="field">
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter email" />
          </div>
          <div className="field-roles">
            <label>Roles</label>
            <div>
              { roles && roles.map((role, idx) => (
                <label key={idx}>
                  <input type="checkbox" name="roles" value={role} />
                  {role}
                </label>
              )) }
            </div>
          </div>
        </div>
        <div className="actions">
          <button type="reset">Clear</button>
          <button type="submit">Create</button>
        </div>
      </form>
    </div>
  );
};

export default UserCreate;

const userCreate = document.getElementById('user-create');

if (userCreate) {
  const roles = JSON.parse(userCreate.dataset.roles);
  ReactDOM.render(<UserCreate roles={roles} />, userCreate);
}
