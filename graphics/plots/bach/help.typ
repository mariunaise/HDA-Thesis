#import "@preview/cetz:0.2.2": canvas, plot

#let data2 = csv("../../../data/errorrates/bach/errorrates2.csv")
#let ndata2 = data2.map(value => value.map(v => calc.log(float(v))))// fucking hell is that cursed

#let data4 = csv("../../../data/errorrates/bach/errorrates4.csv")
#let ndata4 = data4.map(value => value.map(v => calc.log(float(v))))

#let formatter(v) = [$10^#v$]


#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (10,5),
    x-tick-step: none,
    ////x-ticks: ((0.04, [2]),(2, [100])),
    y-label: $"Bit error rate"$,
    x-label: $s$,
    y-tick-step: none,
    x-max: 1,
    //y-ticks : (
    //  (-1.5, calc.exp(-1.5)),
    //),
    y-max: 1,
    y-format: formatter,
    axis-style: "left",
    {
    plot.add((ndata2), line: "spline", label: [2-bit BER])
    plot.add((ndata4), line: "spline", label: [4-bit BER])
  })
})
