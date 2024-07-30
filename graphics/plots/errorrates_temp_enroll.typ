#import "@preview/cetz:0.2.2": canvas, plot

#let data25 = csv("../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_25.csv")
#let ndata25 = data25.map(value => value.map(v => float(v)))// fucking hell is that cursed

#let data5 = csv("../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_5.csv")
#let ndata5 = data5.map(value => value.map(v => float(v)))

#let data35 = csv("../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_35.csv")
#let ndata35 = data35.map(value => value.map(v => float(v)))

#let data55 = csv("../../data/errorrates/2bit_temp/reconstruction/errorrates_left_25_55.csv")
#let ndata55 = data55.map(value => value.map(v => float(v)))

#let dashed = (stroke: (dash: "dashed"))
#canvas({
  plot.plot(size: (10,1),
    x-tick-step: none,
    y-label: $E(1)$,
    x-label: $m$,
    y-tick-step: none,
    axis-style: "left",
    x-min: 0,
    {
    plot.add((ndata25), mark: "o", mark-size: 0.001)
    plot.add((ndata5), mark: "o", mark-size: 0.001)
    plot.add((ndata35), mark: "o", mark-size: 0.001)
    plot.add((ndata55), mark: "o", mark-size: 0.001)
  })
})
