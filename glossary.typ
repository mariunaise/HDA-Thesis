#import "@preview/glossarium:0.4.1": print-glossary

#counter(heading).update(0)
#heading(numbering: none)[Glossary]

#print-glossary((
  (key: "bdd", short: "BDD", plural: "BDDs", long: "binary decision diagram", longplural: "binary decision diagrams"),
  (key: "dd", short: "DD", plural: "DDs", long: "decision diagram", longplural: "decision diagrams"),
  (key: "mqt", short: "MQT", long: "Munich Quantum Toolkit"),
  (key: "qcec", short: "QCEC", long: "Quantum Circuit Equivalence Checker"),
))
