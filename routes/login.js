var express = require('express');
var router = express.Router();
const userProcedures = require('../procedures/userProcedures');
/* GET users listing. */
router.get('/', function (req, res, next) {
  res.render('login');
});

router.post('/', function (req, res) {
  const email = req.body.email;
  const password = req.body.password;
  try {
    userProcedures.userLogin(email, password).then(response => {
      console.log(response.output);
      if (response.output.success == false) {
        res.render('login',{verify : 'no'});
      } else {
        req.session.id = response.output.id
        userProcedures.userType(response.output.id).then(response => {
          if (response.output.type == 0) {
            req.session.type = 0
            res.redirect('/student');
          } else if (response.output.type == 1) {
            req.session.type = 1
            res.redirect('/supervisor');
          } else if (response.output.type == 2) {
            req.session.type = 2
            res.redirect('/examiner');
          }
        });
      }
    });
  } catch (err) {
    console.log(error);
  }
});
module.exports = router;
