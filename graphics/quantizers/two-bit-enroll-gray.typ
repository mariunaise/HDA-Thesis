#import "@preview/cetz:0.2.2": canvas, plot

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,6),
    x-tick-step: 0.25,
    y-label: $cal(Q)(2, 1, tilde(x))$,
    x-label: $tilde(x)$,
    y-tick-step: none,
    y-ticks: ((0.25, [00]), (0.5, [01]), (0.75, [11]), (1, [10])),
    axis-style: "left",
    x-min: 0,
    x-max: 1,
    y-min: 0,
    y-max: 1,{
    plot.add(((0,0), (0.25,0.25), (0.5,0.5), (0.75,0.75), (1, 1)), line: "vh", style: line_style)
    plot.add-hline(0.25, 0.5, 0.75, 1, style: dashed)
    plot.add-vline(0.25, 0.5, 0.75, 1, style: dashed)
  })
})
