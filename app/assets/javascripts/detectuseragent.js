/**
 * Determine the user agent
 * The function isMobile returns TRUE if the user agent matches one of
 * 'Android', 'BlackBerry', 'iPhone', 'iPad', 'iPod', 'Opera Mini' or 'IEMobile'
 *
 * @returns {String}
 */

var isMobile = {
    Android: function () {
        return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function () {
        return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function () {
        return navigator.userAgent.match(/iPhone|iPod|iPad/i);
    },
    Opera: function () {
        return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function () {
        return navigator.userAgent.match(/IEMobile/i);
    },
    any: function () {
        return ((isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows()));
    }
};

/**
 * Call the function and return a custom string to mark touch enabled devices if isMobile returns TRUE
 *
 * @returns {String}
 */

var detectDevice = function detectDevice() {
    var result = 'no-touch';
    if (isMobile.any()) {
        result = 'touch';
    }
    return result;
};

/**
 * This function sets the html class depending on the user agent detection returned result in vanilla JS
 *
 */
var classname = detectDevice();
document.querySelector('html').classList.add(classname);
