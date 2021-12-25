const sql = require('mssql');

const listSupervisors = async () => {
  const request = new sql.Request();
  return request.execute('AdminListSup');
};

const listTheses = async () => {
  const request = new sql.Request();
  return request.execute('AdminViewAllTheses');
};

const numOfOnGoingTheses = async () => {
  const request = new sql.Request();
  request.output('count', sql.int);
  return request.execute('AdminViewOnGoingTheses');
};

module.exports = {
  listSupervisors,
  listTheses,
  numOfOnGoingTheses
};
