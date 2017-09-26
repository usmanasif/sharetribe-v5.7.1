window.ST = window.ST || {};

window.ST.transaction = window.ST.transaction || {};


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

}

(function(module, _) {

  function toOpResult(submitResponse) {
    if (submitResponse.op_status_url) {
      return ST.utils.baconStreamFromAjaxPolling(
        { url: submitResponse.op_status_url },
        function(pollingResult) {
          return pollingResult.completed;
        }
      ).flatMap(function (pollingResult) {
        var opResult = pollingResult.result;
        if (opResult.success) {
          return opResult;
        }
        else {
          return new Bacon.Error({ errorMsg: submitResponse.op_error_msg });
        }
      });
    } else if (submitResponse.redirect_url) {
        return {
          success: true,
          data: submitResponse
        };
    } else {
      return new Bacon.Error({ errorMsg: submitResponse.error_msg });
    }
  }


  function setupSpinner($form) {
    var spinner = new Image();
    spinner.src = "https://s3.amazonaws.com/sharetribe/assets/ajax-loader-grey.gif";
    spinner.className = "paypal-button-loading-img";
    var $spinner = $(spinner);
    $form.find(".paypal-button-wrapper").append(spinner);
    $spinner.hide();

    return $spinner;
  }

  function toggleSpinner($spinner, show) {
    if (show === true) {
      $spinner.show();
    } else {
      $spinner.hide();
    }
  }


  function redirectFromOpResult(opResult) {
    console.log(opResult.data.redirect_url);
    var url= opResult.data.redirect_url;
    PopupCenter(url, 953,555);
    // window.location = opResult.data.redirect_url;
  }

  function showErrorFromOpResult(opResult) {
    ST.utils.showError(opResult.errorMsg, "error");
  }


  function initializePayPalBuyForm(formId, analyticsEvent) {
    var $form = $('#' + formId);
    var formAction = $form.attr('action');
    var $spinner = setupSpinner($form);

    // EventStream of true/false
    var submitInProgress = new Bacon.Bus();

    var formSubmitWithData = $form.asEventStream('submit', function(ev) {
      ev.preventDefault();
      return $form.serialize();
    })
      .filter(submitInProgress.not().toProperty(true)); // Prevent concurrent submissions

    var opResult = formSubmitWithData
      .flatMapLatest(function (data) { return Bacon.$.ajaxPost(formAction, data); })
      .flatMapLatest(toOpResult);

    var analyticsEventSent = formSubmitWithData
      .flatMapLatest(function() {
        var timeout = Bacon.later(3000, "timeout");
        var response = Bacon.fromCallback(function(callback) {
          ampClient.logEvent(analyticsEvent[0], analyticsEvent[1], callback);
        });

        return timeout.merge(response).take(1);
      });

    submitInProgress.plug(formSubmitWithData.map(true));
    // Success response to operation keeps submissions blocked, error releases
    submitInProgress.plug(opResult.map(true).mapError(false));
    submitInProgress.skipDuplicates().onValue(_.partial(toggleSpinner, $spinner));

    opResult.onError(showErrorFromOpResult);

    Bacon.onValues(opResult, analyticsEventSent, redirectFromOpResult);
  }

  function initializeCreatePaymentPoller(opStatusUrl, redirectUrl) {
    console.log(redirectUrl);
    ST.utils.baconStreamFromAjaxPolling(
      { url: opStatusUrl },
      function(pollingResult) {
        return pollingResult.completed;
      }
    ).onValue(function () { window.location = redirectUrl; });
  }

  function initializeFreeTransactionForm(locale) {
    window.auto_resize_text_areas("text_area");
    $('textarea').focus();
    var form_id = "#transaction-form";
    $(form_id).validate({
      rules: {
        "message": {required: true}
      },
      submitHandler: function(form) {
        window.disable_and_submit(form_id, form, "false", locale);
      }
  });

  }

  module.initializePayPalBuyForm = initializePayPalBuyForm;
  module.initializeCreatePaymentPoller = initializeCreatePaymentPoller;
  module.initializeFreeTransactionForm = initializeFreeTransactionForm;

})(window.ST.transaction, _);
