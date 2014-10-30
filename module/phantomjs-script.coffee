page = require('webpage').create()
page.injectJs '../node_modules/chart.js/Chart.min.js'

## Args
filename = "chartjs"
#type = 'pie'
type = 'line'
#data = [
#  { value: 30 ,color: "#F38630" }
#  { value: 40 ,color: "#E0E4CC" }
#  { value: 10 ,color: "#E4CCE0" }
#  { value: 15 ,color: "#69D2E7" }
#  { value:  5 ,color: "#E7D7D2" }
#]
data =
  labels: ["January", "February", "March", "April", "May", "June", "July"]
  datasets: [
    { fillColor: "rgba(220,220,220,0.5)", strokeColor: "rgba(220,220,220,1)", data: [65, 59, 90, 81, 56, 55, 40] }
    { fillColor: "rgba(151,187,205,0.5)", strokeColor: "rgba(151,187,205,1)", data: [28, 48, 40, 19, 96, 27, 100] }
  ]

page.evaluate (type, data) ->
  canvas = document.createElement('canvas')
  document.body.appendChild(canvas)

  options =
    scaleLineWidth: 5
    onAnimationComplete: () ->
      window.callPhantom(clipRect: canvas.getBoundingClientRect())

  chart = new Chart(canvas.getContext('2d'))

  switch type
    when 'line'     then chart.Line(data, options)
    when 'bar'      then chart.Bar(data, options)
    when 'radar'    then chart.Radar(data, options)
    when 'polar'    then chart.PolarArea(data, options)
    when 'pie'      then chart.Pie(data, options)
    when 'doughnut' then chart.Doughnut(data, options)
    else throw new Error('Invalid chart type.')
, type, data

page.onCallback = (data) ->
  page.clipRect = data.clipRect
  page.render("#{filename}.png")
  phantom.exit()

page.onError = (message, trace) ->
  phantom.exit(1)
