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
    res.render('admin/theses', {
      theses: response.recordset,
      numOfOnGoing: numOfOnGoing,
      moment: moment
    });
  });
});

router.post('/:thesis_serial_number/issue-payment', function (req, res) {
  adminProcedures
    .issueThesisPayment(
      req.params.thesis_serial_number,
      req.body.amount,
      req.body.numOfInstallments,
      req.body.fundPercentage
    )
    .then(response => {
      if (response.output.success) {
        console.log('payment issued successfully');
      } else {
        console.log('payment failed');
      }
      res.redirect('/admin/theses');
    });
});

router.post('/:thesis_serial_number/update-extension', function (req, res) {
  adminProcedures
    .updateExtension(req.params.thesis_serial_number)
    .then(response => {
      console.log('extension updated successfully');
      res.redirect('/admin/theses');
    });
});

module.exports = router;
