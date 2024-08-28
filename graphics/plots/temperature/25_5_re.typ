#import "@preview/cetz:0.2.2": canvas, plot

#let data5 = csv("../../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_5.csv")
#let ndata5 = data5.map(value => value.map(v => calc.log(float(v))))// fucking hell is that cursed

#let data25 = csv("../../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_25.csv")
#let ndata25 = data25.map(value => value.map(v => calc.log(float(v))))

#let data35 = csv("../../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_35.csv")
#let ndata35 = data35.map(value => value.map(v => calc.log(float(v))))

#let data55 = csv("../../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_55.csv")
#let ndata55 = data55.map(value => value.map(v => calc.log(float(v))))

#let data15 = csv("../../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_15.csv")
#let ndata15 = data15.map(value => value.map(v => calc.log(float(v))))

#let data45 = csv("../../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_45.csv")
#let ndata45 = data45.map(value => value.map(v => calc.log(float(v))))

#let formatter(v) = [$10^#v$]


#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (10,5),
    x-tick-step: none,
    x-ticks: ((0.04, [2]),(2, [100])),
    y-label: $op("BER")(S, 2^2)$,
    x-label: $S$,
    y-tick-step: 1,
    x-max: 2,
    //y-ticks : (
    //  (-1.5, calc.exp(-1.5)),
    //),
    y-max: -1,
    y-format: formatter,
    axis-style: "left",
    {
    plot.add((ndata5), line: "spline", label: $5°C$)
    plot.add((ndata25), line: "spline", label: $25°C$)
    plot.add((ndata15), line: "spline", label: $15°C$)
    plot.add((ndata35), line: "spline", label: $35°C$)
    plot.add((ndata45), line: "spline", label: $45°C$)
    plot.add((ndata55), line: "spline", label: $55°C$, style: (stroke: (paint: teal)))
  })
})
