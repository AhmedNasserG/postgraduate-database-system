const authUser = function (req, res, next) {
  if (req.session.type) {
    next();
  } else {
    res.status(401);
    res.redirect('/');
  }
};

module.exports = { authUser };
