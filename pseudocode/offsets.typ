#import "@preview/lovelace:0.3.0": *


#pseudocode-list(booktabs: true, numbered-title: [Find all offsets])[
  + *input* $Phi, S$
  + *list* offsets
  + *if* $S$ is odd
    + $S = s-1$
    + *append* 0 *to list* offsets
  + *while* $i <= S/2$
    + *append* $+(i dot Phi)$ *to list* offsets
    + *append* $- (i dot Phi)$ *to list* offsets
  + *sort list* offsets in ascending order
  + *return* offsets
  + *end*
  ]
