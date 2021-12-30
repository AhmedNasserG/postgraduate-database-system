var express = require('express');
var router = express.Router();
const examinerProcedures = require('../procedures/examinerProcedures');
const moment = require('moment');
const toast = require('../utilities/toast');
const { authUser, authRole, ROLE } = require('../utilities/auth');

router.get('/', authUser, authRole([ROLE.EXAMINER]), function (req, res, next) {
  res.render('examiner/examinerDashboard');
});

router.get('/theses', authUser, authRole([ROLE.EXAMINER]), async function (req, res) {
  const id = req.session.userId;
  console.log(id);
  
 await  examinerProcedures.showExaminerTheses(id)
    .then(async response => {
      let supervisors = []
     theses = response.recordset;
      for (thesis of theses){
          await examinerProcedures.showThesisSupervisors(thesis.serial_number).then(response1=>{
            supervisors.push(response1.recordset)
          })
      }
      console.log(supervisors)
      res.render('examiner/examinerTheses', { Theses: response.recordset, supervisors:supervisors});
    });
});

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
  res.render('examiner/examinerSearch', {theses:[]});
});

//get profile
router.get('/profile',function(req,res){
  res.render('examiner/examinerProfile')
})
router.post('/addGrade', function (req, res) {
  const thesisSerialNumber = req.body.thesis;
  const defenseDate = req.body.Date;
  const grade = req.body.grade;
  examinerProcedures
    .addGrade(thesisSerialNumber, defenseDate, grade)
    .then(response => {
      toast.showToast(req, 'success', 'Grade added successfully');
      res.redirect('/examiner/defenses');
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
      console.log(response.recordset);
      console.log(1)
      res.render('examiner/examinerSearch', {
        theses: response.recordset,
        moment: moment
      });
    });
  }
});

module.exports = router;
