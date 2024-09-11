#import "@preview/cetz:0.2.2": *

#set page(width: 70em)

#let ymax = 1/calc.sqrt(2*calc.pi)

#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))

#grid(
  columns: (1fr, 0.1fr, 1fr),
  [#canvas({
    plot.plot(size: (8,4),
      legend: "legend.north",
      legend-style: (orientation: ltr, item: (spacing: 0.5)),
      x-tick-step: none,
      x-ticks: ((0, [0]), (100, [0])),
      y-label: $f_X (x)$,
      x-label: $x$,
      y-tick-step: none,
      //y-ticks: ((0, [0]), (ymax, [1])),
      axis-style: "left",
      x-min: -3,
      x-max: 3,
      y-min: 0,
      y-max: 1,{
      plot.add(
        plot.sample-fn(
          (x) => 1/calc.sqrt(2*calc.pi)*calc.exp(-(calc.pow(x,2)/2)),
          (-3, 3),
          300),
        style: (stroke: (paint: red, thickness: 2pt)),
        label: [PDF of a normal distribution]
      )
    })
  })],
  [#align(center)[#align(horizon)[#text(25pt)[$arrow.r.double$]]]],
  [#canvas({
    plot.plot(size: (8,4),
      legend: "legend.north",
      legend-style: (orientation: ltr, item: (spacing: 0.5)),
      x-tick-step: 1,
      //x-ticks: ((0, [0]), (100, [0])),
      y-label: $f_tilde(X) (tilde(x))$,
      x-label: $tilde(x)$,
      y-tick-step: none,
      //y-ticks: ((0, [0]), (ymax, [1])),
      axis-style: "left",
      x-min: 0,
      x-max: 1,
      y-min: 0,
      y-max: 1,{
      plot.add(((-0,0.5), (1,0.5)), style: (stroke: (paint: red, thickness: 2pt)), label: [PDF of a uniform distribution])
    })
  })
])
