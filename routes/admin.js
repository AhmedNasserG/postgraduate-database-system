const express = require('express');
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

module.exports = router;
