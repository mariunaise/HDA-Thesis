#import "@preview/lovelace:0.3.0": *

#pseudocode-list(booktabs: true, numbered-title: [OptimalWeights to approximate $bold(cal(o))$])[
  + *inputs*:
    + $bold(y)$ input values for linear combinations
    + $bold(cal(o))$ list of optimal points
  + *output*: $(bold(h), z_"opt")$
    //+ n number of summands in linear combination
  + *calculate* all possible linear combinations $bold(z)$ with @eq:z_eq
  + *calculate* matrix $bold(cal(A))$ with $a_"ij" = abs(z_i - cal(o)_j)$
  + *return* weights $bold(h)$ for $z_"opt" = op("argmin")(bold(cal(A)))$ and $z_"opt"$
]
