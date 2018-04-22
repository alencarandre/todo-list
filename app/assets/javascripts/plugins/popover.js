var Popover = (function() {
  var Popover = {}

  Popover.init = function() {
    $('[data-toggle="popover"]').popover({
      trigger: 'hover'
    })
  }

  return Popover
})()
