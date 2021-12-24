const express = require('express');
const router = express.Router();
const studentProcedures = require('../procedures/studentProcedures');
const supervisorProcedures = require('../procedures/supervisorProcedures');
const examinerProcedures = require('../procedures/examinerProcedures');

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
  try {
    studentProcedures.studentRegister(
      firstName,
      lastName,
      email,
      address,
      faculty,
      password,
      type
    );
    res.redirect('/');
  } catch (err) {
    res.render('register', { ok: 'no' });
  }
});

/* supervisor Registration */
router.post('/supervisor', function (req, res) {
  const firstName = req.body.firstName;
  const lastName = req.body.lastName;
  const email = req.body.email;
  const faculty = req.body.faculty;
  const password = req.body.password;
  // console.log(req.body)
  try {
    supervisorProcedures.supervisorRegister(
      firstName,
      lastName,
      email,
      faculty,
      password
    );
    res.redirect('/');
  } catch (error) {
    res.render('register', { ok: no });
  }
});

/* examiner Registration */
router.post('/examiner', function (req, res) {
  const firstName = req.body.firstName;
  const lastName = req.body.lastName;
  const email = req.body.email;
  const fieldOfWork = req.body.fieldOfWork;
  const password = req.body.password;
  const type = req.body.type;
  // console.log(req.body)
  try {
    examinerProcedures.examinerRegister(
      firstName,
      lastName,
      email,
      password,
      type,
      fieldOfWork
    );
    res.redirect('/');
  } catch (error) {
    res.render('register', { ok: no });
  }
});
module.exports = router;
