const { request } = require('express');
const sql = require('mssql');

const userLogin = async (
  email,
  password
) => {
  // make sure that any items are correctly URL encoded in the connection string
  const request = new sql.Request();
  request.input('password', sql.VarChar, password);
  request.input('email', sql.VarChar, email);
  request.output('success',sql.BIT);
  request.output('id',sql.Int)
  return request.execute('userLogin')

};

const userType = async (id) =>{
    const request = new sql.Request();
    request.input('id', sql.INT, id);
    request.output('type',sql.int)
    return request.execute('TypeOfUser')
}


module.exports = {
  userLogin,
  userType
};
