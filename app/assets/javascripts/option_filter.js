window.jQuery(function ($) {
  "use strict";

  $('#products-filter .products-filter-select').on('change', function (e) {
    e.preventDefault();

    $('#products-filter').submit();

    return false;
  });
});
