window.jQuery(function ($) {
  "use strict";

  $('.product-variant-list .primary-option-value-box').on('click', function (e) {
    e.preventDefault();

    var id = $(this).data('id');
    $('.variants-box').hide();
    $('#variants-box-' + id).show();
    $('#hidden-variants-box-' + id + ', #variants-box-' + id)
      .find('.product-variant-button:enabled:first')
      .prop('checked', true)
      .trigger('change');

    $('.primary-option-value-box').removeClass('selected');
    $(this).addClass('selected');

    return false;
  });

  $('.product-variant-button').on('change', function () {
    $('label.product-variant.selected').removeClass('selected');

    var message = $('#variant-availability').clone().removeClass('js-animate');
    $('#variant-availability').remove();
    $('.product-variant-list').append(message);
    $('#variant-availability').addClass('js-animate');

    var $label = $(this).parents('label');
    if($(this).prop('checked')) {
      $label.addClass('selected');

      if($label.data('sold-out')) {
        $('#variant-availability').text($label.data('sold-out')).addClass('sold-out');
      } else if($label.data('limited')) {
        $('#variant-availability').text($label.data('limited')).addClass('limited');
      } else {
        $('#variant-availability').empty();
      }
    }

    return true;
  });

  $('.product-variant-list .primary-option-value-box.selected:first').trigger('click');
});
