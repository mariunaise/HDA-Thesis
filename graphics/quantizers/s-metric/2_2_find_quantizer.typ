#import "@preview/cetz:0.2.2": canvas, plot, draw, decorations, vector

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#let dashed2 = (stroke: (dash: "dotted"))
#let markings = (stroke: (paint: red, thickness: 2pt), fill: red)
#canvas({
  plot.plot(size: (8,6), name: "plot",
    x-tick-step: none,
    x-ticks: ((1/4, [0.25]), (2/4, [0.5]), (3/4, [0.75]), (1, [1])),
    y-label: $cal(E)(2, 2, tilde(x))$,
    x-label: $tilde(x)$,
    y-tick-step: none,
    y-ticks: ((0.125, [M1]) ,(0.25, [M2]),(0.375, [M1]) ,(0.5, [M2]),(0.625, [M1]) ,(0.75, [M2]),(0.875, [M1]) ,(1, [M2])),
    axis-style: "left",
    x-min: 0,
    x-max: 1,
    y-min: 0,
    y-max: 1,{
    plot.add(((0,0), (0.125, 0.125), (0.25,0.25), (0.375, 0.375),(0.5,0.5), (0.625, 0.625),(0.75,0.75), (0.875, 0.875),(1, 1)), line: "vh", style: line_style)
    plot.add-hline(0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1, style: dashed)
    plot.add-vline(1/4, 2/4, 3/4, 4/4, style: dashed2)
    plot.add-anchor("q00", (1/16, 1/8))
    plot.add-anchor("h00", (1/16, 0))
    plot.add-anchor("q01", (5/16, 3/8))
    plot.add-anchor("h01", (5/16, 0))
    plot.add-anchor("q10", (9/16, 5/8))
    plot.add-anchor("h10", (9/16, 0))
    plot.add-anchor("q11", (13/16, 7/8))
    plot.add-anchor("h11", (13/16, 0))
  })
  decorations.brace((-0.9,0.63), (-0.9,1.63), name: "00")
  decorations.brace((-0.9,2.13), (-0.9,3.13), name: "01")
  decorations.brace((-0.9,3.63), (-0.9,4.63), name: "10")
  decorations.brace((-0.9,5.13), (-0.9,6.13), name: "11")

  draw.content((v => vector.add(v, (-0.3, 0)), "00.west"), [00])
  draw.content((v => vector.add(v, (-0.3, 0)), "01.west"), [01])
  draw.content((v => vector.add(v, (-0.3, 0)), "10.west"), [10])
  draw.content((v => vector.add(v, (-0.3, 0)), "11.west"), [11])

  draw.line("plot.q00", ((), "|-", "plot.h00"), mark: (end: ">"))
  draw.line("plot.q01", ((), "|-", "plot.h01"), mark: (end: ">"))
  draw.line("plot.q10", ((), "|-", "plot.h10"), mark: (end: ">"))
  draw.line("plot.q11", ((), "|-", "plot.h11"), mark: (end: ">"))
})
