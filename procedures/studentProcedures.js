const sql = require('mssql');

const studentRegister = async (
  firstName,
  lastName,
  email,
  address,
  faculty,
  password,
  type
) => {
  try {
    // make sure that any items are correctly URL encoded in the connection string
    const request = new sql.Request();
    request.input('first_name', sql.VarChar, firstName);
    request.input('last_name', sql.VarChar, lastName);
    request.input('password', sql.VarChar, password);
    request.input('faculty', sql.VarChar, faculty);
    request.input('Gucian', sql.Bit, type);
    request.input('email', sql.VarChar, email);
    request.input('address', sql.VarChar, address);
    request.execute('StudentRegister');
    //sql.close()
  } catch (err) {
    console.log(err.message);
  }
};

module.exports = {
  studentRegister
};
