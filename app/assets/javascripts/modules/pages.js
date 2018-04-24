(function() {
  $(document).on("click", "[data-close='form']", function(ev) {
    ev.stopPropagation()

    var form = $(ev.target).closest("form")

    form.fadeOut(function() {
      form.remove()
    })

    return false;
  })
})()
