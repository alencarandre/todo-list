(function() {
  $(document).on("click", "#close_form_list", function(ev) {
    ev.stopPropagation()

    var form = $(ev.target).closest("form")

    form.fadeOut(function() {
      form.remove()
    })

    return false;
  })

  $(document).on("click", "#close_form_task", function(ev) {
    ev.stopPropagation()

    var form = $(ev.target).closest("form")

    form.fadeOut(function() {
      var li_task = $(form.closest("li"))

      li_task.find("*").show()
      li_task.find("div#form").hide()

      form.remove()
    })

    return false;
  })
})()
