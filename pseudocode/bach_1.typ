#import "@preview/lovelace:0.3.0": *


#pseudocode-list(booktabs: true, numbered-title: [Center Point Approximation])[
  + *input*: $bold(cal(o))_"first", bold(x), t, M$
  + *lists*: optimal weights $bold(h)_"opt"$
  + $bold(cal(o)) arrow.l bold(cal(o))_"first"$
  + #line-label(<alg:bach_1_1>) *repeat* t times: 
    + *perform* #smallcaps[OptimalWeights($bold(cal(0)), bold(x))$]:
      + #line-label(<alg:bach_1_2>) *update* $bold(h)_"opt"$ with returned weights
      + $bold(z)_"opt" arrow.l$ all returned linear combinations 
    + *define* new quantizer $cal(Q)^*$ using the @ecdf based on $bold(z)_"opt"$:
      + *sort* $bold(z)_"opt"$ in ascending order
      + $cal(Q)^* arrow.l $ use @eq:ecdf_inverse with quantizer bounds in the tilde domain
    + #line-label(<alg:bach_1_3>)  *update* $bold(cal(o))$ with newly found quantizer step centers
  + *return* $bold(h)_"opt"$ 
]
