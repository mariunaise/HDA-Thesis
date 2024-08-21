#import "@preview/glossarium:0.4.1": * 
#import "@preview/bob-draw:0.1.0": *
= Introduction

In the field of cryptography, @puf devices are a popular tool for key generation and storage.
In general, a @puf describes a kind of circuit that issues due to minimal deviations in the manufacturing process slightly different behaviours during operation. 
Since the behaviour of one @puf device is now only reproducible on itself and not on a device of the same type with the same manufacturing process, it can be used for secure key generation and/or storage.\

To improve the reliability of the keys generated and stored using the @puf, various #glspl("hda") have been introduced. 
The general operation of a @puf with a @hda can be divided into two separate stages: _enrollment_ and _reconstruction_.
During enrollment, a @puf readout $v$ is generated upon which helper data $h$ is generated. 
At reconstruction, a slightly different @puf readout $v^*$ is generated. 
Using the helper data $h$ the new @puf readout $v^*$ can be improved to be less deviated from $v$ as before.
This process of helper-data generation is generally known as _Fuzzy Commitment_.

Previous works already introduced different #glspl("hda") with various strategies.
The simplest form of helper-data one could generate is reliability information for every @puf bit.
Here, the @hda marks unreliable @puf bits that are then either discarded during reconstruction or rather corrected using a repetition code after the quantization process. 

Going on, publications @tmhd1, @tmhd2 and @smhd already introduced a metric-based @hda. 
These #glspl("hda") generate helper data during enrollment to define multiple quantizers for the reconstruction phase to minimize the risk of bit errors. 


As a newly proposed @hda, we will propose a method to shape the input values of a @puf to better fit inside the bounds of a multi-bit quantizer. 
We will explore the question which of these two #glspl("hda") provides the better performance for higher order bit cases using the least amount of helper-data bits possible.

== Notation

To ensure a consistent notation of functions and ideas, we will now introduce some conventions and definitions.

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

As also described in @smhd, we will use a CDF to transform the real PUF values into the Tilde-Domain
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

