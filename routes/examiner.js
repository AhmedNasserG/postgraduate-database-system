var express = require('express');
var router = express.Router();
const examinerProcedures = require('../procedures/examinerProcedures');

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
  const toast = req.query.toast;
  console.log(toast);
  examinerProcedures.showExaminerDefenses(id).then(response => {
    console.log(response.recordset);
    console.log(res.app.get('toast'));
    const toast = res.app.get('toast');
    const message = res.app.get('message');
    res.app.set('toast', undefined);
    res.render('examiner/examinerDefenses', {
      Defenses: response.recordset,
      toast: toast,
      message: message
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
      res.app.set('toast', 'yes');
      res.app.set('message', 'Grade added successfully');
      //console.log(router.get('message'))
      res.redirect('/examiner/defenses');
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
      console.log(response);
      res.app.set('toast', 'yes');
      res.app.set('message', 'Comment added successfully');
      //console.log(router.get('message'))
      res.redirect('/examiner/defenses');
    })
    .catch(err => {
      res.app.set('toast', 'yes');
      res.app.set('message', 'Comment not added . try again!');
      //console.log(router.get('message'))
      res.redirect('/examiner/defenses');
    });
});

module.exports = router;
