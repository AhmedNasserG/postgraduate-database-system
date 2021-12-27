var express = require('express');
var router = express.Router();
const examinerProcedures = require('../procedures/examinerProcedures');
const moment = require('moment');
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
      const id = req.session.userId;
      examinerProcedures.showExaminerDefenses(id).then(response1 => {
        console.log(response1.recordset);
        res.render('examiner/examinerDefenses', {
          Defenses: response1.recordset,
          toast: 'yes',
          message: 'grade added succesfully'
        });
      });
    })
    .catch(err => {
      res.app.set('toast', 'yes');
      res.app.set('message', 'grade not added . try again!');
      //console.log(router.get('message'))
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
      const id = req.session.userId;
      examinerProcedures.showExaminerDefenses(id).then(response1 => {
        console.log(response1.recordset);
        res.render('examiner/examinerDefenses', {
          Defenses: response1.recordset,
          toast: 'yes',
          message: 'comment added succesfully'
        });
      });
    })
    .catch(err => {
      res.app.set('toast', 'yes');
      res.app.set('message', 'Comment not added . try again!');
      //console.log(router.get('message'))
      res.redirect('/examiner/defenses');
    });
});

router.get('/search', function (req, res) {
  res.render('examiner/examinerSearch');
});

router.post('/search', function (req, res) {
  const searchTerm = req.body.searchTerm.trim();
  if (searchTerm === '') {
    res.render("examiner/examinerSearch", {
      toast: 'yes',
      message: 'please enter a value to search for'
    });
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
