#import "@preview/drafting:0.2.0": *
#import "@preview/glossarium:0.4.1": *

= S-Metric Helper Data Method <chap:smhd>

A metric based @hda generates helper data at PUF enrollment to provide more reliable results at the reconstruction stage. 
Each of these metrics correspond to a quantizer with different bounds to lower the risk of bit or symbol errors during reconstruction.
For this kind of @hda, the generated metric is used as helper data and thus does not have to be kept secret.

== Background

Before we turn to a concrete realization of the S-Metric method, let's take a look at its predecessor, the Two-Metric Helper Data Method.

/*=== Distribution Independency <sect:dist_independency>

The publications for the Two-Metric approach @tmhd1 and @tmhd2, as well as the generalized S-Metric approach @smhd make the assumption, that the PUF readout is zero-mean Gaussian distributed @smhd. 
We propose, that a Gaussian distributed input for S-Metric quantization is not required for the operation of this quantizing algorithm. 
Instead, any distribution can be used for input values given, that a CDF exists for that distribution and its parameters are known. 
As already mentioned in @tilde-domain, this transformation will result in uniformly distributed values, where equi-probable areas in the real domain correspond to equi-distant areas in the Tilde-Domain. 
Contrary to @tmhd1, @tmhd2 and @smhd, which display relevant areas as equi-probable in a normal distribution, we will use equi-distant areas in a uniform distribution for better understandability. 
It has to be mentioned, that instead of transforming all values of the PUF readout into the Tilde-Domain, we could also use an inverse CDF to transform the bounds of our evenly spaced areas into the real domain with (normal) distributed values, which can be assessed as remarkably less computationally complex.#margin-note[Das erst später]
*/
=== Two-Metric Helper Data Method <sect:tmhd>
The most simple form of a metric-based @hda is the Two-Metric Helper Data Method, since the quantization only yields symbols of 1-bit width and uses the least amount of metrics possible if we want to use more than one metric. 

@fig:tmhd_example_enroll and @fig:tmhd_example_reconstruct illustrate an example enrollment and reconstruction process. 
We would consider the marked point the value of the initial measurement and the marked range our margin of error.
If we now were to use the original quantizer shown in @fig:tmhd_example_enroll during both the enrollment and the reconstruction phases, we would risk a bit error, because the margin of error overlaps with the lower quantization bound $-a$, which we can call a point of uncertainty.
But since we generated helper data during enrollment as depicted in @fig:tmhd_enroll, we can make use of a different quantizer $cal(R)(1, 2, x)$ whose boundaries do not overlap with the error margin. 
#scale(x: 90%, y: 90%)[
#grid(
  columns: (1fr, 1fr),
  [#figure(
  include("../graphics/quantizers/two-metric/example_enroll.typ"),
  caption: [Example enrollment]) <fig:tmhd_example_enroll>],
  [#figure(
    include("../graphics/quantizers/two-metric/example_reconstruct.typ"),
    caption: [Example reconstruction]) <fig:tmhd_example_reconstruct>]
)]

Publications @tmhd1 and @tmhd2 find all the relevant bounds for the enrollment and reconstruction phases under the assumption that the PUF readout (our input value $x$) is zero-mean Gaussian distributed. 
//Because the parameters for symbol width and number of metrics always stays the same, it is easier to calculate #m//argin-note[obdA annehmen hier] the bounds for 8 equi-probable areas with a standard deviation of $sigma = 1$ first and then multiplying them with the estimated standard deviation of the PUF readout.
Because the parameters for symbol width and number of metrics always stays the same, we can -- without loss of generality -- assume the standard deviation as $sigma = 1$ and calculate the bounds for 8 equi-probable areas for this distribution. 
This is done by finding two bounds $a$ and $b$ such, that 
$ integral_a^b f_X(x) \dx = 1/8 $
This operation yields 9 bounds defining these areas $-infinity$, $-\T1$, $-a$, $-\T2$, $0$, $\T2$, $a$, $\T1$ and $+infinity$.
During the enrollment phase, we will use $plus.minus a$ as our quantizing bounds, returning $0$ if the //#margin-note[Rück-\ sprache?] absolute value is smaller than $a$ and $1$ otherwise.
The corresponding metric is chosen based on the following conditions: 

