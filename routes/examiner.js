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
module.exports = router;
