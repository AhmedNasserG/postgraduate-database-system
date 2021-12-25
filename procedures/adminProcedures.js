const sql = require('mssql');

const listSupervisors = async () => {
  // make sure that any items are correctly URL encoded in the connection string
  const request = new sql.Request();
  return request.execute('AdminListSup');
  //sql.close()
};
module.exports = {
  listSupervisors
};
