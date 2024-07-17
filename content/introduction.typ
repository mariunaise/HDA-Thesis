= Introduction

These are the introducing words

== Notation

To ensure a consistent notation of functions and ideas, we will now introduce some required conventions 

Random distributed variables will be notated with a capital letter, i.e. $X$, its realization will be the corresponding lower case letter, $x$.

Vectors will be written in bold test: $bold(k)$ represents a vector of quantized symbols.

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

$ cal(Q)(s,m) $<eq-1>

where s determines the amount of metrics and m the bit width of the symbols.

=== Tilde-Domain<tilde-domain>

AS also described in @smhd, we will use a CDF to transform the real PUF values into the Tilde-Domain
This transformation can be performed using the function $xi = tilde(x)$. The key property of this transformation is the resulting uniform distribution of $x$. 

Considering a normal distribution, the CDF is defined as 
$ xi(frac(x - mu, sigma)) = frac(1, 2)[1 + \e\rf(frac(x - mu, sigma sqrt(2)))] $

=== ECDF

The eCDF is constructed through sorting the empirical measurements of a distribution @dekking2005modern. Although less accurate, this method allows a more simple and less computationally complex way to transform real valued measurements into the Tilde-Domain. We will mainly use the eCDF in @chap:smhd because of the difficulty of finding an analytical description for the CDF of a Gaussian-Mixture.
