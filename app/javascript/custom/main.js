$(document).on('turbolinks:load', function() {
  $(".add-new-question").click(function() {
    $(".add-question-btn a").click();
    $(".question-missing-error").html('')
  });
});