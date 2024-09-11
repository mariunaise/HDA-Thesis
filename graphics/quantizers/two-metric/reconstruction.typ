#import "@preview/cetz:0.2.2": canvas, plot

#let line_style_aqua = (stroke: (paint: red, thickness: 2pt))
#let line_style_eastern = (stroke: (paint: blue, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#let fill_aqua = (stroke: none, fill: red)
#let fill_olive = (stroke: none, fill: green)
#canvas({
  plot.plot(size: (7,3),
    legend: "legend.south",
    legend-style: (orientation: ltr, item: (spacing: 0.5)),
    x-tick-step: none,
    x-ticks: ((-1.25, [-a]), (1.25, [a]), (0, [0]), (-2.125, [-T1]), (2.125, [T1]), (0.375, [T2]), (-0.375, [-T2])),
    y-label: $cal(R)(1, 2, x)$,
    x-label: $x$,
    y-tick-step: none,
    y-ticks: ((0, [0]), (1, [1])),
    axis-style: "left",
    x-min: -3,
    x-max: 3,
    y-min: 0,
    y-max: 1,{
    plot.add(((-3,0), (-2.125,0), (-2.125,1), (0.375,1), (0.375, 0), (3, 0)), line: "vh", style: line_style_aqua, label: [Metric 1])
    plot.add(((-3, 0), (-0.375, 0), (-0.375, 1), (2.125, 1), (2.125, 0), (3, 0)), line: "vh", style: line_style_eastern, label: [Metric 2])
    //plot.add-fill-between(((1.25, 0), (3, 0)), ((1.25, 1), (3, 1)), style: fill_olive)
    plot.add-hline(1, style: dashed)
  })
})
