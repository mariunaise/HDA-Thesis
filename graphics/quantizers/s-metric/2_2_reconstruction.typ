#import "@preview/cetz:0.2.2": canvas, plot

#let line_style = (stroke: (paint: red, thickness: 2pt))
#let line_style2 = (stroke: (paint: blue, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,6),
    legend: "legend.south",
    legend-style: (orientation: ltr, item: (spacing: 0.5)),
    x-tick-step: 1/4,
    //x-ticks: ((3/16, [3/16]), (7/16, [7/16]), (11/16, [11/16]), (15/16, [15/16])),
    y-label: $cal(R)(2, 2, tilde(x))$,
    x-label: $tilde(x)$,
    y-tick-step: none,
    y-ticks: ((3/16, [00]), (7/16, [01]), (11/16, [10]), (15/16, [11])),
    axis-style: "left",
    x-min: 0,
    x-max: 1,
    y-min: 0,
    y-max: 1,{
    plot.add(((0,3/16), (3/16,3/16), (7/16,7/16), (11/16,11/16), (15/16, 15/16), (15/16, 3/16), (1, 3/16)), line: "vh", style: line_style, label: [Metric 1])
    plot.add(((0, 15/16), (1/16, 15/16), (1/16, 3/16), (5/16, 3/16), (9/16, 7/16), (13/16, 11/16), (13/16, 15/16), (1, 15/16)),line: "vh", style: line_style2, label: [Metric 2])
    plot.add-hline(3/16, 7/16, 11/16, 15/16, style: dashed)
    plot.add-vline(3/16, 7/16, 11/16, 15/16, style: dashed)
  })
})
