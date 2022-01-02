const express = require('express');
const router = express.Router();
const studentProcedures = require('../procedures/studentProcedures');
const supervisorProcedures = require('../procedures/supervisorProcedures');
const examinerProcedures = require('../procedures/examinerProcedures');
const toast = require('../utilities/toast');

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
  ).then(response => {
    console.log(type);
    toast.showToast(req, 'success', 'Registered successfully')
    res.redirect('/');
  }).catch(err => {
    toast.showToast(req, 'error', 'already registered email!')
    res.redirect('back');
  }
  )
});

/* supervisor Registration */
router.post('/supervisor', function (req, res) {
  const firstName = req.body.firstName;
  const lastName = req.body.lastName;
  const email = req.body.email;
  const faculty = req.body.faculty;
  const password = req.body.password;
  // console.log(req.body)
  supervisorProcedures.supervisorRegister(
    firstName,
    lastName,
    email,
    faculty,
    password
  ).then(response => {
    toast.showToast(req, 'success', 'Registered successfully')
    res.redirect('/');
  }).catch(error => {
    console.log('helllllloooooooo');
    toast.showToast(req, 'error', 'already registered email!')
    res.redirect('back');
  }
  )
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
  examinerProcedures.examinerRegister(
    firstName,
    lastName,
    email,
    password,
    type,
    fieldOfWork
  ).then(response => {
    toast.showToast(req, 'success', 'Registered successfully')
    res.redirect('/');
  }).catch(error => {
    toast.showToast(req, 'error', 'already registered email!')
    res.redirect('back');
  }
  )
});
module.exports = router;
