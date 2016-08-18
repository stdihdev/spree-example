window.jQuery(function($) {
  $('#locale-select select').change(function () {
    $.ajax({
      type: 'POST',
      url: $(this).data('href'),
      data: {
        locale: $(this).val(),
        authenticity_token: $('#locale-select input[name="authenticity_token"]').val()
      }
    }).done(function () {
      window.location.reload();
    })
  });
});
