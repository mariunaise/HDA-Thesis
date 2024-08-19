#import "@preview/glossarium:0.4.1": * 
= Introduction

These are the introducing words

== Notation

To ensure a consistent notation of functions and ideas, we will now introduce some required conventions 

Random distributed variables will be notated with a capital letter, i.e. $X$, its realization will be the corresponding lower case letter, $x$.

Vectors will be written in bold text: $bold(k)$ represents a vector of quantized symbols.
Matrices are denoted with a bold capital letter: $bold(M)$

We will call a quantized symbol $k$. $k$ consists of all possible binary symbols, i.e. $0, 01, 110$.

A quantizer will be defined as a function $cal(Q)(x, bold(a))$ that returns a quantized symbol $k$. 
We also define the following special quantizers for metric based HDAs: 
A quantizer used during the enrollment phase is defined by a calligraphic $cal(E)$.
For the reconstruction phase, a quantizer will be defined by a calligraphic $cal(R)$

@example-quantizer shows the curve of a 2-bit quantizer that receives $tilde(x)$ as input. In the case, that the value of $tilde(x)$ equals one of the four bounds, the quantized value is chosen randomly from the relevant bins.

#figure(
  include("../graphics/quantizers/two-bit-enroll.typ"),
  caption: [Example quantizer function]) <example-quantizer>

For the S-Metric Helper Data Method, we introduce a function

$ cal(Q)(S,M) , $<eq-1>

where $S$ determines the number of metrics and $M$ the bit width of the symbols.
The corresponding metric is defined through the lower case $s$, the bit symbol through the lower case $m$.

=== Tilde-Domain<tilde-domain>

AS also described in @smhd, we will use a CDF to transform the real PUF values into the Tilde-Domain
This transformation can be performed using the function $xi = tilde(x)$. The key property of this transformation is the resulting uniform distribution of $x$. 

Considering a normal distribution, the CDF is defined as 
$ xi(frac(x - mu, sigma)) = frac(1, 2)[1 + \e\rf(frac(x - mu, sigma sqrt(2)))] $

==== #gls("ecdf", display: "Empirical cumulative distribution function (eCDF)")

The @ecdf is constructed through sorting the empirical measurements of a distribution @dekking2005modern. Although less accurate, this method allows a more simple and less computationally complex way to transform real valued measurements into the Tilde-Domain. We will mainly use the eCDF in @chap:smhd because of the difficulty of finding an analytical description for the CDF of a Gaussian-Mixture.\
To apply it, we will sort the vector of realizations $bold(z)$ of a random distributed variable $Z$ in ascending order. 
The function for an @ecdf can be defined as
$
xi_#gls("ecdf") (x) = frac("number of elements in " bold(z)", that" <= x, n) in [0, 1],
$<eq:ecdf_def>
where $n$ defines the number of elements in the vector $bold(z)$.
If the vector $bold(z)$ were to contain the elements $[1, 3, 4, 5, 7, 9, 10]$ and $x = 5$, @eq:ecdf_def would result to $xi_#gls("ecdf") (5) = frac(4, 7)$.\
The application of @eq:ecdf_def on $X$ will transform its values into the empirical tilde-domain.

We can also define an inverse @ecdf: 

$
xi_#gls("ecdf")^(-1) (tilde(x)) =  tilde(x) dot n
$<eq:ecdf_inverse>

The result of @eq:ecdf_inverse is the index $i$ of the element $z_i$ from the vector of realizations $bold(z)$.

