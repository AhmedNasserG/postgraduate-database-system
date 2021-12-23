const express = require('express');
const router = express.Router();
const studentProcedures = require('../procedures/studentProcedures');

/* GET home page. */
router.get('/', function (req, res, next) {
  res.render('register');
});

/*student Registration*/
router.post('/student', function (req, res) {
  const firstName = req.body.firstName;
  const lastName = req.body.lastName;
  const email = req.body.email;
  const address = req.body.address;
  const faculty = req.body.faculty;
  const password = req.body.password;
  const type = req.body.type;
  console.log(req.body);
  studentProcedures.studentRegister(
    firstName,
    lastName,
    email,
    address,
    faculty,
    password,
    type
  );
});

module.exports = router;
