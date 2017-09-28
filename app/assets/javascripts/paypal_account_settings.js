window.ST = window.ST || {};
var newwindow=null;

(function(module) {


  module.initializeNewPaypalAccountHandler = function(linkId, action, redirectMessageSelector) {
    var $link = $('#'+linkId);
    var spinner = new Image();
    spinner.src = "https://s3.amazonaws.com/sharetribe/assets/ajax-loader-grey.gif";
    spinner.className = "send-button-loading-img";

    $link.click(function(){
      $link.after(spinner);
      $link.addClass("send-button-loading").blur();

      $.ajax({
        type: 'GET',
        url: action,
        success: function(response){
          var $redirectLink = $('#' + linkId + '_redirect');
          $redirectLink.attr('href', response.redirect_url);
          $(redirectMessageSelector).removeClass('hidden');
          // window.location = response.redirect_url;
          PopupCenter(response.redirect_url, 953,555);
        }
      });

    });
  };

  module.initializePayPalPreferencesForm = function(formId, commissionRange) {
    var $form = $('#' + formId);
    var $currency = $form.find('#paypal_preferences_form_marketplace_currency');
    var $currencyLabels = $form.find('.paypal-preferences-currency-label');
    var $warning = $form.find('.paypal-currency-change-warning-text');

    $currency.on('change', function() {
      $currencyLabels.text($currency.val());
      $warning.show();
    });

    $form.validate({
      errorPlacement: function(error, element) {
        error.appendTo(element.parent());
      },
      rules: {
        "paypal_preferences_form[commission_from_seller]": {
          required: true,
          number_min: commissionRange[0],
          number_max: commissionRange[1],
          number_no_decimals: true
        },
        "paypal_preferences_form[minimum_listing_price]": {
          required: true
        },
        "paypal_preferences_form[minimum_transaction_fee]": {
          required: true,
          number_min: 0
        }
      }
    });
  };

})(window.ST);

function FindLeftWindowBoundry()
{
  // In Internet Explorer window.screenLeft is the window's left boundry
  if (window.screenLeft)
  {
    return window.screenLeft;
  }

  // In Firefox window.screenX is the window's left boundry
  if (window.screenX)
    return window.screenX;

  return 0;
}
// Find Left Boundry of current Window
function FindTopWindowBoundry()
{
  // In Internet Explorer window.screenLeft is the window's left boundry
  if (window.screenTop)
  {
    return window.screenTop;
  }

  // In Firefox window.screenY is the window's left boundry
  if (window.screenY)
    return window.screenY;

  return 0;
}
function PopupCenter(url, width, height) {
  console.log(FindLeftWindowBoundry(), FindTopWindowBoundry());
  var x = screen.width/2 - width/2 + FindLeftWindowBoundry();
  var y = screen.height/2 - height/2 + FindTopWindowBoundry();
  newwindow=window.open(url, '_blank','height=555,width=953,left='+x+',top='+y);
  localStorage.setItem("newwindow",newwindow);

}








