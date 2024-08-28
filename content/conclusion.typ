#import "@preview/glossarium:0.4.1": * 

= Comparison of @smhdt and @bach

During the course of this work, we took a look at two distinct helper-data algorithms: the S-Metric Helper Data method and the newly presented method of optimization through Boundary Adaptive Clustering with helper-data. 

The S-Metric method will always outperform BACH considering the amount of helper data needed for operation. 
This comes from the nature of S-Metric quickly approaching an optimal @ber for a certain bit width and not improving any further for higher amounts of metrics. 

Comparing both formulas for the extracted-bits to helper-data-bits ratio for both methods we can quickly see that S-Metric will always yield more extracted bits per helper-data bit than BACH. 

Considering #glspl("ber"), S-Metric does outperform BACH for smaller symbol widths.
But while the error rate for higher order quantization rises exponentially for higher-order bit quantizations, the #glspl("ber") of BACH do seem to rise rather linear than exponentially for higher-order bit quantizations. 
This behaviour might be attributed to the general procedure of shaping the input values for the quantizer in such a way that they are clustered around the center of a quantizer step, which is a property that carries on for higher order bit quantizations.


We can now compare both the S-Metric Helper Data method and the newly presented method of optimization through Boundary Adaptive Clustering with Helper data based on the @ber and the amount of helper data bits, more specifically the extracted bit to helper data bit ratio $cal(r)$.
The ratios $cal(r)$ for both methods are defined as: 
$
cal(r)_"SMHD" = frac(M, log_2(S))\
cal(r)_"BACH" = frac(M, N-1)
$

A good outline to compare both performances of @bach and @smhdt is if $cal(r) = 1$ for varying values of $M$. 

#figure(
  table(
    columns: 7,

    [*M*], [$1$], [$2$], [$3$], [$4$], [$5$], [$6$],
    [*@ber @smhdt*], [$8 dot 10^(-6)$], [$4 dot 10^(-5)$], [$1 dot 10^(-3)$], [$0.02$], [$0.08$], [$0.15$],
    [*@ber @bach*], [$0.09$], [$0.05$], [$0.05$], [$0.22$], [$0.23$], [$0.23$]
  ),
  caption: [#glspl("ber") for @bach and @smhdt configurations that equal the bit width of the quantized symbol and the amount of helper data bits]
)
