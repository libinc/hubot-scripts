# system = require('system')
# page   = require('webpage').create()
# page.injectJs '../node_modules/chart.js/Chart.min.js'
#
# ## Args
# filename = system.args[1]
# width    = system.args[2]
# height   = system.args[3]
# type     = system.args[4]
# data     = system.args[5]
#
# page.evaluate (width, height, type, data) ->
#   canvas = document.createElement('canvas')
#   canvas.width  = width
#   canvas.height = height
#   document.body.appendChild(canvas)
#
#   options =
#     scaleLineWidth: 5
#     onAnimationComplete: () ->
#       window.callPhantom(clipRect: canvas.getBoundingClientRect())
#
#   chart = new Chart(canvas.getContext('2d'))
#
#   switch type
#     when 'line'     then chart.Line(data, options)
#     when 'bar'      then chart.Bar(data, options)
#     when 'radar'    then chart.Radar(data, options)
#     when 'polar'    then chart.PolarArea(data, options)
#     when 'pie'      then chart.Pie(data, options)
#     when 'doughnut' then chart.Doughnut(data, options)
#     else throw new Error('Invalid chart type.')
# , width, height, type, JSON.parse(data)
#
# page.onCallback = (data) ->
#   page.clipRect = data.clipRect
#   page.render(filename)
#   phantom.exit()
#
# page.onError = (message, trace) ->
#   phantom.exit(1)
