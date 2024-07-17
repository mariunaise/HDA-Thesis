#import "@preview/fletcher:0.5.1": diagram, node, edge
#import "@preview/gentle-clues:0.9.0": example
#import "@preview/quill:0.3.0": quantum-circuit, lstick, rstick, ctrl, targ, mqgate, meter


= Background
== Quantum Computation and Quantum Circuits
A quantum computer is a device that performs calculations by using certain phenomena of quantum mechanics.
The algorithms that run on this device are specified in quantum circuits. 

#example[
  @example_qc shows a simple quantum circuit that implements a specific quantum algorithm.

  #figure(
    quantum-circuit(
      lstick($|0〉$), $H$, mqgate($U$, n: 2, width: 5em, inputs: ((qubit: 0, label: $x$), (qubit: 1, label: $y$)), outputs: ((qubit: 0, label: $x$), (qubit: 1, label: $y plus.circle f(x)$))), $H$, meter(), [\ ],
      lstick($|1〉$), $H$, 1, 1, 1
    ),
    caption: [A quantum circuit implementing the Deutsch-Jozsa algorithm]
  ) <example_qc>
]


== Decision Diagrams
Decision diagrams in general are directed acyclical graphs, that may be used to express control flow through a series of conditions.
It consists of a set of decision nodes and terminal nodes.
The decision nodes represent an arbitrary decision based on an input value and may thus have any number of outgoing edges.
The terminal nodes represent output values and may not have outgoing edges.

A @bdd is a specific kind of decision diagram, where there are two terminal nodes (0 and 1) and each decision node has two outgoing edges, depending solely on a single bit of an input value.
@bdd[s] may be used to represent any boolean function.

#example[
  Example @bdd[s] implementing boolean functions with an arity of $2$ are show in @example_bdd_xor and @example_bdd_and.

  #figure(
    diagram(
      node-stroke: .1em,
      node((0, 0), [$x_0$], radius: 1em),
      edge((0, 0), (-1, 1), [0], "->"),
      edge((0, 0), (1, 1), [1], "->"),
      node((-1, 1), [$x_1$], radius: 1em),
      node((1, 1), [$x_1$], radius: 1em),
      edge((-1, 1), (-1, 2), [0], "->"),
      edge((-1, 1), (1, 2), [1], "->"),
      edge((1, 1), (1, 2), [0], "->"),
      edge((1, 1), (-1, 2), [1], "->"),
      node((-1, 2), [$0$]),
      node((1, 2), [$1$]),
    ),
    caption: [A @bdd for an XOR gate.]
  ) <example_bdd_xor>

  #figure(
    diagram(
      node-stroke: .1em,
      node((1, 0), [$x_0$], radius: 1em),
      edge((1, 0), (0, 2), [0], "->"),
      edge((1, 0), (1, 1), [1], "->"),
      node((1, 1), [$x_1$], radius: 1em),
      edge((1, 1), (0, 2), [0], "->"),
      edge((1, 1), (1, 2), [1], "->"),
      node((0, 2), [$0$]),
      node((1, 2), [$1$]),
    ),
    caption: [A @bdd for an AND gate.]
  ) <example_bdd_and>
]


