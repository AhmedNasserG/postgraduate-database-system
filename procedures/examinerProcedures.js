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

const showExaminerTheses = async (
  examinerId
) =>{
  const request = new sql.Request();
  request.input('examiner_id',sql.Int,examinerId)
  return request.execute('ShowExaminerTheses')
}

const showExaminerDefenses = async (
  examinerId
)=>{
  const request = new sql.Request();
  request.input('examiner_id',sql.Int, examinerId)
  return request.execute('ShowExaminerDefense')
}

const addGrade = async (
  thesisSerialNo,
  defenseDate,
  grade
) =>{
  const request = new sql.Request()
  const r = '3/3/2021'
  request.input('ThesisSerialNo',sql.Int,thesisSerialNo)
  request.input('DefenseDate' ,defenseDate)
  request.input('grade',sql.Decimal,grade)
  return request.execute('AddDefenseGrade')

}
module.exports = {
  examinerRegister,
  showExaminerTheses,
  showExaminerDefenses,
  addGrade
};