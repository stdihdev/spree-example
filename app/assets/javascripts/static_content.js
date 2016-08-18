(function($) {
  "use strict";

  var ready = function() {
    $('.tab-link').on('click', function(e) {
      e.preventDefault();

      $('.tab-page').removeClass('active');
      $($(this).data('target')).addClass('active');

      return false;
    });
  };

  $(document).ready(ready);
  $(document).on('page:load', ready);
}(window.jQuery));
