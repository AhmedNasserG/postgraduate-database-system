const express = require('express');
const router = express.Router();
const toast = require('../utilities/toast');
const supervisorProcedures = require('../procedures/supervisorProcedures');
const { authUser, authRole, ROLE } = require('../utilities/auth');

router.get('/', authUser, authRole([ROLE.SUPERVISOR]), function (req, res) {
  res.render('supervisor/supervisorDashboard');
});

router.get('/profile', authUser, authRole([ROLE.SUPERVISOR]), (req, res) => {
  const id = req.session.userId
  supervisorProcedures.viewSupervisorProfile(id).then(response => {
    const profile = response.recordset[0];
    res.render('supervisor/supervisorProfile', {
      supervisor: profile
    })
  }).catch(err => {
    res.redirect('/supervisor');
  });
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
        res.render('supervisor/reports', {
          reports: response.recordset,
        });
      });
  }
);

router.post('/theses/:serial_number', function (req, res) {
  const serialNumber = req.params.serial_number;
  const location = req.body.location;
  const date = req.body.date;
  const examiners = eval(req.body.examiner);
  examiners['is_national'] = req.body.is_national == 'true';
  supervisorProcedures
    .isGucian(serialNumber)
    .then(response => {
      if (response.output.output == 1) {
        supervisorProcedures
          .supervisorAddDefenseGUCian(serialNumber, location, date)
          .then(response => {
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
                })
                .catch(err => { });
            });
            toast.showToast(req, 'success', 'Defense added successfully');
          }).catch(err => {

            toast.showToast(req, 'error', err);
          });
      } else {
        supervisorProcedures
          .supervisorAddDefenseNonGUCian(serialNumber, location, date)
          .then(response => {
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
                })
                .catch(err => { });
            });
            toast.showToast(req, 'success', 'Defense added successfully');
          })
          .catch(err => {
            toast.showToast(req, 'error', err);
          });
      }
    })
    .catch(err => {
      toast.showToast(req, 'error', err);
    });
  res.redirect('/supervisor/theses');
});

router.post('/students', function (req, res) {
  const studentId = req.body.view.split('(')[0].toString();
  const studentName = req.body.view.split('(')[1].toString();
  supervisorProcedures
    .supervisorViewStudentPublications(studentId)
    .then(response => {
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
      toast.showToast(req, 'success', 'Report evaluated successfully');
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
      toast.showToast(req, 'success', 'Thesis cancelled successfully');
      res.redirect('/supervisor/theses');
    })
    .catch(err => {
      toast.showToast(req, 'error', err);
      res.redirect('/supervisor/theses');
    });
});


module.exports = router;
