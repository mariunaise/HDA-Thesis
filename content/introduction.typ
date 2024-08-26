#import "@preview/glossarium:0.4.1": * 
#import "@preview/bob-draw:0.1.0": *
= Introduction

In the field of cryptography, @puf devices are a popular tool for key generation and storage @PUFIntro @PUFIntro2.
In general, a @puf describes a kind of circuit that issues due to minimal deviations in the manufacturing process slightly different behaviours during operation. 
Since the behaviour of one @puf device is now only reproducible on itself and not on a device of the same type with the same manufacturing process, it can be used for secure key generation and/or storage.\

To improve the reliability of the keys generated and stored using the @puf, various #glspl("hda") have been introduced. 
The general operation of a @puf with a @hda can be divided into two separate stages: _enrollment_ and _reconstruction_ as shown in @fig:puf_operation @PUFChartRef.

#figure(
  include("../charts/PUF.typ"), 
  caption: [@puf model description using enrollment and reconstruction.]
)<fig:puf_operation>

The enrollment stage will usually be performed in near ideal, lab-like conditions i.e. at room temperature ($25°C$).
During this phase, a first @puf readout $nu$ with corresponding helper data $h$ is generated. 
Going on, reconstruction can now be performed under varying conditions, for example at a higher temperature.
Here, slightly different @puf readout $nu^*$ is generated. 
Using the helper data $h$ the new @puf readout $nu^*$ can be improved to be less deviated from $v$ as before.
One possible implementation of this principle is called _Fuzzy Commitment_ @fuzzycommitmentpaper @ruchti2021decoder.

Previous works already introduced different #glspl("hda") with various strategies @delvaux2014helper @maes2009soft.
The simplest form of helper-data one could generate is reliability information for every @puf bit.
Here, the @hda marks unreliable @puf bits that are then either discarded during reconstruction or rather corrected using an error correction code after the quantization process. 

Going on, publications @tmhd1 and @tmhd2 introduced a metric-based @hda as @tmhdt.
The main goal of such a @hda is to improve the reliability of the @puf during the quantization step of the enrollment phase. 
To achieve that, helper data is generated to define multiple quantizers for the reconstruction phase to minimize the risk of bit errors. 
A generalization outline to extend @tmhdt for higher order bit quantization has already been proposed by Fischer in @smhd.  

In the course of this work, we will first take a closer look at @smhdt as proposed by Fischer @smhd and provide a concrete realization for this method.
We will also propose a method to shape the input values of a @puf to better fit within the bounds of a multi-bit quantizer which we call @bach. 
We will investigate the question which of these two #glspl("hda") provides the better performance for higher order bit cases with the least amount of helper data bits.

== Notation

To ensure a consistent notation of functions and ideas, we will now introduce some conventions and definitions.

Random distributed variables will be notated with a capital letter, i.e. $X$.
Realizations will be the corresponding lower case letter, $x$.
Values of $x$ subject to some kind of error are marked with a $*$ in the exponent e.g., $x^*$.
Vectors will be written in bold text: e.g., $bold(k)$ represents a vector of quantized symbols.
Matrices are denoted with a bold capital letter: $bold(M)$.
We will call a quantized symbol $k$. $k$ consists of all possible binary symbols, i.e. $0, 01, 110$.
A quantizer will be defined as a function $cal(Q)(x, bold(a))$ that returns a quantized symbol $k$. 
We also define the following special quantizers for metric based #glspl("hda"): 
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

=== Tilde Domain<tilde-domain>

The tilde domain describes the range of numbers between $0$ and $1$, which is defined by the image of a @cdf. 
As also described in @smhd, we will use a @cdf to transform the real PUF values into the tilde domain.
This transformation can be performed using the function $xi = tilde(x)$. The key property of this transformation is the resulting uniform distribution of $x$. 

Considering a normal distribution, the CDF is defined as 
$ xi(frac(x - mu, sigma)) = frac(1, 2)[1 + op("erf")(frac(x - mu, sigma sqrt(2)))] $

==== #gls("ecdf", display: "Empirical cumulative distribution function (eCDF)")

We will not always be able to find an analytical description of a probability distribution and its corresponding @cdf.
Alternatively, an @ecdf can be constructed through sorting the empirical measurements of a distribution @dekking2005modern.
Although less accurate, this method allows a more simple and less computationally complex way to transform real valued measurements into the tilde domain.
We will mainly use the @ecdf in @chap:smhd because of the difficulty of finding an analytical description for the @cdf of a weighted linear combination of random variables.
The function for an @ecdf can be defined as
$
xi_#gls("ecdf") (x) = frac("number of elements in " bold(z)", s.t" <= x, n) in [0, 1],
$<eq:ecdf_def>
where $n$ defines the number of elements in the vector $bold(z)$.
If the vector $bold(z)$ were to contain the elements $[1, 3, 4, 5, 7, 9, 10]$ and $x = 5$, @eq:ecdf_def would result to $xi_#gls("ecdf") (5) = frac(4, 7)$.\
The application of @eq:ecdf_def on $X$ will transform its values into the empirical tilde domain.

We can also define an inverse @ecdf: 

$
xi_#gls("ecdf")^(-1) (tilde(x)) =  tilde(x) dot n
$<eq:ecdf_inverse>

The result of @eq:ecdf_inverse is the index $i$ of the element $z_i$ from the vector of realizations $bold(z)$.

To apply the @ecdf to our numerical results later, we will sort the vector of realizations $bold(z)$ of a random distributed variable $Z$ in ascending order.
