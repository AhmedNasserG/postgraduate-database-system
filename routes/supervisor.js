var express = require('express');
var router = express.Router();
const moment = require('moment');
const toast = require('../utilities/toast');
const supervisorProcedures = require('../procedures/supervisorProcedures');
const { authUser, authRole, ROLE } = require('../utilities/auth');

router.get('/', authUser, authRole([ROLE.SUPERVISOR]), function (req, res) {
  res.render('supervisor/supervisorDashboard');
});

router.get(
  '/students',
  authUser,
  authRole([ROLE.SUPERVISOR]),
  function (req, res) {
    const supervisorId = req.session.userId;
    supervisorProcedures.supervisorViewStudents(supervisorId).then(response => {
      res.render('supervisor/students', {
        students: response.recordset
      });
    });
  }
);

router.get(
  '/theses',
  authUser,
  authRole([ROLE.SUPERVISOR]),
  function (req, res) {
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
  }
);

router.get(
  '/reports',
  authUser,
  authRole([ROLE.SUPERVISOR]),
  function (req, res) {
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
  }
);

router.post('/theses/:serial_number', function (req, res) {
  const serialNumber = req.params.serial_number;
  const location = req.body.location;
  console.log(req.body);
  console.log(req.body.date);
  const date = req.body.date;
  console.log(date);
  console.log(serialNumber);
  console.log(location);
  console.log(date);
  const examiners = eval(req.body.examiner);
  examiners['is_national'] = req.body.is_national == 'true';
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
                .catch(err => {});
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
                .catch(err => {});
            });
          })
          .catch(err => {
            toast.showToast(req, 'error', err);
          });
      }
    })
    .catch(err => {
      toast.showToast(req, 'error', err);
    });
  console.log(examiners);
  res.redirect('/supervisor/theses');
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
      toast.showToast(req, 'error', err);
      res.redirect('/supervisor/reports');
    });
});

router.post('/cancel/:thesisSerial', (req, res) => {
  // DISABLE THE BUTTON if the last report is not zero
  const thesisSerial = req.params.thesisSerial;
  supervisorProcedures
    .supervisorCancelThesis(thesisSerial)
    .then(response => {
      console.log(response);
      res.redirect('/supervisor/theses');
    })
    .catch(err => {
      toast.showToast(req, 'error', err);
      res.redirect('/supervisor/theses');
    });
});

module.exports = router;
