const authUser = function (req, res, next) {
  if (req.session.type) {
    next();
  } else {
    res.status(401);
    res.redirect('/');
  }
};

const authRole = function (role) {
  return (req, res, next) => {
    if (req.session.type == role) {
      next();
    } else {
      res.status(401);
      res.send('Unauthorized');
    }
  };
};

module.exports = { authUser, authRole };
