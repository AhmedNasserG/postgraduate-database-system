var express = require('express');
var router = express.Router();
var sql = require('mssql')
const sqlConfig = {
  user: 'linearDepression',
  password: 'linearDepression12345',
  database: 'pg_database',
  server: 'localhost',
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  },
  options: {
    encrypt: true, // for azure
    trustServerCertificate: true // change to true for local dev / self-signed certs
  }
}


const studentRegister = async   (firstName, lastName, email, address, faculty, password,type) => {
 try {

  // make sure that any items are correctly URL encoded in the connection string
  const request = new sql.Request()
  request.input('first_name',sql.VarChar,firstName)
  request.input('last_name',sql.VarChar,lastName)
  request.input('password',sql.VarChar,password)
  request.input('faculty',sql.VarChar,faculty)
  request.input('Gucian',sql.Bit,type)
  request.input('email',sql.VarChar,email)
  request.input('address',sql.VarChar,address)
  request.execute('StudentRegister')
  //sql.close()
 } catch (err) {
  console.log(err.message)
  
 }
}


/* GET home page. */
router.get('/', function (req, res, next) {
  res.render('register');
});

/*student Registration*/
router.post('/student', function(req,res){
  const firstName = req.body.firstName
  const lastName = req.body.lastName 
  const email = req.body.email
  const address = req.body.address
  const faculty = req.body.faculty
  const password = req.body.password
  const type = req.body.type
  console.log(req.body)
  studentRegister(firstName,lastName,email,address,faculty,password,type)
})

module.exports = router;
