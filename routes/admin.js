const express = require('express');
const moment = require('moment');
const router = express.Router();
const adminProcedures = require('../procedures/adminProcedures');
/* GET home page. */
router.get('/', function (req, res, next) {
  res.render('admin/adminDashboard');
});

router.get('/supervisors', function (req, res) {
  adminProcedures
    .listSupervisors()
    .then(response => {
      res.render('admin/supervisors', { supervisors: response.recordset });
    })
    .catch(err => {
      console.log(err);
      res.redirect('/');
    });
});

router.get('/theses', function (req, res) {
  adminProcedures
    .listTheses()
    .then(thesesResponse => {
      adminProcedures.numOfOnGoingTheses().then(response => {
        res.render('admin/theses', {
          theses: thesesResponse.recordset,
          numOfOnGoing: response.output.count,
          moment: moment
        });
      });
    })
    .catch(err => {
      console.log(err);
      res.redirect('/');
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
    })
    .catch(err => {
      console.log(err);
      res.redirect('/admin/theses');
    });
});

router.post(
  '/:thesis_serial_number/issue-payment-installment',
  function (req, res) {
    adminProcedures
      .getThesisPaymentId(req.params.thesis_serial_number)
      .then(response => {
        if (!response.output.payment_id) {
          console.log(
            'issue an installment failed because there is not a payment related to the thesis'
          );
        } else {
          adminProcedures
            .issueThesisPaymentInstallment(
              response.output.payment_id,
              req.body.installmentDate
            )
            .then(response => {
              console.log('payment installment issued successfully');
            });
        }
        res.redirect('/admin/theses');
      })
      .catch(err => {
        console.log(err);
        res.redirect('/admin/theses');
      });
  }
);

router.post('/:thesis_serial_number/update-extension', function (req, res) {
  adminProcedures
    .updateExtension(req.params.thesis_serial_number)
    .then(response => {
      console.log('extension updated successfully');
      res.redirect('/admin/theses');
    })
    .catch(err => {
      console.log(err);
      res.redirect('/admin/theses');
    });
});

module.exports = router;
