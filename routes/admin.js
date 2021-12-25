const express = require('express');
const router = express.Router();

/* GET home page. */
router.get('/', function (req, res, next) {
  console.log('test');
  res.render('adminDashboard');
});

module.exports = router;
