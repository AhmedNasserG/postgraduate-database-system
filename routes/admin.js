const express = require('express');
const router = express.Router();
const adminProcedures = require('../procedures/adminProcedures');
const toast = require('../utilities/toast');
const { authUser, authRole, ROLE } = require('../utilities/auth');

router.get('/', authUser, authRole([ROLE.ADMIN]), function (req, res, next) {
  res.render('admin/adminDashboard');
});

router.get('/profile', authUser, authRole([ROLE.ADMIN]), (req, res) => {
  const id = req.session.userId;
  adminProcedures.adminViewProfile(id).then(response => {
    const profile = response.recordset[0];
    res.render('admin/adminProfile', {
      admin: profile
    })
  });
});

router.get(
  '/supervisors',
  authUser,
  authRole([ROLE.ADMIN]),
  function (req, res) {
    adminProcedures
      .listSupervisors()
      .then(response => {
        res.render('admin/supervisors', { supervisors: response.recordset });
      })
      .catch(err => {
        res.redirect('/');
      });
  }
);

router.get('/theses', authUser, authRole([ROLE.ADMIN]), function (req, res) {
  adminProcedures
    .listTheses()
    .then(thesesResponse => {
      adminProcedures.numOfOnGoingTheses().then(response => {
        res.render('admin/theses', {
          theses: thesesResponse.recordset,
          numOfOnGoing: response.output.count
        });
      });
    })
    .catch(err => {
      res.redirect('/');
    });
});

router.post('/:thesis_serial_number/issue-payment', function (req, res) {
  adminProcedures
    .getThesisPaymentId(req.params.thesis_serial_number)
    .then(response => {
      if (!response.output.payment_id) {
        adminProcedures
          .issueThesisPayment(
            req.params.thesis_serial_number,
            req.body.amount,
            req.body.numOfInstallments,
            req.body.fundPercentage
          )
          .then(response2 => {
            if (response2.output.success) {
              toast.showToast(req, 'success', 'Payment issued successfully');
            } else {
              toast.showToast(
                req,
                'error',
                'Issue Payment failed, Please try again'
              );
            }
            res.redirect('/admin/theses');
          })
          .catch(err => {
            toast.showToast(
              req,
              'error',
              'Issue Payment failed, Please try again'
            );
            res.redirect('/admin/theses');
          });
      } else {
        toast.showToast(req, 'error', 'Payment already issued');
        res.redirect('/admin/theses');
      }
    });
});

router.post(
  '/:thesis_serial_number/issue-payment-installment',
  function (req, res) {
    adminProcedures
      .getThesisPaymentId(req.params.thesis_serial_number)
      .then(response => {
        if (!response.output.payment_id) {
          toast.showToast(
            req,
            'error',
            'Issue an installment failed because there is not a payment related to the thesis'
          );
          res.redirect('/admin/theses');
        } else {
          adminProcedures
            .issueThesisPaymentInstallment(
              response.output.payment_id,
              req.body.installmentDate
            )
            .then(response2 => {
              toast.showToast(
                req,
                'success',
                'Payment installment issued successfully'
              );
              res.redirect('/admin/theses');
            })
            .catch(err => {
              toast.showToast(req, 'error', 'Issue an installment failed');
              res.redirect('/admin/theses');
            });
        }
      })
      .catch(err => {
        toast.showToast(req, 'error');
        res.redirect('/admin/theses');
      });
  }
);

router.post('/:thesis_serial_number/update-extension', function (req, res) {
  adminProcedures
    .updateExtension(req.params.thesis_serial_number)
    .then(response => {
      toast.showToast(req, 'success', 'Extension updated successfully');
      res.redirect('/admin/theses');
    })
    .catch(err => {
      toast.showToast(req, 'error', 'Update extension failed');
      res.redirect('/admin/theses');
    });
});

module.exports = router;
