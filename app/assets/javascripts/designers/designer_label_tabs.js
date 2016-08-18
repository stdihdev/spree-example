window.jQuery(function($) {
  "use strict";

  $('.designer-label-button.tab-button').on('click', function(e) {
    e.preventDefault();

    var $t = $(this);

    $('.designer-label-button.tab-button, .designer-label-page').removeClass('active');
    $t.addClass('active');
    if ($t.data('target')) {
      $($t.data('target')).addClass('active');
    }

    return false;
  });
});
