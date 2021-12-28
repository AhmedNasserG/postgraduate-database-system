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
  console.log('GUCIAN');
  request.input('ThesisSerialNo', sql.Int, thesisId);
  request.input('DefenseLocation', sql.VarChar, location);
  request.input('DefenseDate', sql.DateTime, date);
  return request.execute('AddDefenseGucian');
};

const viewExaminer = async () => {
  const request = new sql.Request();
  return request.execute('ViewExaminer');
};

const supervisorAddDefenseNonGUCian = async (thesisId, location, date) => {
  console.log('NoN GUCIAN');
  const request = new sql.Request();
  request.input('ThesisSerialNo', sql.Int, thesisId);
  request.input('DefenseLocation', sql.VarChar, location);
  request.input('DefenseDate', sql.DateTime, date);
  return request.execute('AddDefenseNonGucian');
};

const supervisorCancelThesis = async thesisId => {
  const request = new sql.Request();
  request.input('ThesisSerialNo', sql.Int, thesisId);
  return request.execute('CancelThesis');
};

const supervisorAddExaminer = async (
  defenseDate,
  examinerName,
  isNational,
  fieldOfWork,
  thesisSerialNo
) => {
  const request = new sql.Request();
  console.log(defenseDate);
  console.log(examinerName);
  console.log(isNational);
  console.log(fieldOfWork);
  console.log(thesisSerialNo);

  request.input('DefenseDate', sql.DateTime, defenseDate);
  request.input('ExaminerName', sql.VarChar, examinerName);
  request.input('National', isNational);
  request.input('fieldOfWork', sql.VarChar, fieldOfWork);
  request.input('ThesisSerialNo', sql.Int, thesisSerialNo);
  return request.execute('AddExaminer');
};

const supervisorViewAllStudentsReports = async supervisorId => {
  const request = new sql.Request();
  request.input('supervisor_id', sql.Int, supervisorId);
  return request.execute('ViewAllStudentsReports');
};

const supervisorEvaluateReport = async (
  supervisorId,
  thesisId,
  reportNo,
  grade
) => {
  const request = new sql.Request();
  request.input('supervisor_id', sql.Int, supervisorId);
  request.input('thesis_serial_number', sql.Int, thesisId);
  request.input('progress_report_no', sql.Int, reportNo);
  request.input('evaluation_value', sql.Int, grade);
  return request.execute('EvaluateProgressReport');
};

module.exports = {
  supervisorRegister,
  supervisorViewStudents,
  supervisorViewStudentPublications,
  supervisorViewThesis,
  isGucian,
  supervisorAddDefenseGUCian,
  supervisorAddDefenseNonGUCian,
  viewExaminer,
  supervisorCancelThesis,
  supervisorAddExaminer,
  supervisorViewAllStudentsReports,
  supervisorEvaluateReport: supervisorEvaluateReport
};
