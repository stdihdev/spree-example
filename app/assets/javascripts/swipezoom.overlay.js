/*jslint white:true */
/*jslint this:true */
/*jslint browser:true */
/*global window */

(function ($) {
  'use strict';

  $.fn.zoomOverlay = function ($image, thumbindex) {
    var suspendScrolling = false;
    var image_index;
    var images = [];
    var $overlay = $(this);
    var $closebutton = $overlay.find('.close-overlay');
    var $next_image = $overlay.find('.thumb-next');
    var $prev_image = $overlay.find('.thumb-prev');
    var $swipe = $overlay.find('.swipe');
    var swipe;

    var checkNextPage = function (selector, el) {
      var $pagenav = $('.pagination');
      var $nextpage = $pagenav.find(selector).find('a');
      // Make sure it's not the first or last page
      if($nextpage.attr('href')) {
        el.removeClass('last');
        if(el == $prev_image) {
          el.find('.goto-page').show().attr('href', $nextpage.attr('href')).text($nextpage.text().split(' ')[1]);
        } else {
          el.find('.goto-page').show().attr('href', $nextpage.attr('href')).text($nextpage.text().split(' ')[0]);
        }
      } else {
        el.addClass('last');
      }
    };

    var updateImages = function () {
      $overlay.find('.overlay-product-name').text(images[image_index].productName);
      $overlay.find('.overlay-product-designer').empty().append($('<a href="' + images[image_index].productDesignerLink + '"></a>').text(images[image_index].productDesigner));
      $overlay.find('.overlay-product-link').attr('href', images[image_index].productLink);

      if (image_index > 0) {
        $prev_image
          .removeClass('end')
          .find('img')
          .attr({
            src: images[image_index - 1].large,
            srcset: images[image_index - 1].large_2x + ' 2x'
          })
          .show();
      } else {
        $prev_image.addClass('end').find('img').hide();
        if ( !$('body').is('#product-details' ) ) {
          checkNextPage('.prev', $prev_image);
        }
      }

      if (image_index < images.length - 1) {
        $next_image
          .removeClass('end')
          .find('img')
          .attr({
            src: images[image_index + 1].large,
            srcset: images[image_index + 1].large_2x + ' 2x'
          })
          .show();
      } else {
        $next_image.addClass('end').find('img').hide();
        if ( !$('body').is('#product-details' ) ) {
          checkNextPage('.next_page', $next_image);
        }
      }
    };

    var openOverlay = function () {
      $('body').addClass('flyout-open');
      $overlay.fadeIn('slow');

      // Set the thumb index
      image_index = thumbindex();

      // Set PREV and NEXT images
      updateImages();

      // If set to 'true', scrolling on mouse devices gets suspended
      // when hovering the navigational PREV and NEXT thumbs
      suspendScrolling = false;
    };

    var mouseMoveHandler = function (e) {
      if ($('html').is('.no-touch') && !suspendScrolling) {
        $('html, body').stop().scrollTop(function () {
          var zoom_height = $overlay.find('.swipe-slide:eq(' + image_index + ')').find('img').height();
          var winheight = $(window).height(),
            diff = zoom_height - winheight,
            t_percent = e.clientY / winheight,
            t = t_percent * diff;

          return t;
        });
      } else {
        $('html, body').stop().animate({
          scrollTop: 0
        }, '150', 'swing');
      }
    };

    var closeOverlay = function () {
      $overlay.fadeOut('fast');
      $('html, body').scrollTop(0, 0);
      // Remove Document Event Listener
      $(document).off('mousemove', mouseMoveHandler);
      $(document).off('keydown');
      $(window).off('blur mouseleave');
      $('body').removeClass('flyout-open');
    };

    $overlay.find('img.swipe-image').each(function (index) {
      var $img = $(this);

      images[index] = {
        id: $img.data('image-id'),
        large: $img.data('large'),
        large_2x: $img.data('large_2x'),
        productName: $img.data('product-name'),
        productDesigner: $img.data('product-designer'),
        productDesignerLink: $img.data('product-designer-link'),
        productLink: $img.data('product-link')
      };
    });

    $(document).on('keydown', function (e) {
      // ESCAPE key pressed
      if (e.keyCode === 27) {
        closeOverlay();
      }
    });

    $closebutton.on('click', function (e) {
      e.preventDefault();
      closeOverlay();
    });

    // Initial Click Handler
    $image.on('click', function (e) {
      e.preventDefault();

      // Kill any possible existing leftovers of Swipe
      if (swipe) {
        swipe.kill();
      }
      // Now open the overlay
      openOverlay();

      // Initiate Swipe object
      swipe = new window.Swipe($swipe[0], {
        startSlide: image_index,
        speed: 400,
        auto: false,
        continuous: false,
        disableScroll: false,
        stopPropagation: false,
        callback: function () {
          image_index = swipe.getPos();
          // Update Prev Next images
          updateImages();
        }
      });

      // Scroll to document top
      $('html, body').stop().scrollTop(0);

      $prev_image.on('click', function () {
        // e.preventDefault();
        swipe.prev();
      }).on('mouseenter', function () {
        // Suspend scrolling by 'mousemouse'
        suspendScrolling = true;
      }).on('mouseleave', function () {
        // Re-activate scrolling
        suspendScrolling = false;
      });

      $next_image.on('click', function () {
        // e.preventDefault();
        swipe.next();
      }).on('mouseenter', function () {
        // Suspend scrolling by 'mousemouse'
        suspendScrolling = true;
      }).on('mouseleave', function () {
        // Re-activate scrolling
        suspendScrolling = false;
      });

      $(document).on('mousemove', mouseMoveHandler);

      $overlay.find('.swipe-wrap').on('click', function () {
        closeOverlay();
      });

      return false;

    });

  };

}(window.jQuery));
