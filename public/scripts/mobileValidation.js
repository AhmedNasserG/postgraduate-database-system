  function validate(form) {
      console.log('validate');
      mobileField = document.getElementById('mobile');
      // check if mobile is valid with regex
      if (!mobileField.value.match(/^[0-9]{11}$/)) {
        mobileField.setCustomValidity('Mobile number must be 11 digits');
        mobileField.reportValidity();
        mobileField.style.borderColor = 'red';
        mobileField.focus();
        return false;
      }
      mobileField.setCustomValidity('');
      mobileField.style.borderColor = 'green';
      return true;
    }
