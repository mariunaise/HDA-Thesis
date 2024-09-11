#import "@preview/cetz:0.2.2": canvas, plot

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#let fill_aqua = (stroke: none, fill: red)
#let fill_olive = (stroke: none, fill: blue)
#canvas({
  plot.plot(size: (7,3),
    legend: "legend.south",
    legend-style: (orientation: ltr, item: (spacing: 0.5)),
    x-tick-step: none,
    x-ticks: ((-1.25, [-a]), (1.25, [a]), (0, [0])),
    y-label: $cal(E)(1, 2, x)$,
    x-label: $x$,
    y-tick-step: none,
    y-ticks: ((0, [0]), (1, [1])),
    axis-style: "left",
    x-min: -3,
    x-max: 3,
    y-min: 0,
    y-max: 1,{
    plot.add(((-3,0), (-1.25,0), (-1.25,1), (1.25,1), (1.25, 0), (3, 0)), line: "vh", style: line_style)
    plot.add-fill-between(((-3, 0), (-1.25, 0)), ((-3, 1), (-1.25, 1)), style: fill_aqua, label: [Use metric 1])
    plot.add-fill-between(((-1.25, 0), (0, 0)), ((-1.25, 1), (0, 1)), style: fill_olive,
    label: [Use metric 2])
    plot.add-fill-between(((0, 0), (1.25, 0)), ((0, 1), (1.25, 1)), style: fill_aqua)
    plot.add-fill-between(((1.25, 0), (3, 0)), ((1.25, 1), (3, 1)), style: fill_olive)
    plot.add-hline(1, style: dashed)
  })
})