$ M = cases(
    \M1\, x < -a or 0 < x < a,
    \M2\, -a < x or 1 < a < x
)space.en. $

@fig:tmhd_enroll shows the curve of a quantizer $cal(Q)$ that would be used during the Two-Metric enrollment phase.
At this point we will still assume that our input value $x$ is zero-mean Gaussian distributed. //#margin-note[Als Annahme nach vorne verschieben]
#scale(x: 90%, y: 90%)[
#grid(
  columns: (1fr, 1fr),
  [#figure(
    include("../graphics/quantizers/two-metric/enrollment.typ"),
    caption: [Two-Metric enrollment]) <fig:tmhd_enroll>],
  [#figure(
    include("../graphics/quantizers/two-metric/reconstruction.typ"),
    caption: [Two-Metric reconstruction]) <fig:tmhd_reconstruct>]
)
]

As previously described, each of these metrics correspond to a different quantizer. 
Now, we can use the generated helper data in the reconstruction phase and define a reconstructed bit based on the chosen metric as follows: 

$ #grid(
  columns: (1fr, 1fr),
  align: (center, center),
  math.equation($\M1: k = cases(0\, x < \T1 or \T2 < x, 1\, -\T1 < x < \T2),$, block: true, numbering: none),
  math.equation($\M2: k = cases(0\, x < -\T2 or \T1 < x, 1\, -\T2 < x < \T1).$, block: true, numbering: none)
) $

@fig:tmhd_reconstruct illustrates the basic idea behind the Two-Metric method. Using the helper data, we will move the bounds of the original quantizer (@fig:tmhd_example_enroll) one octile to each side, yielding two new quantizers. 
The advantage of this method comes from moving the point of uncertainty away from our readout position. 



=== #gls("smhdt", long: true)

Going on, the Two-Metric Helper Data Method can be generalized as shown in @smhd. 
This generalization allows for higher-order bit quantization and the use of more than two metrics. 

A key difference to the Two-Metric approach is the alignment of quantization areas. 
Methods described in @tmhd1 and @tmhd2 use two bounds for 1-bit quantization, namely $plus.minus a$.
Contrary, the method introduced by Fischer in @smhd would look more like a sign-based quantizer if the configuration $cal(Q)(2, 1)$ is used, using only one quantization bound at $x=0$.
@fig:smhd_compar1 and @fig:smhd_compar2 illustrate this difference, . 

#grid(
  columns: (1fr, 1fr),
  [#figure(
    include("../graphics/quantizers/s-metric/s-metric-compar1.typ"),
    caption: [Two-Metric enrollment]
  )<fig:smhd_compar1>],
  [#figure(
    include("../graphics/quantizers/s-metric/s-metric-compar2.typ"),
    caption: [S-Metric enrollment with 1-bit configuration]
  )<fig:smhd_compar2>]
)

The generalization consists of two components:

- *Higher-order bit quantization* \
  We can introduce more steps to our quantizer and use them to extract more than one bit out of our PUF readout.
- *More than two metrics* \
  Instead of splitting each quantizer into only two equi-probable parts, we can increase the number of metrics at the cost of generating more helper data to increase reliability.

== Realization<sect:smhd_implementation> 

We will now propose a specific realization of the S-Metric Helper Data Method. \
//As shown in @sect:dist_independency, we can use a CDF to transform our random distributed variable $X$ into an $tilde(X)$ in the tilde domain.
This allows us to use equi-distant bounds for the quantizer instead of equi-probable ones. 

From now on we will use the following syntax for quantizers that use the S-Metric Helper Data Method: 
$ cal(Q)(S, M, tilde(x)), $

where $S$ defines the number of metrics, $M$ the number of bits and $tilde(x)$ a Tilde-Domain transformed PUF measurement.
=== Enrollment

To enroll our PUF key, we will first need to define the quantizer for higher order bit quantization and helper data generation. 
Because our transformed PUF readout $tilde(x)$ can be interpreted as a realization of a uniformly distributed variable $tilde(X)$, we can define the width $Delta$ of our quantizer bins as follows: 

