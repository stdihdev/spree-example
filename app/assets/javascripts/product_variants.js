window.jQuery(function($) {
  "use strict";

  $('.product-variant-list .primary-option-value-box').on('click', function(e) {
    e.preventDefault();

    var id = $(this).data('id');
    $('.variants-box').hide();
    $('#variants-box-' + id).show();

    // If any one of the variants is enabled
    if ($('#hidden-variants-box-' + id + ', #variants-box-' + id)
      .find('.product-variant-button').is(':enabled')) {
      // Check the first one
      $('#hidden-variants-box-' + id + ', #variants-box-' + id)
        .find('.product-variant-button:enabled:first')
        .prop('checked', true)
        .trigger('change');
    } else { // If none of the variants is enabled
      $('.product-variant-button')
        .prop('checked', false)
        .trigger('change'); // Set them all to unchecked
    }

    $('.primary-option-value-box').removeClass('selected');
    $(this).addClass('selected');

    return false;
  });

  $('.product-variant-button').on('change', function() {
    $('label.product-variant.selected').removeClass('selected');

    var message = $('#variant-availability').clone().removeClass('js-animate');
    $('#variant-availability').remove();
    $('.product-variant-list').append(message);
    $('#variant-availability').addClass('js-animate');

    var $label = $(this).parents('label');
    if ($(this).prop('checked')) {
      $label.addClass('selected');

      $('.price.selling').text($(this).data('price'));

      Spree.showVariantImages($(this).val());

      if ($label.data('sold-out')) {
        $('#variant-availability').text($label.data('sold-out')).addClass('sold-out');
      } else if ($label.data('limited')) {
        $('#variant-availability').text($label.data('limited')).addClass('limited');
      } else {
        $('#variant-availability').empty();
      }
    }

    // If any variant is checked
    if ($('.product-variant-button:enabled').is(':checked')) {
      $('#add-to-cart-button').prop('disabled', false); // Enable the 'Add to Cart' button
    } else {
      $('#add-to-cart-button').prop('disabled', true); // Disable the 'Add to Cart' button
      $('#variant-availability').empty(); // If nothing is selected, we shouldn't show the availability notice
    }

    return true;
  });

  $('.product-variant-list .primary-option-value-box.selected:first').trigger('click');
});
