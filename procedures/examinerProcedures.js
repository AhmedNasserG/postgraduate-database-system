const sql = require('mssql');

const examinerRegister = async (
  firstName,
  lastName,
  email,
  password,
  type,
  fieldOfWork
) => {
  // make sure that any items are correctly URL encoded in the connection string
  const request = new sql.Request();
  request.input('name', sql.VarChar, firstName+" "+lastName);
  request.input('password', sql.VarChar, password);
  request.input('fieldOfWork', sql.VarChar, fieldOfWork);
  request.input('National', sql.Bit, type);
  request.input('email', sql.VarChar, email);
  request.execute('ExaminerRegister');
  //sql.close()
};

module.exports = {
  examinerRegister
};