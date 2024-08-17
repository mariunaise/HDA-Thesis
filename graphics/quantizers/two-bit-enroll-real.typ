#import "@preview/cetz:0.2.2": canvas, plot, decorations, draw

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,6),
    legend: "legend.south",
    name: "plot",
    x-tick-step: 1,
   // x-ticks: ((-1.168, [-1.16]), (1.168, [1.16])),
    y-label: $cal(Q)(2, x)$,
    x-label: $x$,
    y-tick-step: none,
    y-ticks: ((0.25, [00]), (0.5, [01]), (0.75, [10]), (1, [11])),
    axis-style: "left",
    x-min: -3,
    x-max: 3,
    y-min: 0,
    y-max: 1,{
    plot.add(((-3,0.25), (-1.168,0.25), (-1.168,0.5), (0, 0.5), (0, 0.75), (1.168,0.75), (1.168, 1), (3, 1)), style: line_style)
    plot.add(((-2.657, 0), (-2.657, 1)), style: (stroke: (paint: red)), label: [Artificial quantizer bounds])
    plot.add(((2.657, 0), (2.657, 1)), style: (stroke: (paint: red)))
    plot.add-hline(0.25, 0.5, 0.75, 1, style: dashed)
    plot.add-vline(-1.168, 1.168, style: dashed)
    plot.add-anchor("uc01", (-0.584, 0.5))
    plot.add-anchor("lc01", (-0.584, 0))
    plot.add-anchor("uc10", (0.584, 0.75))
    plot.add-anchor("lc10", (0.584, 0))

    plot.add-anchor("uc00", (-1.9125, 0.25))
    plot.add-anchor("lc00", (-1.9125, 0))
    plot.add-anchor("uc11", (1.9125, 1))
    plot.add-anchor("lc11", (1.9125, 0))

  })

  draw.line("plot.uc01", ((), "|-", "plot.lc01"), mark: (end: ">"))
  draw.line("plot.uc10", ((), "|-", "plot.lc10"), mark: (end: ">"))
  draw.line("plot.uc00", ((), "|-", "plot.lc00"), mark: (end: ">"))
  draw.line("plot.uc11", ((), "|-", "plot.lc11"), mark: (end: ">"))


})
