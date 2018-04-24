var ListUpdateAdvertiser = (function() {
  var ListUpdateAdvertiser = {}

  ListUpdateAdvertiser.init = function() {
    MessageBus.start()

    MessageBus.callbackInterval = 30000;

    MessageBus.subscribe("/list_advertiser", function(data){
      toastr.info(data.message)
    });
  }

  return ListUpdateAdvertiser
})();
