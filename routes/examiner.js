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
router.get('/theses', function (req,res){
 /* if(req.session.type !== 2){
    res.redirect('/')
  }*/
  const id = req.session.userId 
  console.log(id)
  examinerProcedures.showExaminerTheses(id).then(response =>{
    console.log(response.recordset)
    res.render('examiner/examinerTheses' , {Theses : response.recordset})
  })
})

//get defenses
router.get('/defenses',function(req,res){
  const id = req.session.userId
  examinerProcedures.showExaminerDefenses(id).then(response =>{
    console.log(response.recordset)
    res.render('examiner/examinerDefenses',{Defenses : response.recordset})
  })

})

router.post('/addGrade', function(req, res){
  const thesisSerialNumber = req.body.thesis
  const defenseDate = req.body.Date
  const grade = req.body.grade
  console.log(thesisSerialNumber)
  console.log(defenseDate)
  console.log(grade)
  examinerProcedures.addGrade(thesisSerialNumber,defenseDate,grade).then(response=>{
    console.log(response)
  })
})

module.exports = router;
