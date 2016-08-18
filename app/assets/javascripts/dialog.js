window.jQuery(function ($) {
  'use strict';

  $('.dialog .dialog-close').on('click', function (e) {
    e.preventDefault();

    $(this).parents('.dialog').hide();
    $('#overlay').hide();

    return false;
  });
});
