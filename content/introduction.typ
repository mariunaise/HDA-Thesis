= Introduction

These are the introducing words

== Notation

To ensure a consistent notation of functions and ideas, we will now introduce some required conventions 

Random distributed variables will be notated with a capital letter, i.e. $X$, its realization will be the corresponding lower case letter, $x$.

Vectors will be written in bold test: $bold(k)$ represents a vector of quantized symbols.

We will call a quantized symbol $k$. $k$ consists of all possible binary symbols, i.e. $0, 01, 110$.

A quantizer will be defined as a function $cal(Q)(x, bold(a))$ that returns a quantized symbol $k$. 

@example-quantizer shows the curve of a 2-bit quantizer that receives $tilde(x)$ as input. In the case, that the value of $tilde(x)$ equals one of the four bounds, the quantized value is chosen randomly from the relevant bins.

#figure(
  include("../graphics/quantizers/two-metric-enroll.typ"),
  caption: [Example quantizer function]) <example-quantizer>

For the S-Metric Helper Data Method, we introduce a function

$ cal(Q)(s,m) $<eq-1>

where s determines the amount of metrics and m the bit width of the symbols.

=== Tilde-Domain<tilde-domain>

AS also described in REFSMHD, we will use a CDF to transform the real PUF values into the Tilde-Domain
This transformation can be performed using the function $sym(xi) = tilde(x)$. The key property of this transformation is the resulting uniform distribution of $x$. 

Considering a normal distribution, the CDF is defined as 
$ sym(xi)(frac(x - sym(mu))(sym(sigma))) = frac(1)(2)[1 + erf(frac(x - sym(mu))(sym(sigma) sqrt(2)))] $
