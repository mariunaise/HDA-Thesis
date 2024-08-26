#import "@preview/cetz:0.2.2": canvas, plot, draw, decorations, vector

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  import draw: *
  set-style(axes: (shared-zero: false))
  plot.plot(size: (8,6),
    x-tick-step: 0.25,
    y-label: $cal(E)(3, 2, tilde(x))$,
    x-label: $tilde(x)$,
    y-tick-step: none,
    y-ticks: ((1/12, [M1]) ,(2/12, [M2]),(3/12, [M3]) ,(4/12, [M1]),(5/12, [M2]) ,(6/12, [M3]),(7/12, [M1]) ,(8/12, [M2]), (9/12, [M3]), (10/12, [M1]), (11/12, [M2]), (1, [M3])),
    axis-style: "left",
    x-min: 0,
    x-max: 1,
    y-min: 0,
    y-max: 1,{
    plot.add(((0,0), (1/12, 1/12), (2/12,2/12), (3/12, 3/12),(4/12,4/12), (5/12, 5/12),(6/12,6/12), (7/12, 7/12),(8/12, 8/12), (9/12, 9/12), (10/12, 10/12), (11/12, 11/12), (1, 1)), line: "vh", style: line_style)
    plot.add-hline(1/12, 2/12, 3/12, 4/12, 5/12, 6/12, 7/12, 8/12, 9/12, 10/12, 11/12, 1, style: dashed)
    plot.add-vline(0.25, 0.5, 0.75, 1, style: dashed)
  })
  decorations.brace((-0.9,0.4), (-0.9,1.63), name: "00")
  decorations.brace((-0.9,1.9), (-0.9,3.13), name: "01")
  decorations.brace((-0.9,3.4), (-0.9,4.63), name: "10")
  decorations.brace((-0.9,4.9), (-0.9,6.13), name: "11")

  draw.content((v => vector.add(v, (-0.3, 0)), "00.west"), [00])
  draw.content((v => vector.add(v, (-0.3, 0)), "01.west"), [01])
  draw.content((v => vector.add(v, (-0.3, 0)), "10.west"), [10])
  draw.content((v => vector.add(v, (-0.3, 0)), "11.west"), [11])
})
