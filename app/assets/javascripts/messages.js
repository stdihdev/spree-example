window.jQuery(function ($) {
  $('.message-close').on('click', function (e) {
    e.preventDefault();

    $(this).parents('.message').fadeOut('slow');

    return false;
  });
});