$ Delta = frac(1, 2^M) . $<eq:delta>

For example, if we were to extract a symbol with the width of 2 bits from our PUF readout, we would need to evenly space $2^2 = 4$ bins. Using equation @eq:delta, the step size for a 2-bit quantizer would result to: 

$ Delta' = lr(frac(1, 2^M) mid(|))_(M=2)= frac(1, 4) . $

@fig:smhd_two_bit shows a plot of the resulting quantizer function that would yield symbols with two bits for one measurement $tilde(x)$.

#figure(
  include("../graphics/quantizers/two-bit-enroll.typ"),
  caption: [2-bit quantizer]
)<fig:smhd_two_bit>

Right now, this quantizer wouldn't help us generating any helper data. 
To achieve that, we will need to divide a symbol step -- one, that returns the corresponding quantized symbol - into multiple sub-steps.
Using $S$, we can define the step size $Delta_S$ as the division of $Delta$ by $S$:

$ Delta_S = frac(Delta, S) = frac(frac(1, 2^M), S) = frac(1, 2^M dot S) $<eq:delta_s>

/*After this definition #margin-note[Absatz nochmal neu], we need to make an adjustment to our previously defined quantizer function, because we cannot simply return the quantized value based on a quantizer with step size $Delta_s$. 
That would just increase the amounts of bits we will extract out of one measurement. 
Instead, we will need to return a tuple, consisting of the quantized symbol and the metric ascertained that we will save as helper data for later. 
*/
We can now redefine our previously defined quantizer function to not only return the quantized symbol, but a tuple consisting of the quantized symbol and the metric ascertained that we will save as helper data for later.

Going on in our example, we could choose the amount of our metrics to be 2. According to @eq:delta_s, we would then half our step size: 

$ Delta'_S = lr(frac(Delta', S)mid(|))_(S=2) = frac(1, 4 dot 2) = frac(1, 8) $


This means, we can update our quantizer function with the new step size $Delta'_S = frac(1, 8)$ and redefining its output as a tuple consisting of bit value and helper data. 

We can visualize the quantizer that we will use during the enrollment phase of a 2-bit 2-metric configuration as depicted in @fig:smhd_2_2_en.

#grid(
  columns: (1fr, 1fr),
[#scale(x: 80%, y: 80%)[
#figure(
  include("../graphics/quantizers/s-metric/2_2_en.typ"),
  caption: [2-bit 2-metric enrollment]
) <fig:smhd_2_2_en>]],
[#scale(x: 80%, y: 80%)[
#figure(
include("../graphics/quantizers/s-metric/3_2_en.typ"),
caption: [2-bit 3-metric enrollment]
) <fig:smhd_3_2_en>]])

To better demonstrate the generalization to $S$-metrics, @fig:smhd_3_2_en shows a 2-bit quantizer that generates helper data based on three metrics instead of two.
In that sense, increasing the number of metrics will increase the number of sub-steps for each symbol.

We can now perform the enrollment of a full PUF readout. 
Each measurement will be quantized with out quantizer $cal(E)$, returning a tuple consisting of the quantized symbol and helper data.

$ K_i = cal(E)(s, m, tilde(x_i)) = (k, h)_i space.en. $ <eq:smhd_quant>

Performing the operation of @eq:smhd_quant for our whole set of measurements will yield a vector of tuples $bold(K)$.

=== Reconstruction

We already demonstrated the basic principle of the reconstruction phase in section @sect:tmhd, which showed the advantage of using more than one quantizer during reconstruction. 

We will call our repeated measurement of $tilde(x)$ that is subject to a certain error $tilde(x^*)$.
To perform reconstruction with $tilde(x^*)$, we will first need to find all $S$ quantizers for which we generated the helper data in the previous step. 

We have to distinguish the two cases, that $S$ is either even or odd:\
If $S$ is even, we need to define $S$ quantizers offset by some distance $phi$.
We can define the ideal position for the quantizer bounds based on its corresponding metric as centered around the center of the related metric.

