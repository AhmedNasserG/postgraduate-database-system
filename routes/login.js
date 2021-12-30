const express = require('express');
const router = express.Router();
const { userLogin, userType } = require('../procedures/userProcedures');
const { ROLE } = require('../utilities/auth');

router.get('/', function (req, res, next) {
  routeUser(req, res);
});

router.post('/', function (req, res) {
  login(req, res, req.body.email, req.body.password);
});

function login(req, res, email, password) {
  try {
    userLogin(email, password).then(response => {
      if (!response.output.success) {
        res.render('login', { verify: 'no' });
      } else {
        req.session.userId = response.output.id;
        userType(response.output.id).then(response => {
          req.session.type = response.output.type;
          routeUser(req, res);
        });
      }
    });
  } catch (err) {
    console.log(error);
  }
}

function routeUser(req, res) {
  switch (req.session.type) {
    case ROLE.GUCIAN_STUDENT:
      res.redirect('/student');
      break;
    case ROLE.SUPERVISOR:
      res.redirect('/supervisor');
      break;
    case ROLE.EXAMINER:
      res.redirect('/examiner');
      break;
    case ROLE.ADMIN:
      res.redirect('/admin');
      break;
    case ROLE.NON_GUCIAN_STUDENT:
      res.redirect('/student');
      break;
    default:
      res.render('login');
  }
}

module.exports = router;
