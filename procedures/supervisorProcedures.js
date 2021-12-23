const sql = require('mssql');

const supervisorRegister = async (
  firstName,
  lastName,
  email,
  faculty,
  password
) => {
  // make sure that any items are correctly URL encoded in the connection string
  const request = new sql.Request();
  request.input('first_name', sql.VarChar, firstName);
  request.input('last_name', sql.VarChar, lastName);
  request.input('password', sql.VarChar, password);
  request.input('faculty', sql.VarChar, faculty);
  request.input('email', sql.VarChar, email);
  request.execute('SupervisorRegister');
  //sql.close()
};

module.exports = {
  supervisorRegister
};
