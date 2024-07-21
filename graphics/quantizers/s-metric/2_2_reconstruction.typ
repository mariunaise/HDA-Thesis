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
    y-ticks: ((1/4, [00]), (2/4, [01]), (3/4, [10]), (1, [11])),
    axis-style: "left",
    x-min: 0,
    x-max: 1,
    y-min: 0,
    y-max: 1,{
    plot.add(((0,1/4), (3/16,1/4), (7/16,2/4), (11/16,3/4), (15/16, 1), (15/16, 1/4), (1, 1/4)), line: "vh", style: line_style, label: [Metric 1])
    plot.add(((0, 1), (1/16, 1), (1/16, 1/4), (5/16, 1/4), (9/16, 2/4), (13/16, 3/4), (13/16, 1), (1, 1)),line: "vh", style: line_style2, label: [Metric 2])
    plot.add-hline(1/4, 2/4, 3/4, 1, style: dashed)
    plot.add-vline(1/4, 2/4, 3/4, 1, style: dashed)
  })
})
