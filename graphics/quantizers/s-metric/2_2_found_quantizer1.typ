#import "@preview/cetz:0.2.2": canvas, plot

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,6),
    x-tick-step: none,
    x-ticks: ((3/16, [3/16]), (7/16, [7/16]), (11/16, [11/16]), (15/16, [15/16])),
    y-label: $cal(Q)(2, 2, tilde(x))$,
    x-label: $tilde(x)$,
    y-tick-step: none,
    y-ticks: ((1/4, [00]), (2/4, [01]), (3/4, [10]), (4/4, [11])),
    axis-style: "left",
    x-min: 0,
    x-max: 1,
    y-min: 0,
    y-max: 1,{
    plot.add(((0,1/4), (3/16,1/4), (7/16,2/4), (11/16,3/4), (15/16, 4/4), (15/16, 1/4), (1, 1/4)), line: "vh", style: line_style)
    plot.add-hline(1/4, 2/4, 3/4, 1, style: dashed)
    plot.add-vline(3/16, 7/16, 11/16, 15/16, style: dashed)
  })
})
