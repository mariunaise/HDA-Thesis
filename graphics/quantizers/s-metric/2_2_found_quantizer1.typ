#import "@preview/cetz:0.2.2": canvas, plot

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,6),
    x-tick-step: none,
    x-ticks: ((3/16, [3/16]), (7/16, [7/16]), (11/16, [11/16]), (15/16, [15/16])),
    y-label: $cal(Q)(2, 1, tilde(x))$,
    x-label: $tilde(x)$,
    y-tick-step: none,
    y-ticks: ((3/16, [00]), (7/16, [01]), (11/16, [10]), (15/16, [11])),
    axis-style: "left",
    x-min: 0,
    x-max: 1,
    y-min: 0,
    y-max: 1,{
    plot.add(((0,3/16), (3/16,3/16), (7/16,7/16), (11/16,11/16), (15/16, 15/16), (15/16, 3/16), (1, 3/16)), line: "vh", style: line_style)
    plot.add-hline(3/16, 7/16, 11/16, 15/16, style: dashed)
    plot.add-vline(3/16, 7/16, 11/16, 15/16, style: dashed)
  })
})
