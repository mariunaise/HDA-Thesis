= Conclusion

During the course of this work, we took a look at two distinct helper-data algorithms: the S-Metric Helper Data Method and the newly presented method of optimization through Boundary Adaptive Clustering with helper-data. 

The S-Metric method will always outperform BACH considering the amount of helper data needed for operation. 
This comes from the nature of S-Metric quickly approaching an optimal @ber for a certain bit width and not improving any further for higher amounts of metrics. 
$
cal(r)_"SMHD" = frac(800 * M, log_2(S))\
cal(r)_"BACH" = frac(M, N)
$
Comparing both formulas for the extracted-bits to helper-data-bits ratio for both methods we can quickly see that S-Metric will always yield more extracted bits per helper-data bit than BACH. 

Considering @ber[BERs], S-Metric does outperform BACH for lower bit values.
But while the error rate for higher order quantization rises exponentially for higher-order bit quantizations, the @ber[BERs] of BACH do seem to rise rather linear than exponentially for higher-order bit quantizations. 
This behaviour might be attributed to the general procedure of shaping the input values for the quantizer in such a way that they are clustered around the center of a quantizer step, which is a property that carries on for higher order bit quantizations.

Notiz: die Simulation der BERs von BACH an dieser stelle unterstützt die Behauptung die hier steht, aber der 250 Kerne rechner ist tatsächlich noch sehr lange mit der kalkulation beschäftigt. Das wird aber definitiv noch angehängt
