var express = require('express');
var router = express.Router();
const examinerProcedures = require('../procedures/examinerProcedures');
const moment = require('moment');
const toast = require('../utilities/toast');

/* GET home page. */
router.get('/', function (req, res, next) {
  /* if(req.session.type !==2){
    res.redirect('/')
  }*/
  res.render('examiner/examinerDashboard');
});

//get theses
router.get('/theses', function (req, res) {
  /* if(req.session.type !== 2){
    res.redirect('/')
  }*/
  const id = req.session.userId;
  console.log(id);
  examinerProcedures.showExaminerTheses(id).then(response => {
    console.log(response.recordset);
    res.render('examiner/examinerTheses', { Theses: response.recordset });
  });
});

//get defenses
router.get('/defenses', function (req, res) {
  const id = req.session.userId;
  examinerProcedures.showExaminerDefenses(id).then(response => {
    res.render('examiner/examinerDefenses', {
      Defenses: response.recordset
    });
  });
});

router.post('/addGrade', function (req, res) {
  const thesisSerialNumber = req.body.thesis;
  const defenseDate = req.body.Date;
  const grade = req.body.grade;
  console.log(thesisSerialNumber);
  console.log(defenseDate);
  console.log(grade);
  examinerProcedures
    .addGrade(thesisSerialNumber, defenseDate, grade)
    .then(response => {
      toast.showToast(req,'success','Grade added successfully')
      res.redirect('/examiner/defenses')  
    })
    .catch(err => {
      toast.showToast(req,'error','Grade not added Please try again')    
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
      toast.showToast(req,'success','Comment added successfully')
      res.redirect('/examiner/defenses')  
    })
    .catch(err => {
      toast.showToast(req,'error','Grade not added Please try again')    
      res.redirect('/examiner/defenses');
    });
});

router.get('/search', function (req, res) {
  res.render('examiner/examinerSearch');
});

router.post('/search', function (req, res) {
  const searchTerm = req.body.searchTerm.trim();
  if (searchTerm === '') {
    toast.showToast(req,'error','Please add value to search for')    
     res.redirect('/examiner/search')
  } else {
    console.log(searchTerm);
    examinerProcedures.searchForThesis(searchTerm).then(response => {
      console.log(response.recordset);
      res.render('examiner/examinerSearch', {
        theses: response.recordset,
        moment: moment
      });
    });
  }
});

module.exports = router;
