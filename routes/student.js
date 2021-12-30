const express = require('express');
const router = express.Router();
const toast = require('../utilities/toast');
const studentProcedures = require('../procedures/studentProcedures');
const { authUser, authRole, ROLE } = require('../utilities/auth');

router.get(
  '/',
  authUser,
  authRole([ROLE.GUCIAN_STUDENT, ROLE.NON_GUCIAN_STUDENT]),
  function (req, res, next) {
    const type = req.session.type;
    res.render('student/studentDashboard', { type: type });
  }
);

router.get(
  '/profile',
  authUser,
  authRole([ROLE.GUCIAN_STUDENT, ROLE.NON_GUCIAN_STUDENT]),
  (req, res) => {
    const id = req.session.userId;
    const type = req.session.type;
    studentProcedures.viewMyProfile(id).then(response => {
      const profile = response.recordset[0];
      res.render('student/studentProfile', {
        profile: profile,
        type: type
      });
    });
  }
);

router.get(
  '/theses',
  authUser,
  authRole([ROLE.GUCIAN_STUDENT, ROLE.NON_GUCIAN_STUDENT]),
  (req, res) => {
    const id = req.session.userId;
    const type = req.session.type;
    studentProcedures.viewAllMyTheses(id).then(response => {
      const theses = response.recordset;
      res.render('student/studentTheses', {
        theses: theses,
        type: type,
        today: new Date()
      });
    });
  }
);

router.get(
  '/courses',
  authUser,
  authRole([ROLE.GUCIAN_STUDENT, ROLE.NON_GUCIAN_STUDENT]),
  (req, res) => {
    const id = req.session.userId;
    const type = req.session.type;
    studentProcedures.viewCoursesGrades(id).then(response => {
      const courses = response.recordset;
      res.render('student/studentCourses', { courses: courses, type: type });
    });
  }
);

router.get(
  '/progressReports',
  authUser,
  authRole([ROLE.GUCIAN_STUDENT, ROLE.NON_GUCIAN_STUDENT]),
  (req, res) => {
    const id = req.session.userId;
    const type = req.session.type;
    studentProcedures.viewMyReports(id).then(response => {
      const reports = response.recordset;
      res.render('student/studentReports', {
        reports: reports,
        type: type
      });
    });
  }
);

router.get(
  '/publications',
  authUser,
  authRole([ROLE.GUCIAN_STUDENT, ROLE.NON_GUCIAN_STUDENT]),
  (req, res) => {
    const id = req.session.userId;
    const type = req.session.type;
    studentProcedures.viewMyPublications(id).then(response => {
      const publications = response.recordset;
      studentProcedures.viewAllMyTheses(id).then(response => {
        const theses = response.recordset;
        res.render('student/studentPublications', {
          publications: publications,
          type: type,
          theses: theses,
          today: new Date()
        });
      });
    });
  }
);

/* Add Publication to a certain thesis */
router.post('/publications', (req, res) => {
  const title = req.body.title;
  const date = req.body.date;
  const host = req.body.host;
  const place = req.body.place;
  const status = req.body.status;
  const id = req.session.userId;
  studentProcedures
    .addPublication(title, date, host, place, status, id)
    .then(response => {
      toast.showToast(req, 'success', 'Publication added successfully');
      res.redirect('/student/publications');
    })
    .catch(err => {
      toast.showToast(req, 'error', 'Cannot add publication');
      res.redirect('/student/publications');
    });
});

/* Add Progress Report to a certain thesis */
router.post('/:thesisSerialNumber/report', (req, res) => {
  const date = req.body.date;
  const thesisSerialNumber = req.params.thesisSerialNumber;
  studentProcedures
    .addProgressReport(thesisSerialNumber, date)
    .then(response => {
      toast.showToast(req, 'success', 'Progress Report added successfully');
      res.redirect('/student/theses');
    })
    .catch(err => {
      toast.showToast(req, 'error', 'Cannot add Progress Report');
      res.redirect('/student/theses');
    });
});

/* Fill Progress Report */
router.post('/:thesisSerialNumber/:reportNumber/report', (req, res) => {
  const state = req.body.state;
  const description = req.body.description;
  const thesisSerialNumber = req.params.thesisSerialNumber;
  const reportNumber = req.params.reportNumber;
  studentProcedures
    .fillProgressReport(thesisSerialNumber, reportNumber, state, description)
    .then(response => {
      toast.showToast(req, 'success', 'Progress Report filled successfully');
      res.redirect('/student/progressReports');
    })
    .catch(err => {
      toast.showToast(req, 'error', 'Cannot fill report');
      res.redirect('/student/progressReports');
    });
});

/* Link Publication to a specific thesis */
router.post('/linkPublication', (req, res) => {
  const publicationId = req.body.publication_id;
  const thesisSerialNumber = req.body.thesis_serial_number;
  studentProcedures
    .linkPubThesis(publicationId, thesisSerialNumber)
    .then(response => {
      toast.showToast(req, 'success', 'Publication linked successfully');
      res.redirect('/student/publications');
    })
    .catch(err => {
      toast.showToast(req, 'error', 'Cannot link Publication');
      res.redirect('/student/publications');
    });
});

module.exports = router;
