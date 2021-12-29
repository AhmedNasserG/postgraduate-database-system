const express = require('express');
const router = express.Router();
const userProcedures = require('../procedures/userProcedures');

router.get('/', function (req, res, next) {
  routeUser(req.session, res);
});

router.post('/', function (req, res) {
  const email = req.body.email;
  const password = req.body.password;
  try {
    userProcedures.userLogin(email, password).then(response => {
      if (response.output.success == false) {
        res.render('login', { verify: 'no' });
      } else {
        req.session.userId = response.output.id;
        userProcedures.userType(response.output.id).then(response => {
          req.session.type = response.output.type;
          routeUser(req.session, res);
        });
      }
    });
  } catch (err) {
    console.log(error);
  }
});

function routeUser(session, res) {
  if (session.type == 0 || session.type == 4) {
    res.redirect('/student');
  } else if (session.type == 1) {
    res.redirect('/supervisor');
  } else if (session.type == 2) {
    res.redirect('/examiner');
  } else if (session.type == 3) {
    res.redirect('/admin');
  } else {
    res.render('login');
  }
}

module.exports = router;
