#import "@preview/cetz:0.2.2": canvas, plot, draw

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,6), name: "plot",
    x-tick-step: none,
    x-ticks: ((3/16, [3/16]), (7/16, [7/16]), (11/16, [11/16]), (15/16, [15/16])),
    y-label: $cal(Q)_("m1")(2, 2, tilde(x))$,
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

    plot.add-anchor("q00", (1/16, 2/8))
    plot.add-anchor("h00", (1/16, 0))
    plot.add-anchor("q01", (5/16, 4/8))
    plot.add-anchor("h01", (5/16, 0))
    plot.add-anchor("q10", (9/16, 6/8))
    plot.add-anchor("h10", (9/16, 0))
    plot.add-anchor("q11", (13/16, 8/8))
    plot.add-anchor("h11", (13/16, 0))
  })

  draw.line("plot.q00", ((), "|-", "plot.h00"), mark: (end: ">"))
  draw.line("plot.q01", ((), "|-", "plot.h01"), mark: (end: ">"))
  draw.line("plot.q10", ((), "|-", "plot.h10"), mark: (end: ">"))
  draw.line("plot.q11", ((), "|-", "plot.h11"), mark: (end: ">"))
})
