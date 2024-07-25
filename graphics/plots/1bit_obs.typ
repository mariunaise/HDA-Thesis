#import "@preview/cetz:0.2.2": canvas, plot

#let data = csv("../../data/1bit.csv")
#let ndata = data.map(value => value.map(v => float(v)))// fucking hell is that cursed

#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (10,1),
    x-tick-step: none,
    x-ticks: ((1, [1]), (2, [2]), (3, [3]), (4, [4]), (5, [5]), (6, [6])),
    y-label: $E(1)$,
    x-label: $m$,
    y-tick-step: 500,
    axis-style: "left",
    x-min: 0,
    y-max: 1,
    {
    plot.add((ndata), mark: "o", mark-size: 0.0001)
  })
})
