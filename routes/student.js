const express = require('express');
const moment = require('moment');
const router = express.Router();
const studentProcedures = require('../procedures/studentProcedures');

/* GET home page. */
router.get('/', function (req, res, next) {
  const type = req.session.type;
  res.render('student/studentDashboard', { type: type });
});

router.get('/profile', (req, res) => {
  const id = req.session.userId;
  const type = req.session.type;
  studentProcedures.viewMyProfile(id).then((response) => {
    const profile = response.recordset[0];
    res.render('student/studentProfile', {
      profile: profile,
      type: type
    });
  })
});

router.get('/theses', (req, res) => {
  const id = req.session.userId;
  const type = req.session.type;
  studentProcedures.viewAllMyTheses(id).then((response) => {
    const theses = response.recordset;
    res.render('student/studentTheses', {
      theses: theses, moment: moment,
      type: type, today: new Date()
    });
  })
});

router.get('/courses', (req, res) => {
  const id = req.session.userId;
  const type = req.session.type;
  studentProcedures.viewCoursesGrades(id).then((response) => {
    const courses = response.recordset;
    res.render('student/studentCourses', { courses: courses, type: type });
  })
});

router.get('/progressReports', (req, res) => {
  const id = req.session.userId;
  const type = req.session.type;
  studentProcedures.viewMyReports(id).then((response) => {
    const reports = response.recordset;
    res.render('student/studentReports', {
      reports: reports,
      type: type,
      moment: moment
    })
  })
});

router.get('/publications', (req, res) => {
  const id = req.session.userId;
  const type = req.session.type;
  studentProcedures.viewMyPublications(id).then((response) => {
    const publications = response.recordset;
    res.render('student/studentPublications', { publications: publications, type: type });
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
  studentProcedures.addProgressReport(
    thesisSerialNumber,
    date
  ).then(response => {
    res.redirect('/student/theses');
  }).catch(err => {

  })
});

/* Fill Progress Report */
router.post('/:thesisSerialNumber/:reportNumber/report', (req, res) => {
  const state = req.body.state;
  const description = req.body.description;
  const thesisSerialNumber = req.params.thesisSerialNumber;
  const reportNumber = req.params.reportNumber;
  try {
    studentProcedures.fillProgressReport(
      thesisSerialNumber,
      reportNumber,
      state,
      description
    )
    res.redirect('/student/progressReports');
  } catch (err) {
    res.redirect('/student/progressReports');
  }
});

module.exports = router;
