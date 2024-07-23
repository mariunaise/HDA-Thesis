#import "@preview/lovelace:0.3.0": *


#pseudocode-list(booktabs: true, numbered-title: [Find all offsets])[
  + *list* offsets
  + *if* $s$ is odd
    + $s = s-1$
    + *append* 0 *to list* offsets
  + *while* $i <= s/2$
    + *append* $+(i dot phi)$ *to list* offsets
    + *append* $- (i dot phi)$ *to list* offsets
  + *sort list* offsets in ascending order
  + *end*
  ]
