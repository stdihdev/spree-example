Spree.ready ($) ->
  Spree.addImageHandlers = ->
    thumbnails = ($ '#product-images ul.thumbnails')

    ($ '#main-image')
      .data 'selectedThumb', ($ '#main-image img').attr('src')
      .data 'selectedThumbSrcSet', ($ '#main-image img').attr('srcset')
    ($ '#image-flyout')
      .zoomOverlay $('#main-image'), ->
        index = 0
        thumbnails.find('li').each (i) ->
          if ($(this).hasClass('selected'))
            index = i
            no
          else
            yes
        index

    thumbnails.find('a').on 'click', (event) ->
      ($ '#main-image')
        .data 'selectedThumb', ($ event.currentTarget).attr('href')
        .data 'selectedThumbSrcSet', ($ event.currentTarget).find('img').data('product-2x')
        .data 'selectedThumbId', ($ event.currentTarget).parent().attr('id')
        .find('img').data 'large', ($ event.currentTarget).find('img').data('large')
      thumbnails.find('li').removeClass 'selected'
      ($ event.currentTarget).parent('li').addClass 'selected'
      false

    thumbnails.find('li').on 'mouseenter', (event) ->
      ($ '#main-image').trigger 'zoom.destroy'
      ($ '#main-image img')
        .attr 'src', ($ event.currentTarget).find('a').attr('href')
        .attr 'srcset', ($ event.currentTarget).find('a img').data('product-2x')

    thumbnails.find('li').on 'mouseleave', (event) ->
      ($ '#main-image img')
        .attr 'src', ($ '#main-image').data('selectedThumb')
        .attr 'srcset', ($ '#main-image').data('selectedThumbSrcSet')

  Spree.showVariantImages = (variantId) ->
    ($ 'li.vtmb').hide()
    ($ 'li.tmb-' + variantId).show()
    currentThumb = ($ '#' + ($ '#main-image').data('selectedThumbId'))
    if not currentThumb.hasClass('vtmb-' + variantId)
      thumb = ($ ($ '#product-images ul.thumbnails li:visible.vtmb').eq(0))
      thumb = ($ ($ '#product-images ul.thumbnails li:visible').eq(0)) unless thumb.length > 0
      newImg = thumb.find('a').attr('href')
      ($ '#product-images ul.thumbnails li').removeClass 'selected'
      thumb.addClass 'selected'
      ($ '#main-image img').attr 'src', newImg
      ($ '#main-image').data 'selectedThumb', newImg
      ($ '#main-image').data 'selectedThumbId', thumb.attr('id')

  Spree.updateVariantPrice = (variant) ->
    variantPrice = variant.data('price')
    ($ '.price.selling').text(variantPrice) if variantPrice
  radios = ($ '#product-variants input[type="radio"]')

  if radios.length > 0
    selectedRadio = ($ '#product-variants input[type="radio"][checked="checked"]')
    Spree.showVariantImages selectedRadio.attr('value')
    Spree.updateVariantPrice selectedRadio

  Spree.addImageHandlers()

  radios.click (event) ->
    Spree.showVariantImages @value
    Spree.updateVariantPrice ($ this)
