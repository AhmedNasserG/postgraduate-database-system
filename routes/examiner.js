var express = require('express');
var router = express.Router();
const examinerProcedures = require('../procedures/examinerProcedures');
const moment = require('moment');
const toast = require('../utilities/toast');
const { authUser, authRole, ROLE } = require('../utilities/auth');

router.get('/', authUser, authRole([ROLE.EXAMINER]), function (req, res, next) {
  res.render('examiner/examinerDashboard');
});

router.get(
  '/theses',
  authUser,
  authRole([ROLE.EXAMINER]),
  async function (req, res) {
    const id = req.session.userId;
    console.log(id);

    await examinerProcedures.showExaminerTheses(id).then(async response => {
      let supervisors = [];
      theses = response.recordset;
      for (thesis of theses) {
        await examinerProcedures
          .showThesisSupervisors(thesis.serial_number)
          .then(response1 => {
            supervisors.push(response1.recordset);
          });
      }
      console.log(supervisors);
      res.render('examiner/examinerTheses', {
        Theses: response.recordset,
        supervisors: supervisors
      });
    });
  }
);

router.get(
  '/defenses',
  authUser,
  authRole([ROLE.EXAMINER]),
  function (req, res) {
    const id = req.session.userId;
    examinerProcedures.showExaminerDefenses(id).then(response => {
      res.render('examiner/examinerDefenses', {
        Defenses: response.recordset
      });
    });
  }
);

router.get('/search', authUser, authRole([ROLE.EXAMINER]), function (req, res) {
  res.render('examiner/examinerSearch', { theses: [] });
});

//get profile
router.get(
  '/profile',
  authUser,
  authRole([ROLE.EXAMINER]),
  function (req, res) {
    const id = req.session.userId;
    examinerProcedures.showProfile(id).then(response => {
      console.log(response.recordset);
      res.render('examiner/examinerProfile', { examiner: response.recordset });
    });
  }
);
router.post('/addGrade', function (req, res) {
  const thesisSerialNumber = req.body.thesis;
  const defenseDate = req.body.Date;
  const grade = req.body.grade;
  console.log(defenseDate)
  examinerProcedures
    .addGrade(thesisSerialNumber, defenseDate, grade)
    .then(response => {
      toast.showToast(req, 'success', 'Grade added successfully');
      res.redirect('back');
    })
    .catch(err => {
      toast.showToast(req, 'error', 'Grade not added Please try again');
      res.redirect('/examiner/defenses');
    });
});

router.post('/addComment', function (req, res) {
  const id = req.session.userId;
  const thesisSerialNumber = req.body.thesis;
  const defenseDate = req.body.Date;
  const comment = req.body.comment;
  console.log(defenseDate)
  examinerProcedures
    .addComment(id, thesisSerialNumber, defenseDate, comment)
    .then(response => {
      toast.showToast(req, 'success', 'Comment added successfully');
      res.redirect('/examiner/defenses');
    })
    .catch(err => {
      toast.showToast(req, 'error', 'Grade not added Please try again');
      res.redirect('/examiner/defenses');
    });
});

router.post('/search', function (req, res) {
  const searchTerm = req.body.searchTerm.trim();
  if (searchTerm === '') {
    toast.showToast(req, 'error', 'Please add value to search for');
    res.redirect('/examiner/search');
  } else {
    console.log(searchTerm);
    examinerProcedures.searchForThesis(searchTerm).then(response => {
      response.recordset.forEach(thesis => {
        thesis.title = thesis.title.replace(
          new RegExp(searchTerm, 'gi'),
          `<span class="highlight">${searchTerm}</span>`
        );
        console.log(typeof thesis.title);
        thesis.title = thesis.title.toLowerCase();
      });
      console.log(response.recordset);
      res.render('examiner/examinerSearch', {
        theses: response.recordset
      });
    });
  }
});

router.post('/profile', function (req, res) {
  const id = req.session.userId;
  const name = req.body.name;
  const email = req.body.email;
  const fieldOfWork = req.body.fieldOfWork;
  const type = req.body.type;
  examinerProcedures
    .updateProfile(id, name, email, fieldOfWork, type)
    .then(response => {
      console.log(response);
      toast.showToast(req, 'success', 'Profile updated successfully');
      res.redirect('/examiner/profile');
    })
    .catch(err => {
      toast.showToast(req, 'error', 'Profile not updated please try again');
      res.redirect('/examiner/profile');
    });
});
module.exports = router;
