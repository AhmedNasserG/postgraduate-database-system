var express = require('express');
var router = express.Router();
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

router.post('/theses/:serial_number', function (req, res) {
  const serialNumber = req.params.serial_number;
  const location = req.body.location;
  const date = moment(req.body.date).format('YYYY-MM-DD');
  console.log(date);
  console.log(serialNumber);
  console.log(location);
  supervisorProcedures.isGucian(serialNumber).then(response => {
    response.output.toString() === '1'
      ? supervisorProcedures.supervisorAddDefenseGUCian(
          serialNumber,
          location,
          date
        )
      : supervisorProcedures.supervisorAddDefenseNonGUCian(
          serialNumber,
          location,
          date
        );
  });

  res.redirect('/supervisor/theses');
});
router.get('/theses', function (req, res) {
  const supervisorId = req.session.userId;
  supervisorProcedures.supervisorViewThesis(supervisorId).then(response => {
    supervisorProcedures.viewExaminer().then(response2 => {
      res.render('supervisor/theses', {
        theses: response.recordset,
        moment: moment,
        examiner: response2.recordset
      });
    });
  });
});

router.post('/students', function (req, res) {
  console.log(req.body.view);
  const studentId = req.body.view.split('(')[0].toString();
  const studentName = req.body.view.split('(')[1].toString();

  supervisorProcedures
    .supervisorViewStudentPublications(studentId)
    .then(response => {
      console.log(response.recordset);
      res.render('supervisor/supervisorPublication', {
        publications: response.recordset,
        studentName: studentName
      });
    });
});

router.get('/reports', function (req, res) {
  res.render('supervisor/reports');
});

router.post('/cancel/:thesisSerial', (req, res) => {
  // TODO: TO BE TESTED
  // DISABLE THE BUTTON if the last report is not zero
  const thesisSerial = req.params.thesisSerial;
  supervisorProcedures.supervisorCancelThesis(thesisSerial).then(response => {
    console.log(response);
    res.redirect('/supervisor/theses');
  });
});

module.exports = router;