We can find these new bounds graphically as depicted in @fig:smhd_find_bound_graph. We first determine the x-values of the centers of a metric (here M1, as shown with the arrows). We can then place the quantizer steps with step size $Delta$ (@eq:delta) evenly spaced around these points.
With these new points for the vertical steps of $cal(Q)$, we can draw the new quantizer for the first metric in @fig:smhd_found_bound_graph.


#grid(
  columns: (1fr, 0.1fr, 1fr),
  [#scale(x: 70%, y: 70%)[
  #figure(
    include("../graphics/quantizers/s-metric/2_2_find_quantizer.typ"),
    caption: [Ideal centers and bounds for the M1 quantizer]
  )<fig:smhd_find_bound_graph>]],
  [#align(center)[#align(horizon)[#text(25pt)[$arrow.r.double$]]]],
  [#scale(x: 70%, y: 70%)[
  #figure(
    include("../graphics/quantizers/s-metric/2_2_found_quantizer1.typ"),
    caption: [Quantizer for the first metric]
  )<fig:smhd_found_bound_graph>]]
)

As for metric 2, we can apply the same strategy and find the points for the vertical steps to be at $1/16, 5/16, 9/16$ and $13/16$. This quantizer is shown together with the first-metric quantizer in @fig:smhd_2_2_reconstruction, forming the complete quantizer for the reconstruction phase of a 2-bit 2-metric configuration $cal(R)(2,2,tilde(x))$.

#grid(
  columns: (1fr, 1fr), 
  [
    #scale(x: 80%, y: 80%)[
      #figure(
        include("../graphics/quantizers/s-metric/2_2_reconstruction.typ"),
        caption: [2-bit 2-metric reconstruction quantizer]
      )<fig:smhd_2_2_reconstruction> ]
  ],
  [
    #scale(x: 80%, y: 80%)[
      #figure(
        include("../graphics/quantizers/s-metric/3_2_reconstruction.typ"),
        caption: [2-bit 3-metric reconstruction quantizer],
      )<fig:smhd_3_2_reconstruction> ]
  ]
)

Analytically, the offset we are applying to $cal(E)(2, 2, tilde(x))$ can be defined as

$ Phi = lr(frac(1, 2^M dot S dot 2)mid(|))_(M=2, S=2) = 1 / 16 space.en. $<eq:offset>

$Phi$ is the constant that we will multiply with a certain metric index $i$ to obtain the metric offset $phi$, which is used to define each of the $S$ different quantizers for reconstruction.
//This is also shown in @fig:smhd_2_2_reconstruction, as our quantizer curve is moved $1/16$ to the left and the right.
In @fig:smhd_2_2_reconstruction, the two metric indices $i = plus.minus 1$ will be multiplied with $Phi$, yielding two quantizers, one moved $1/16$ to the left and one moved $1/16$ to the right. 

If a odd number of metrics is given, the offset can still be calculated using @eq:offset. Additionally, we will keep the original quantizer used during enrollment as the quantizer for metric $(s-1)/2$ (@fig:smhd_3_2_reconstruction).



To find all metric offsets for values of $S > 3$, we can use @alg:find_offsets.
For application, we calculate $phi$ based on $S$ and $M$ using @eq:offset. The resulting list of offsets is correctly ordered and can be mapped to the corresponding metrics in ascending order.// as we will show in @fig:4_2_offsets and @fig:6_2_offsets.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  include("../pseudocode/offsets.typ")
)<alg:find_offsets>

==== Offset properties<par:offset_props>
//#inline-note[Diese section ist hier etwas fehl am Platz, ich weiß nur nicht genau wohin damit. Außerdem ist sie ein bisschen durcheinander geschrieben]
Before we go on and experimentally test this realization of the S-Metric method, let's look deeper into the properties of the metric offset value $phi$.\
Comparing @fig:smhd_2_2_reconstruction, @fig:smhd_3_2_reconstruction and their respective values of @eq:offset, we can observe, that the offset $Phi$ gets smaller the more metrics we use.

