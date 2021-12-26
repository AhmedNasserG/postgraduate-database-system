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

const supervisorViewStudents = async supervisorId => {
  const request = new sql.Request();
  request.input('supervisor_id', sql.Int, supervisorId);
  return request.execute('ViewSupStudentsYears');
};

const supervisorViewStudentPublications = async studentId => {
  const request = new sql.Request();
  request.input('studentId', sql.Int, studentId);
  return request.execute('ViewAStudentPublications');
};
const supervisorViewThesis = async supervisorId => {
  const request = new sql.Request();
  request.input('supervisor_id', sql.Int, supervisorId);
  return request.execute('viewSupThesis');
};

const isGucian = async thesisId => {
  const request = new sql.Request();
  request.input('thesisSerialNo', sql.Int, thesisId);
  request.output('output', sql.Int);
  return request.execute('is_GUCian');
};

const supervisorAddDefenseGUCian = async (thesisId, location, date) => {
  const request = new sql.Request();
  request.input('ThesisSerialNo', sql.Int, thesisId);
  request.input('DefenseLocation', sql.VarChar, location);
  request.input('DefenseDate', sql.DateTime, date);
  return request.execute('AddDefenseGucian');
};

const supervisorAddDefenseNonGUCian = async (thesisId, location, date) => {
  const request = new sql.Request();
  request.input('ThesisSerialNo', sql.Int, thesisId);
  request.input('DefenseLocation', sql.VarChar, location);
  request.input('DefenseDate', sql.DateTime, date);
  return request.execute('AddDefenseNonGucian');
};
module.exports = {
  supervisorRegister,
  supervisorViewStudents,
  supervisorViewStudentPublications,
  supervisorViewThesis,
  isGucian,
  supervisorAddDefenseGUCian,
  supervisorAddDefenseNonGUCian
};
