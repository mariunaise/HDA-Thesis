#import "@preview/cetz:0.2.2": canvas, plot

#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (10,4),
    x-tick-step: none,
    x-ticks: ((1, [1]), (2, [2]), (3, [3]), (4, [4]), (5, [5]), (6, [6])),
    y-label: $frac(op("BER")(1, 2^M),op("BER")(100, 2^M))$,
    x-label: $2^M$,
    y-tick-step: 500,
    axis-style: "left",
    x-min: 0,
    {
    plot.add(((1,1815.2), (2,660), (3,46), (4,3.11), (5,1.33), (6,1.07)), mark: "o")
  })
})