#figure(
  table(
    columns: (11),
    inset: 7pt,
    align: center + horizon,
    [$M$], 
    [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],
    [$Phi$],[$1/8$],table.cell(fill: gray)[$1/16$], [$1/24$], table.cell(fill:gray)[$1/32$], [$1/40$], table.cell(fill:gray)[$1/48$], [$1/56$], table.cell(fill:gray)[$1/64$],  [$1/72$], table.cell(fill:gray)[$1/80$]
  ),
  caption: [Offset values for 2-bit configurations]
)<tab:offsets>
As previously stated, we will need to define $S$ quantizers, $S/2$ times to the left and $S/2$ times to the right. 
For example, setting parameter $S$ to $4$ means we will need to move the enrollment quantizer $lr(S/2 mid(|))_(S=4) = 2$ times to the left and right. 
As we can see in @fig:4_2_offsets, $phi$ for the maximum metric indices $i = plus.minus 2$ are identical to the offsets of a 2-bit 2-metric configuration.
In fact, this property carries on for higher even numbers of metrics, as shown in @fig:6_2_offsets. 

#grid(
  columns: (1fr, 1fr),
  [#figure(
    table(
      columns: (5),
      inset: 7pt,
      align: center + horizon,
      [$bold(i)$], [$-2$], [$-1$], [$1$], [$2$],
      [*Metric*], [M1], [M2], [M3], [M4], 
      [$bold(phi)$], [$-frac(1, 16)$], [$-frac(1, 32)$], [$frac(1, 32)$], [$frac(1, 16)$]
    ),
    caption: [2-bit 4-metric offsets]
  )<fig:4_2_offsets>
],
  [#figure(
    table(
      columns: (7),
      align: center + horizon,
      inset: 7pt,
      [$bold(i)$], [$-3$], [$-2$], [$-1$], [$1$], [$2$], [$3$],
      [*Metric*], [M1], [M2], [M3], [M4], [M5], [M6],
      [$bold(phi)$], [$-frac(1, 16)$], [$-frac(1, 24)$], [$-frac(1, 48)$], [$frac(1, 48)$], [$frac(1, 24)$], [$frac(1, 16)$]
    ),
    caption: [2-bit 6-metric offsets]
  )<fig:6_2_offsets>
]
)

At $s=6$ metrics, the biggest metric offset we encounter is $phi = 1/16$ at $i = plus.minus 3$.\
This biggest (or maximum) offset is of particular interest to us, as it tells us how far we deviate from the original quantizer used during enrollment. 
The maximum offset for a 2-bit configuration $phi$ is $1/16$ and we will introduce smaller offsets in between if we use a higher even number of metrics.

More formally, we can define the maximum metric offset for an even number of metrics as follows: 
$ phi_("max,even") = frac(frac(S,2), 2^M dot S dot 2) = frac(1, 2^M dot 4) $<eq:max_offset_even>

Here, we multiply @eq:offset by the maximum metric index $i_"max" = S/2$.

Now, if we want to find the maximum offset for a odd number of metrics, we need to modify @eq:max_offset_even, more specifically its numerator. 
For that reason, we will decrease the parameter $m$ by $1$, that way we will still perform a division without remainder:

$
phi_"max,odd" &= frac(frac(S-1, 2), 2^n dot S dot 2)\
&= lr(frac(S-1, 2^M dot S dot 4)mid(|))_(M=2, S=3) = 1/24
$

It is important to note, that $phi_"max,odd"$, unlike $phi_"max,even"$, is dependent on the parameter $S$ as we can see in @tb:odd_offsets.

#figure(
  table(
    columns: (5),
    align: center + horizon, 
    inset: 7pt,
    [*S*],[3],[5],[7],[9],
    [$bold(phi_"max,odd")$],[$1/24$],[$1/20$],[$3/56$],[$1/18$]
  ),
  caption: [2-bit maximum offsets, odd]
)<tb:odd_offsets>

The higher $S$ is chosen, the closer we approximate $phi_"max,even"$ as shown in @eq:offset_limes. 
This means, while also keeping the original quantizer during the reconstruction phase, the maximum offset for an odd number of metrics will always be smaller than for an even number.

$
lim_(S arrow.r infinity) phi_"max,odd" &= frac(S-1, 2^M dot S dot 4) #<eq:offset_limes>\
&= frac(1, 2^M dot 4) = phi_"max,even" 
$

