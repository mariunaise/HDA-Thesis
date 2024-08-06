#import "@preview/cetz:0.2.2"

#let data = csv("./sorted_configurations_with_diff.csv")

#let errorrate = data.enumerate().map(
  row => (row.at(0),calc.log(float(row.at(1).at(1))))
)
#let diff = data.enumerate().map(
  row => (row.at(0),float(row.at(1).at(2)))
)

#let conf = data.enumerate().map(
  row => (row.at(0), row.at(1).at(0))
)

#let formatter(v) = [$10^#v$]


#cetz.canvas({
  import cetz.draw: *
  import cetz.plot

  set-style(
    axes: (bottom: (tick: (label: (angle: 90deg, offset: 0.5))))
  )

  plot.plot(
    y-label: $"Bit error rate"$,
    x-label: "Operating configuration",
    x-tick-step: none,
    x-ticks: conf,
    y-format: formatter,
    y-tick-step: 0.5,
    axis-style: "scientific-auto",
    size: (16,6),
    plot.add(errorrate, axes: ("x", "y"), style: (stroke: (paint: red))),
    plot.add-hline(1)
  )

  plot.plot(
    y2-label: "Temperature difference",
    y2-tick-step: 10,
    axis-style: "scientific-auto",
    size: (16,6),
    plot.add(diff, axes: ("x1","y2")),
  )
})
