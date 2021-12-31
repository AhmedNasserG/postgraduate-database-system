const { StatusCodes } = require('http-status-codes');

const ROLE = {
  GUCIAN_STUDENT: '0',
  SUPERVISOR: '1',
  EXAMINER: '2',
  ADMIN: '3',
  NON_GUCIAN_STUDENT: '4'
};

const authUser = function (req, res, next) {
  if (req.session.type) {
    next();
  } else {
    res.status(StatusCodes.UNAUTHORIZED);
    res.redirect('/');
  }
};

const authRole = function (roles) {
  return (req, res, next) => {
    if (roles.includes(req.session.type)) {
      next();
    } else {
      res.status(StatusCodes.UNAUTHORIZED).render('error', {
        title: '401 UNAUTHORIZED',
        message: 'Error 401 : UNAUTHORIZED'
      });
    }
  };
};

module.exports = { authUser, authRole, ROLE };