Because $phi_"max,odd"$ only approximates $phi_"max,even"$ if $S arrow.r infinity$ we can assume, that configurations with an even number of metrics will always perform marginally better than configurations with odd numbers of metrics because the bigger maximum offset allows for better reconstructing capabilities. //#margin-note[Sehr unglücklich mit der formulierung hier]

== Improvements<sect:smhd_improvements>

The by @smhd proposed S-Metric Helper Data Method can be improved by using gray coded labels for the quantized symbols instead of naive ones.
#align(center)[
#scale(x: 80%, y: 80%)[
#figure(
  include("../graphics/quantizers/two-bit-enroll-gray.typ"),
  caption: [Gray Coded 2-bit quantizer]
)<fig:2-bit-gray>]]
@fig:2-bit-gray shows a 2-bit quantizer with gray-coded labelling.
In this example, we have an advantage at $tilde(x) = ~ 0.5$, because a quantization error only returns one wrong bit instead of two.

Furthermore, the transformation into the Tilde-Domain could also be performed using the @ecdf to achieve a more precise uniform distribution because we do not have to estimate a standard deviation of the input values.

//#inline-note[Hier vielleicht noch eine Grafik zur Visualisierung?]

== Experiments<sect:smhd_experiments>

We tested the implementation of @sect:smhd_implementation with the temperature dataset of @dataset.
The dataset contains counts of positives edges of a toggle flip flop at a set evaluation time $D$. Based on the count and the evaluation time, the frequency of a ring oscillator can be calculated using: $f = 2 dot frac(k, D)$. 
Because we want to analyze the performance of the S-Metric method over different temperatures, both during enrollment and reconstruction, we are limited to the second part of the experimental measurements of @dataset. 
We will have measurements of $50$ FPGA boards available with $1600$ and $1696$ ring oscillators each. To obtain the values to be processed, we subtract them in pairs, yielding $800$ and $848$ ring oscillator frequency differences _df_.\ 
Since the frequencies _f_ are normal distributed, the difference _df_ can be assumed to be zero-mean Gaussian distributed.
To apply the values _df_ to our implementation of the S-Metric method, we will first transform them into the Tilde-Domain using an inverse CDF, resulti/invite <mxid>ng in uniform distributed values $tilde(italic("df"))$.
Our resulting dataset consists of #glspl("ber") for quantization symbol widths of up to $6 "bits"$ evaluated with generated helper-data from up to $100 "metrics"$.
We chose not to perform simulations for bit widths higher than $6 "bits"$, as we will see later that we have already reached a bit error rate of approx. $10%$ for these configurations.

=== Results & Discussion

The bit error rate of different S-Metric configurations for naive labelling can be seen in @fig:global_errorrates.
For this analysis, enrollment and reconstruction were both performed at room temperature and the quantizer was naively labelled. 

#figure(
  image("../graphics/25_25_all_error_rates.svg", width: 95%),
  caption: [Bit error rates for same temperature execution. Here we can already observe the asymptotic loss of improvement in #glspl("ber") for higher metric numbers]
)<fig:global_errorrates>

We can observe two key properties of the S-Metric method in @fig:global_errorrates.
The error rate in this plot is scaled logarithmically.\
The exponential growth of the error rate of classic 1-metric configurations can be observed through the linear increase of the error rates.
Also, as we expanded on in @par:offset_props, using more metrics will, at some point, not further improve the bit error rate of the key.
At a symbol width of $m >= 6$ bits, no further improvement through the S-Metric method can be observed.

#figure(
  include("../graphics/plots/errorrates_changerate.typ"),
  caption: [Asymptotic performance of @smhdt]
)<fig:errorrates_changerate>

This tendency can also be shown through @fig:errorrates_changerate. 
Here, we calculated the quotient of the bit error rate using one metric and 100 metrics.
From $m >= 6$ onwards, $(x_"1" (m)) / (x_"100" (m))$ approaches $~1$, which means, no real improvement is possible anymore through the S-Metric method.

==== Helper Data Volume Impact

The amount of helper data bits required by @smhdt is defined as a function of the amount of metrics as $log_2(S)$.
The overall extracted-bits to helper-data-bits ratio can be defined here as $cal(r) = lr(frac(n dot M, log_2(S))mid(|))_(n=800) = frac(800 dot M, log_2(S))$

