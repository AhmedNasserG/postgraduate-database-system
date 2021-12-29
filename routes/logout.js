const express = require('express');
const router = express.Router();

router.get('/', function (req, res) {
  req.session.destroy();
  res.redirect('/');
});

module.exports = router;
