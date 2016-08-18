(function ($) {
  'use strict';

    // Set the event handler
    $(document).on('click', '#filters .sort-option', function (e) {
      e.preventDefault();

      var $filter = $('.sort-option');

      // Set the current filter
      var $this = $(this);
      var _param = $this.attr('data-sortby');

      $filter.not($this).removeClass('active');
      $this.addClass('active');

      // Toggle display of active list by parameter
      $('.js-show-by-param').hide();
      $('.js-show-by-param.' + _param).show();

    })

} (window.jQuery));