#figure(
    table(
      columns: (7),
      inset: 7pt,
      align: center + horizon,
      [$bold(M)$], [$1$], [$2$], [$3$], [$4$], [$5$], [$6$],
      [*Errorrate*], [$0.012$], [$0.9 dot 10^(-4)$], [$0.002$], [$0.025$], [$0.857$], [$0.148$], 
    ),
    caption: [S-Metric performance with same bit-to-metric ratios]
)<fig:smhd_ratio_performance>

If we take a look at the error rates of configurations for which $cal(r)$ is $800 dot 1$, we can observe a decline in performance of @smhdt for general higher-bit quantization processes. 
This behaviour is also shown in @fig:smhd_ratio_performance.



==== Impact of temperature<sect:impact_of_temperature>

We will now take a look at the impact on the error rates of changing the temperature both during the enrollment and the reconstruction phase.

The most common case to look at, is if we consider a fixed temperature during enrollment, most likely $25°C$.
Since we wont always be able to recreate lab-like conditions during the reconstruction phase, it makes sense to look at the error rates at which reconstruction was performed at different temperatures. 

#figure(
  include("../graphics/plots/temperature/25_5_re.typ"),
  caption: [#glspl("ber") for reconstruction at different temperatures. Generally, the further we move away from the enrollment temperature, the worse the #gls("ber") gets. ]
)<fig:smhd_tmp_reconstruction>

@fig:smhd_tmp_reconstruction shows the results of this experiment conducted with a 2-bit configuration.\
As we can see, the further we move away from the temperature of enrollment, the higher the bit error rates turns out to be.\

We can observe this property well in detail in @fig:global_diffs.

#scale(x: 90%, y: 90%)[
#figure(
 include("../graphics/plots/temperature/global_diffs/global_diffs.typ"),
  caption: [#glspl("ber") for different enrollment and reconstruction temperatures. The lower number in the operating configuration is assigned to the enrollment phase, the upper one to the reconstruction phase. The correlation between the #gls("ber") and the temperature is clearly visible here]
)<fig:global_diffs>]

Here, we compared the asymptotic performance of @smhdt for different temperatures both during enrollment and reconstruction. First we can observe that the optimum temperature for the operation of @smhdt in both phases for the dataset @dataset is $35°C$ instead of the expected $25°C$.
Furthermore, the @ber seems to be almost directly correlated with the absolute temperature difference, especially at higher temperature differences, showing that the further apart the temperatures of the two phases are, the higher the @ber.

==== Gray coding

In @sect:smhd_improvements, we discussed how a gray coded labelling for the quantizer could improve the bit error rates of the S-Metric method.

Because we only change the labelling of the quantizing bins and do not make any changes to #gls("smhdt") itself, we can assume that the effects of temperature on the quantization process are directly translated to the gray-coded case.
Therefore, we will not perform this analysis again here.

@fig:smhd_gray_coding shows the comparison of applying #gls("smhdt") at room temperature for both naive and gray-coded labels.
There we can already observe the improvement of using gray-coded labelling, but the impact of this change of labels can really be seen in @tab:gray_coded_impact.
As we can see, the improvement rises rapidly to a peak at a bit width of M=3 and then falls again slightly.
This effect can be explained with the exponential rise of the #gls("ber") for higher bit widths $M$. 
For $M>3$ the rise of the #gls("ber") predominates the possible improvement by applying a gray-coded labelling.

#figure(
  table(
    columns: (7),
    align: center + horizon, 
    inset: 7pt,
    [*M*],[1],[2],[3],[4], [5], [6],
    [*Improvement*], [$0%$], [$24.75%$], [$47.45%$], [$46.97%$], [$45.91%$], [$37.73%$]
  ),
  caption: [Improvement of using gray-coded instead of naive labelling, per bit width]
)<tab:gray_coded_impact>

#figure(
  image("./../graphics/plots/gray_coding/3dplot.svg"),
  caption: [Comparison between #glspl("ber") using naive labelling and gray-coded labelling]
)<fig:smhd_gray_coding>

Using our dataset, we can estimate the average improvement for using gray-coded labelling to be at around $33%$.
