const express = require('express');
const moment = require('moment');
const router = express.Router();
const adminProcedures = require('../procedures/adminProcedures');

/* GET home page. */
router.get('/', function (req, res, next) {
  res.render('admin/adminDashboard');
});

router.get('/supervisors', function (req, res) {
  adminProcedures.listSupervisors().then(response => {
    res.render('admin/supervisors', { supervisors: response.recordset });
  });
});

router.get('/theses', function (req, res) {
  numOfOnGoing = 0;
  adminProcedures.numOfOnGoingTheses().then(response => {
    numOfOnGoing = response.output.count;
  });

  adminProcedures.listTheses().then(response => {
    console.log(response.recordset);
    res.render('admin/theses', {
      theses: response.recordset,
      numOfOnGoing: numOfOnGoing,
      moment: moment
    });
  });
});

module.exports = router;
