(function($) {
  "use strict";

  var ready = function() {
    $('#designer-slider').bxSlider({
      mode: 'fade',
      auto: true,
      autoHover: true,
      pager: false
    });
  };

  $(document).ready(ready);
  $(document).on('page:load', ready);
}(window.jQuery));
