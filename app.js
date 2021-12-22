const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const session = require('express-session');

// routes
const loginRoute = require('./routes/login');
const registerRoute = require('./routes/register');
const app = express();

// view engine setup
app.use(
  session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true
  })
);
app.set('view engine', 'ejs');
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use(express.static('public'));

app.use('/', loginRoute);
app.use('/register', registerRoute);

app.listen(4000, () => {
  console.log('Server is running on port 4000');
});
