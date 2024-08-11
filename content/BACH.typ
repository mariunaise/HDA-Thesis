#import "@preview/glossarium:0.4.1": * 

= Boundary Adaptive Clustering with Helper Data

Instead of generating helper-data to improve the quantization process itself, like in #gls("smhdt"), we can also try to find helper-data before performing enrollment that will optimize our input values before the quantization step to minimize the risk of bit and symbol errors during the reconstruction phase. 

Since this #gls("hda") modifies the input values before the quantization takes place, we will consider the input values as zero-mean Gaussian distributed and not use a CDF to transform these values into the tilde-domain.

== Optimizing a 1-bit sign-based quantization

Before we take a look at the higher order quantization cases, we will start with a very basic method of quantization: a quantizer, that only returns a symbol with a width of $1$ bit and uses the sign of the input value to determine the resulting bit symbol.

#figure(
  include("./../graphics/quantizers/bach/sign-based-overlay.typ"),
  caption: [1-bit quantizer with the PDF of a normal distribution]
)<fig:1-bit_normal>

If we overlay the PDF of a zero-mean Gaussian distributed variable $X$ with a sign-based quantizer function as shown in @fig:1-bit_normal, we can see that the expected value of the Gaussian distribution overlaps with the decision threshold of the sign-based quantizer.
Considering that the margin of error of the value $x$ is comparable with the one shown in @fig:tmhd_example_enroll, we can conclude that values of $X$ that reside near $0$ are to be considered more unreliable than values that are further away from the x-value 0.
This means that the quantizer used here is very unreliable without generated helper-data.

Now, to increase the reliability of this quantizer, we can try to move our input values further away from the value $x = 0$. 
To do so, we can define a new input value $x^"lin"$ as a linear combination of two realizations of $X$, $x_1$ and $x_2$ with a set of weights $h_1$ and $h_2$: 
$
x^"lin" = h_1 dot x_1 + h_2 dot x_2 .
$<eq:lin_combs>
We can define the vector of all possible linear combinations $bold(x^"lin")$ as the vector-matrix multiplication of the two input values $x_i$ and the matrix of all weight combinations: 
$
bold(x^"lin") &= vec(x_1, x_2) dot mat(delim: "[", h_1, -h_1, h_1, -h_1; h_2, h_2, -h_2, -h_2)\
&= vec(x_1, x_2) dot mat(delim: "[", +1, -1, +1, -1; +1, +1, -1, -1)
$
We will choose the optimal weights based on the highest absolute value of $bold(x^"lin")$, as that value will be the furthest away from $0$. 
We may encounter two entries in $bold(x^"lin")$ that both have the same highest absolute value.

Lets take a look at the resulting random distribution of this process: 

