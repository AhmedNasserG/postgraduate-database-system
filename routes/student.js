const express = require('express');
const moment = require('moment');
const router = express.Router();
const studentProcedures = require('../procedures/studentProcedures');

/* GET home page. */
router.get('/', function (req, res, next) {
  const isGucian = req.session.isGucian;
  res.render('student/studentDashboard', { isGucian: isGucian });
});

router.get('/profile', (req, res) => {
  const id = req.session.userId;
  const isGucian = req.session.isGucian;
  studentProcedures.viewMyProfile(id).then((response) => {
    const profile = response.recordset[0];
    res.render('student/studentProfile', {
      profile: profile,
      isGucian: isGucian
    });
  })
});

router.get('/theses', (req, res) => {
  const id = req.session.userId;
  const isGucian = req.session.isGucian;
  studentProcedures.viewAllMyTheses(id).then((response) => {
    const theses = response.recordset;
    res.render('student/studentTheses', {
      theses: theses, moment: moment,
      isGucian: isGucian
    });
  })
});

router.get('/courses', (req, res) => {
  const id = req.session.userId;
  const isGucian = req.session.isGucian;
  studentProcedures.viewCoursesGrades(id).then((response) => {
    const courses = response.recordset;
    res.render('student/studentCourses', { courses: courses, isGucian: isGucian });
  })
});

router.get('/progressReports', (req, res) => {
  const userId = req.session.userId;
  const isGucian = req.session.isGucian;
  studentProcedures.viewMyReports(userId).then((response) => {
    const reports = response.recordset;
    res.render('student/studentReports', { reports: reports, isGucian: isGucian })
  })
})

/* Add Publication to a certain thesis */
router.post('/theses', (req, res) => {
  const title = req.body.title;
  const date = req.body.date;
  const host = req.body.host;
  const place = req.body.place;
  const status = req.body.status;
  try {
    studentProcedures.addPublication(
      title,
      date,
      host,
      place,
      status,
    );
    res.redirect('/student/theses');
  } catch (err) {
    res.redirect('/student/theses');
  }
});

/* Add Progress Report to a certain thesis */
router.post('/:thesisSerialNumber/report', (req, res) => {
  const date = req.body.date;
  const thesisSerialNumber = req.params.thesisSerialNumber;
  try {
    studentProcedures.addProgressReport(
      thesisSerialNumber,
      date
    )
    res.redirect('/student/theses');
  } catch (err) {
    res.redirect('/student/theses');
  }
});

module.exports = router;
