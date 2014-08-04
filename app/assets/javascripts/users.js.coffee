# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# The show hide of the login signup

window.Predicta = 
  defineToggling : () ->
    $(".toggleSignup").click () =>
      $("#signup").toggle "fast", () =>

      $("#login").toggle "fast", () =>

      return false

