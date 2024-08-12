#import "@preview/cetz:0.2.2": *

#let data = csv("../../data/z_distribution/z_distribution.csv")
#let data = data.map(value => value.map(v => float(v)))

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,3),
    legend : "legend.south",
    legend-style: (orientation: ltr, item: (spacing: 0.5)),
    x-tick-step: none,
    x-ticks: ((0, [0]), (100, [0])),
    y-label: $cal(Q)(1, z), abs(f_"Z" (z))$,
    x-label: $z$,
    y-tick-step: none,
    y-ticks: ((0, [0]), (0.6, [1])),
    axis-style: "left",
    x-min: -5,
    x-max: 5,
    y-min: 0,
    y-max: 0.6,{
    plot.add((data), style: (stroke: (paint: red, thickness: 2pt)), label: [Optimized PDF])
    plot.add(((-5, 0), (0, 0), (0, 0.6), (5, 0.6)), style: line_style, label: [Quantizer])
  })
})
