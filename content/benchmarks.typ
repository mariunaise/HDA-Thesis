#import "@preview/tablex:0.0.8": tablex
#import "@preview/unify:0.6.0": qty

= Benchmarks
== Google Benchmark

== MQT QCEC Bench
To generate test cases for the application schemes, @mqt Bench was used. @quetschlich2023mqtbench

#tablex(
  columns: (1fr, 1fr, 1fr),
  rows: (auto, auto, auto),
  [*Benchmark Name*], [*Diff Run Time*], [*Proportional Run Time*],
  [DJ], [$qty("1.2e-6", "s")$], [$qty("1.5e-6", "s")$],
  [Grover], [$qty("1.3e-3", "s")$], [$qty("1.7e-3", "s")$]
)
