function validate(form) {
  console.log('validate');
  mobileField = document.getElementById('mobile');
  // check if mobile is valid with regex
  if (!mobileField.value.match(/^01[0125]([0-9]){8}$/)) {
    mobileField.setCustomValidity(
      'Mobile number must be 11 digits in the format 01[0125]XXXXXXXX'
    );
    mobileField.reportValidity();
    mobileField.style.borderColor = 'red';
    mobileField.focus();
    return false;
  }
  mobileField.setCustomValidity('');
  mobileField.style.borderColor = 'green';
  return true;
}
