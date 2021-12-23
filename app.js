const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const session = require('express-session');
const sql = require('mssql');
const sqlConfig = {
  user: 'sa',
  password: 'Password123',
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
    const request = new sql.Request();
  } catch (err) {
    console.log(err.message);
  }
};
// routes
const loginRoute = require('./routes/login');
const registerRoute = require('./routes/register');
const studentRoute = require('./routes/student');
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

app.listen(
  4000,
  connect().then(() => {
    console.log('Server is running on port 4000');
  })
);
