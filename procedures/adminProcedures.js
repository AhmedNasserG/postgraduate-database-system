const sql = require('mssql');

const listSupervisors = async () => {
  const request = new sql.Request();
  return request.execute('AdminListSup');
};

const listTheses = async () => {
  const request = new sql.Request();
  return request.execute('AdminViewAllTheses');
};

const numOfOnGoingTheses = async () => {
  const request = new sql.Request();
  request.output('count', sql.int);
  return request.execute('AdminViewOnGoingTheses');
};

const issueThesisPayment = async (
  thesis_serial_number,
  amount,
  num_of_installments,
  fund_percentage
) => {
  const request = new sql.Request();
  request.input('thesis_serial_number', sql.Int, thesis_serial_number);
  request.input('amount', sql.Decimal, amount);
  request.input('num_of_installments', sql.Int, num_of_installments);
  request.input('fund_percentage', sql.Decimal, fund_percentage);
  request.output('success', sql.Bit);
  return request.execute('AdminIssueThesisPayment');
};

const issueThesisPaymentInstallment = async (payment_id, installment_date) => {
  const request = new sql.Request();
  request.input('payment_id', sql.Int, payment_id);
  request.input('installment_date', sql.Date, installment_date);
  return request.execute('AdminIssueInstallPayment');
};

const updateExtension = async thesis_serial_number => {
  const request = new sql.Request();
  request.input('thesis_serial_number', sql.Int, thesis_serial_number);
  return request.execute('AdminUpdateExtension');
};

module.exports = {
  listSupervisors,
  listTheses,
  numOfOnGoingTheses,
  issueThesisPayment,
  issueThesisPaymentInstallment,
  updateExtension
};
