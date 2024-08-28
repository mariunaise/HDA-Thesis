#import "@preview/cetz:0.2.2": *

#let ymax = 1/calc.sqrt(2*calc.pi)

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,4),
    legend: "legend.north",
    legend-style: (orientation: ltr, item: (spacing: 0.5)),
    x-tick-step: none,
    x-ticks: ((0, [0]), (100, [0])),
    y-label: $cal(Q)(1, x)$,
    x-label: $x$,
    y-tick-step: none,
    y-ticks: ((0, [0]), (ymax, [1])),
    axis-style: "left",
    x-min: -3,
    x-max: 3,
    y-min: 0,
    y-max: ymax,{
    plot.add(
      plot.sample-fn(
        (x) => 1/calc.sqrt(2*calc.pi)*calc.exp(-(calc.pow(x,2)/2)),
        (-3, 3),
        300),
      style: (stroke: (paint: red, thickness: 2pt)),
      label: [PDF of a normal distribution]
    )
    plot.add(((-3,0), (0,0), (0,ymax), (3,ymax)), style: line_style, label: [$cal(Q)(1,x)$])
  })
})
