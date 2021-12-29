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
  console.log(req.body);
  console.log(req.body.date);
  const date = moment(req.body.date).format('MM/DD/YYYY');
  console.log(date);
  console.log(serialNumber);
  console.log(location);
  console.log(date);
  const examiners = eval(req.body.examiner);
  examiners['is_national'] = req.body.is_national ? 1 : 0;
  console.log(examiners['is_national']);
  supervisorProcedures
    .isGucian(serialNumber)
    .then(response => {
      if (response.output.toString() === '1') {
        supervisorProcedures
          .supervisorAddDefenseGUCian(serialNumber, location, date)
          .then(response => {
            console.log(response);
            examiners.forEach(examiner => {
              supervisorProcedures
                .supervisorAddExaminer(
                  date,
                  examiner.name,
                  examiner.is_national,
                  examiner.field,
                  serialNumber
                )
                .then(response => {
                  console.log(response);
                })
                .catch(err => {
                  console.log(err);
                });
            });
          });
      } else {
        supervisorProcedures
          .supervisorAddDefenseNonGUCian(serialNumber, location, date)
          .then(response => {
            console.log(response);
            console.log(examiners);
            examiners.forEach(examiner => {
              supervisorProcedures
                .supervisorAddExaminer(
                  date,
                  examiner.name,
                  examiner.is_national,
                  examiner.field,
                  serialNumber
                )
                .then(response => {
                  console.log(response);
                })
                .catch(err => {
                  console.log(err);
                });
            });
          })
          .catch(err => {
            console.log(err);
          });
      }
    })
    .catch(err => {
      console.log(err);
    });
  console.log(examiners);
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
      res
        .render('supervisor/supervisorPublication', {
          publications: response.recordset,
          studentName: studentName
        })
        .catch(err => {
          console.log(err);
        });
    });
});

router.get('/reports', function (req, res) {
  const supervisorId = req.session.userId;
  supervisorProcedures
    .supervisorViewAllStudentsReports(supervisorId)
    .then(response => {
      console.log(response.recordset);
      res.render('supervisor/reports', {
        reports: response.recordset,
        moment: moment
      });
    });
});

router.post('/reports/:thesisId', function (req, res) {
  const thesisId = req.params.thesisId;
  const supervisorId = req.session.userId;
  const grade = req.body.grade;
  const reportNo = req.body.report_number;
  supervisorProcedures
    .supervisorEvaluateReport(supervisorId, thesisId, reportNo, grade)
    .then(response => {
      console.log(response);
      res.redirect('/supervisor/reports');
    })
    .catch(err => {
      console.log(err);
    });
});

router.post('/cancel/:thesisSerial', (req, res) => {
  // TODO: TO BE TESTED
  // DISABLE THE BUTTON if the last report is not zero
  const thesisSerial = req.params.thesisSerial;
  supervisorProcedures
    .supervisorCancelThesis(thesisSerial)
    .then(response => {
      console.log(response);
      res.redirect('/supervisor/theses');
    })
    .catch(err => {
      console.log(err);
    });
});

module.exports = router;
