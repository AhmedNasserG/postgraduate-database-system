const req = require('express/lib/request');
const sql = require('mssql');
const { RequestError } = require('mssql/lib/base');

const studentRegister = async (
  firstName,
  lastName,
  email,
  address,
  faculty,
  password,
  type
) => {
  // make sure that any items are correctly URL encoded in the connection string
  const request = new sql.Request();
  request.input('first_name', sql.VarChar, firstName);
  request.input('last_name', sql.VarChar, lastName);
  request.input('password', sql.VarChar, password);
  request.input('faculty', sql.VarChar, faculty);
  request.input('Gucian', type);
  request.input('email', sql.VarChar, email);
  request.input('address', sql.VarChar, address);
  request.execute('StudentRegister');
  //sql.close()
};

const viewMyProfile = async (
  studentId
) => {
  const request = new sql.Request();
  request.input('studentId', sql.Int, studentId);
  return request.execute('viewMyProfile');
};

const viewAllMyTheses = async (
  studentId
) => {
  const request = new sql.Request();
  request.input('studentId', sql.Int, studentId);
  return request.execute('viewAllMyTheses');
};

const viewCoursesGrades = async (
  studentId
) => {
  const request = new sql.Request();
  request.input('studentID', sql.Int, studentId);
  return request.execute('ViewCoursesGrades');
};

const addProgressReport = async (
  thesisSerialNumber,
  progressReportDate
) => {
  const request = new sql.Request();
  request.input('thesisSerialNo', sql.Int, thesisSerialNumber);
  request.input('progressReportDate', sql.Date, progressReportDate);
  request.execute('AddProgressReport');
};

const fillProgressReport = async (
  thesisSerialNumber,
  progressReportNumber,
  state,
  description
) => {
  const request = new sql.Request();
  request.input('thesisSerialNo', sql.Int, thesisSerialNumber);
  request.input('progressReportNo', sql.Int, progressReportNumber);
  request.input('state', sql.Int, state);
  request.input('description', sql.VarChar, description);
  request.execute('FillProgressReport');
};

const addPublication = async (
  title,
  publicationDate,
  host,
  place,
  isAccepted,
) => {
  const request = new sql.Request();
  request.input('title', sql.VarChar, title);
  request.input('pubDate', sql.DateTime, publicationDate);
  request.input('host', sql.VarChar, host);
  request.input('place', sql.VarChar, place);
  request.input('accepted', sql.Bit, isAccepted);
  request.execute('addPublication');
};

const linkPubThesis = async (
  publicationId,
  thesisSerialNumber
) => {
  const request = new sql.Request();
  request.input('pubID', sql.Int, publicationId);
  request.input('thesisSerialNo', sql.Int, thesisSerialNumber);
  request.execute('linkPubThesis');
};

const viewMyReports = async (
  studentId
) => {
  const request = new sql.Request();
  request.input('studentId', sql.Int, studentId);
  return request.execute('viewMyReports');
};

const viewMyPublications = async (
  studentId
) => {
  const request = new sql.Request();
  request.input('studentId', sql.Int, studentId);
  return request.execute('viewMyPublications');
}

module.exports = {
  studentRegister,
  viewMyProfile,
  viewAllMyTheses,
  viewCoursesGrades,
  addProgressReport,
  fillProgressReport,
  addPublication,
  linkPubThesis,
  viewMyReports,
  viewMyPublications
};
