const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const session = require('express-session');
const sql = require('mssql');
require('dotenv').config();
const sqlConfig = {
  user: process.env.DB_USER_ADMIN,
  password: process.env.DB_PASS_ADMIN,
  database: 'pg_database',
  server: 'localhost',
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  },
  options: {
    encrypt: true, // for azure
    trustServerCertificate: true // change to true for local dev / self-signed certs
  }
};
const connect = async () => {
  try {
    // make sure that any items are correctly URL encoded in the connection string
    await sql.connect(sqlConfig);
  } catch (err) {
    console.log(err.message);
  }
};
// routes
const loginRoute = require('./routes/login');
const registerRoute = require('./routes/register');
const adminRoute = require('./routes/admin');
const studentRoute = require('./routes/student');
const supervisorRoute = require('./routes/supervisor');
const examinerRoute = require('./routes/examiner');
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
app.use(
  '/examiner',
  express.static(path.join(__dirname, 'public/stylesheets'))
);
app.use('/student', express.static(path.join(__dirname, 'public/stylesheets')));
app.use(
  '/supervisor',
  express.static(path.join(__dirname, 'public/stylesheets'))
);

app.use(express.static('public'));

app.use('/', loginRoute);
app.use('/register', registerRoute);
app.use('/admin', adminRoute);
app.use('/student', studentRoute);
app.use('/supervisor', supervisorRoute);
app.use('/examiner', examinerRoute);

const port = process.env.PORT || 4000;
app.listen(
  port,
  connect().then(() => {
    console.log(`Server started on port ${port}`);
  })
);
