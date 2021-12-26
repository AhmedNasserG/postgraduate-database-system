var express = require('express');
var router = express.Router();
const sql = require('mssql');
const moment = require('moment');
const supervisorProcedures = require('../procedures/supervisorProcedures');

/* GET home page. */
router.get('/', function (req, res) {
  res.render('supervisor/supervisorDashboard');
});

router.get('/students', function (req, res) {
  const supervisorId = req.session.userId;
  supervisorProcedures.supervisorViewStudents(supervisorId).then(response => {
    res.render('supervisor/students', {
      students: response.recordset
    });
  });
});

router.get('/theses', function (req, res) {
  const supervisorId = req.session.userId;
  supervisorProcedures.supervisorViewThesis(supervisorId).then(response => {
    console.log(response.recordset);
    res.render('supervisor/theses', {
      theses: response.recordset,
      moment: moment
    });
  });
});

router.post('/students', function (req, res) {
  console.log(req.body.view);
  const studentId = req.body.view.split('(')[0].toString();
  const studentName = req.body.view.split('(')[1].toString();

  // get name form db
  supervisorProcedures
    .supervisorViewStudentPublications(studentId)
    .then(response => {
      console.log(response.recordset);
      // convert date to readable format
      res.render('supervisor/supervisorPublication', {
        publications: response.recordset,
        studentName: studentName
      });
    });
});

module.exports = router;
