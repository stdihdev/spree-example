Spree.ready ($) ->
  if ($ 'form#update-cart').is('*')
    removeItem = ->
      ($ this).parents('.line-item').first().find('input.line_item_quantity').val 0
      ($ this).parents('form').first().submit()
      false

    ($ 'form#update-cart a.delete').show().on 'click', ->
      if ($ this).data('confirm')
        if window.confirm ($ this).data('confirm')
          (removeItem.call this)
        false
      else
        (removeItem.call this)


  ($ 'form#update-cart').submit ->
    ($ 'form#update-cart #update-button').attr('disabled', true)

Spree.fetch_cart = ->
  $.ajax
    url: Spree.pathFor("cart_link"),
    success: (data) ->
      $('#link-to-cart').html data
