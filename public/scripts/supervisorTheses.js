async function getSelectedCheckboxes() {
  var selectedCheckboxes = [];
  var checkboxes = document.querySelectorAll('input[type="checkbox"]');
  checkboxes.forEach(function (checkbox) {
    if (checkbox.checked) {
      var row = checkbox.parentNode.parentNode;
      var id = row.cells[1].innerHTML.trim();
      var name = row.cells[2].textContent.trim();
      var field = row.cells[3].innerHTML.trim();
      var is_national = row.cells[4].textContent.trim();
      selectedCheckboxes.push({
        id: id,
        name: name,
        field: field,
        is_national: is_national
      });
    }
  });
  data = JSON.stringify(selectedCheckboxes);
  var examinerSerialized = document.getElementById('examiner');
  examinerSerialized.value = data;
  examinerSerialized.form.submit();
}
