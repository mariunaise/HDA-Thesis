#import "@preview/lovelace:0.3.0": *


#pseudocode-list(booktabs: true, numbered-title: [Center Point Approximation])[
  + *input*: $bold(cal(o))_"first", bold(x), t, M$
  + *lists*: optimal weights $bold(h)_"opt"$
  + $bold(cal(o)) arrow.l bold(cal(o))_"first"$
  + *repeat* t times: 
    + *perform* @alg:best_appr for all input values with $bold(cal(o))$:
      + *update* $bold(h)_"opt"$ with returned weights
      + $bold(z)_"opt" arrow.l$ all returned linear combinations 
    + *sort* $bold(z)_"opt"$ in ascending order
    + *define* new quantizer $cal(Q)^*$ using the @ecdf based on $bold(z)_"opt"$
    + *update* $bold(cal(o))$ with newly found quantizer step centers
  + *return* $bold(h)_"opt"$ 
]
