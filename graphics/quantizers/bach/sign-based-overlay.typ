#import "@preview/cetz:0.2.2": *



#let line_style = (stroke: (paint: black, thickness: 2pt))
#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (8,4),
    x-tick-step: none,
    x-ticks: ((0, [0]), (100, [0])),
    y-label: $cal(Q)(1, x)$,
    x-label: $x$,
    y-tick-step: 1,
    axis-style: "left",
    x-min: -3,
    x-max: 3,
    y-min: 0,
    y-max: 1,{
    plot.add(((-3,0), (0,0), (0,1), (3,1)), style: line_style)
    plot.add(plot.sample-fn(
  (x) => 1/calc.sqrt(2*calc.pi)*calc.exp(-(calc.pow(x,2)/2)),
  (-3, 3),
  300 
))
    
  })
})
