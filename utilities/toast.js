const showToast = (req, toastState, toastMessage) => {
  if (!toastMessage) {
    if (toastState === 'success') {
      toastMessage = 'Operation completed successfully';
    } else if (toastState === 'error') {
      toastMessage = 'Something wrong happened, Please try again';
    }
  }
  req.app.locals.toastState = toastState;
  req.app.locals.toastMessage = toastMessage;
};

module.exports = {
  showToast
};
