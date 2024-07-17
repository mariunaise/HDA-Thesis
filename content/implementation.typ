#import "@preview/lovelace:0.3.0": pseudocode-list

= Implementation
== Visualisation
Initially, a visualisation of the diff algorithms applied to quantum circuits was created to assess their usefulness in equivalence checking.
Additionally, this served as exercise to better understand the algorithms to be used for the implementation in @qcec.


== QCEC Application Scheme
The Myers' Algorithm was implemented as an application scheme in @qcec.

#figure(
  block(
    pseudocode-list[
      + do something
      + do something else
      + *while* still something to do
        + do even more
        + *if* not done yet *then*
          + wait a bit
          + resume working
        + *else*
          + go home
        + *end*
      + *end*
    ],
    width: 100%
  ),
  caption: [Myers' algorithm.]
) <myers_algorithm>



== QCEC Benchmarking Tool
As @qcec doesn’t have built-in benchmarks, a benchmarking tool was developed to test different configurations on various circuit pairs.

