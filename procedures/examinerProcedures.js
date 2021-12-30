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
  request.input('National', type);
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

const showThesisSupervisors = async (
  thesisSerialNo
)=>{
  const request = new sql.Request()
  request.input('thesis_serial_number',sql.Int,thesisSerialNo)
  return request.execute('ShowThesisSupervisors')
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
  request.input('ThesisSerialNo',sql.Int,thesisSerialNo)
  request.input('DefenseDate' ,defenseDate)
  request.input('grade',sql.Decimal,grade)
  return request.execute('AddDefenseGrade')

}

const addComment = async (
  id,
  thesisSerialNo,
  defenseDate,
  comment
) =>{
  const request = new sql.Request()
  console.log(thesisSerialNo)
  request.input('examiner_id',sql.Int,id)
  request.input('ThesisSerialNo',sql.Int,thesisSerialNo)
  request.input('DefenseDate' ,defenseDate)
  request.input('comments',sql.VarChar,comment)
  return request.execute('AddCommentsGrade')

}

const searchForThesis = async (
  searchTerm
)=> {
  const request = new sql.Request()
  request.input('keyword',sql.VarChar,searchTerm)
  return request.execute('SearchForThesis')
}

const showProfile = async(
  id
)=>{
  const request = new sql.Request()
  request.input('examiner_id',sql.Int,id)
  return request.execute('viewExaminerProfile')
}

module.exports = {
  examinerRegister,
  showExaminerTheses,
  showExaminerDefenses,
  addGrade,
  addComment,
  searchForThesis,
  showThesisSupervisors,
  showProfile
};