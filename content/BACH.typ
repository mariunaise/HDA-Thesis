#import "@preview/glossarium:0.4.1": * 

= Boundary Adaptive Clustering with Helper Data

Instead of generating helper-data to improve the quantization process itself, like in #gls("smhdt"), we can also try to find helper-data before performing enrollment that will optimize our input values before the quantization step to minimize the risk of bit and symbol errors during the reconstruction phase. 

Since this #gls("hda") modifies the input values before the quantization takes place, we will consider the input values as zero-mean Gaussian distributed and not use a CDF to transform these values into the tilde-domain.

== Optimizing a 1-bit sign-based quantization

Before we take a look at the higher order quantization cases, we will start with a very basic method of quantization: a quantizer, that only returns a symbol with a width of $1$ bit and uses the sign of the input value to determine the resulting bit symbol.

#figure(
  include("./../graphics/quantizers/bach/sign-based-overlay.typ"),
  caption: [Nice graph]
)

