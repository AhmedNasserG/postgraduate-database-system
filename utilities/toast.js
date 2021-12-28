const showToast = (req, toastState, toastMessage) => {
  if (!toastMessage) {
    if (toastState === 'success') {
      toastMessage = 'Operation completed successfully';
    } else if (toastState === 'error') {
      toastMessage = 'Something wrong happened, Please try again';
    }
  }
  req.session.toastState = toastState;
  req.session.toastMessage = toastMessage;
};

const resetToast = req => {
  req.session.toastState = '';
};

module.exports = {
  showToast,
  resetToast
};
