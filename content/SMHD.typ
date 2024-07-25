= S-Metric Helper Data Method <chap:smhd>

A metric based @hda generates helper data at PUF enrollment to provide more reliable results at the reconstruction stage. 
Each of these metrics correspond to a quantizer with different bounds to lower the risk of bit or symbol errors during reconstruction. 

== Background

=== Distribution Independency <sect:dist_independency>

The publications for the Two-Metric approach @tmhd1 and @tmhd2, as well as the generalized S-Metric approach @smhd make the assumption, that the PUF readout is "zero-mean Gaussian distributed" @smhd. 
We propose, that a Gaussian distributed input for S-Metric quantization is not required for the operation of this quantizing algorithm. 
Instead, any distribution can be used for input values given, that a CDF exists for that distribution and its parameters are known. 
As already mentioned in @tilde-domain, this transformation will result in uniformly distributed values, where equi-probable areas in the real domain correspond to equi-distant areas in the Tilde-Domain. 
Contrary to @tmhd1, @tmhd2 and @smhd, which display relevant areas as equi-probable in a normal distribution, we will use equi-distant areas in a uniform distribution for better understandability. 
It has to be mentioned, that instead of transforming all values of the PUF readout into the Tilde-Domain, we could also use an inverse CDF to transform the bounds of our evenly spaced areas into the real domain with (normal) distributed values, which can be assessed as remarkably less computationally complex.

=== Two-Metric Helper Data Method <sect:tmhd>

The most simple form of a metric-based @hda is the Two-Metric Helper Data Method, since the quantization only yields symbols of 1-bit width and uses the lead amount of metrics possible. 
Publications @tmhd1 and @tmhd2 find all the relevant bounds for the enrollment and reconstruction phases under the assumption that the PUF readout is Gaussian distributed. 
Because this approach is static, meaning the parameters for symbol width and number of metrics always stays the same, it is easier to calculate the bounds for 8 equi-probable areas with a standard deviation of $sigma = 1$ first and then multiplying them with the estimated standard deviation of the PUF readout. 
This is done by finding two bounds $a$ and $b$, that 
$ integral_a^b f_X(x) \dx = 1/8 $
This operation yields 9 bounds defining these areas $-\T1$, $-a$, $-\T2$, $0$, $\T2$, $a$, $\T1$ and $plus.minus infinity$.
During the enrollment phase, we will use $plus.minus a$ as our quantizing bounds, retuning $0$ if the absolute value is smaller than $a$ and $1$ otherwise.
The corresponding metric is chosen based on the following conditions: 

$ M = cases(
    \M1\, x < -a or 0 < x < a,
    \M2\, -a < x or 1 < a < x
) $

@fig:tmhd_enroll shows the curve of a quantizer $cal(Q)$, that would be used during the Two-Metric enrollment phase. At this point, we will still assume, that our input value $x$ is zero-mean Gaussian distributed. 

#grid(
  columns: (1fr, 1fr),
  [#figure(
    include("../graphics/quantizers/two-metric/enrollment.typ"),
    caption: [Two-Metric enrollment]) <fig:tmhd_enroll>],
  [#figure(
    include("../graphics/quantizers/two-metric/reconstruction.typ"),
    caption: [Two-Metric reconstruction]) <fig:tmhd_reconstruct>]
)


The metric will be stored publicly for every quantized bit as helper data. 
As previously described, each of these metrics correspond to a different quantizer. 
Now, we can use the generated helper data in the reconstruction phase and define a reconstructed bit based on the chosen metric as follows: 

$ #grid(
  columns: (1fr, 1fr),
  align: (center, center),
  math.equation($\M1: k = cases(0\, x < \T1 or \T2 < x, 1\, -\T1 < x < \T2)$, block: true, numbering: none),
  math.equation($\M2: k = cases(0\, x < -\T2 or \T1 < x, 1\, -\T2 < x < \T1)$, block: true, numbering: none)
) $

@fig:tmhd_reconstruct illustrates the basic idea behind the Two-Metric method. Using the helper data, we will move the bounds of the original quantizer one octile to each side, yielding two new quantizers. 
The advantage of this method comes from moving the point of uncertainty away from our readout position. 

@fig:tmhd_example_enroll and @fig:tmhd_example_reconstruct illustrate an example enrollment and reconstruction process. 
We would consider the marked point the value of the initial measurement and the marked range our margin of error due to inaccuracies in the measurement process.
If we now were to use the quantizer shown in @fig:tmhd_example_enroll during both the enrollment and the reconstruction phases, we would risk a bit error, because the margin of error overlaps with the lower quantization bound $-a$.
But since we generated helper data during enrollment as depicted in @fig:tmhd_enroll, we can make use of a different quantizer $cal(R)(1, 2, x)$ whose boundaries do not overlap with the error margin of the measurement. 

#grid(
  columns: (1fr, 1fr),
  [#figure(
  include("../graphics/quantizers/two-metric/example_enroll.typ"),
  caption: [Example enrollment]) <fig:tmhd_example_enroll>],
  [#figure(
    include("../graphics/quantizers/two-metric/example_reconstruct.typ"),
    caption: [Example reconstruction]) <fig:tmhd_example_reconstruct>]
)
#pagebreak()

=== S-Metric Helper Data Method

Going on, the Two-Metric Helper Data Method can be generalized as shown in @smhd. 
This generalization allows for higher order bit quantization and the use of more than two metrics. 

A key difference to the Two-Metric approach is the alignment of quantization areas. 
Methods described in @tmhd1 and @tmhd2 use two bounds for 1-bit quantization, namely $plus.minus a$.
Contrary, the method introduced by @smhd would look more like a sign based quantizer if the configuration $cal(Q)(2, 1)$ is used, using only one quantization bound at $x=0$.
@fig:smhd_compar1 and @fig:smhd_compar2 illustrate this difference. 

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

- *Higher order bit quantization* \
  We can introduce more steps to our quantizer and use them to extract more than one bit out of our PUF readout.
- *Using more than two metrics* \
  Instead of splitting each quantizer into only two equi-probable parts, we can increase the number of metrics at the cost of generating more helper data.

== Implementation<sect:smhd_implementation>

We will now propose a specific implementation of the S-Metric Helper Data Method. \
As shown in @sect:dist_independency, we can use a CDF to transform our random distributed variable $X$ into the Tilde-Domain: $tilde(X)$.
This allows us to use equi-distant bounds for the quantizer instead of equi-probable ones. 

From now on we will use the following syntax for quantizers that use the S-Metric Helper Data Method: 
$ cal(Q)(s, m, tilde(x)) $

where s defines the number of metrics, m the number of bits and $tilde(x)$ a Tilde-Domain transformed PUF measurement.
#pagebreak()
=== Enrollment

To enroll our PUF key, we will first need to define the quantizer for higher order bit quantization and helper data generation. 
Because our PUF readout $tilde(x)$ can be interpreted as a realization of a uniformly distributed variable $tilde(X)$, we can define the width $Delta$ of our quantizer bins as follows: 

$ Delta = frac(1, 2^m) $<eq:delta>

For example, if we were to extract a symbol with the width of 2 bits from our PUF readout, we would need to evenly space $2^2 = 4$ bins. Using equation @eq:delta, the step size for a 2-bit quantizer would result to: 

$ Delta' = lr(frac(1, 2^m) mid(|))_(m=2)= frac(1, 4) $

@fig:smhd_two_bit shows a plot of the resulting quantizer function that would yield symbols with two bits for one measurement $tilde(x)$.

#figure(
  include("../graphics/quantizers/two-bit-enroll.typ"),
  caption: [2-bit quantizer]
)<fig:smhd_two_bit>

Right now, this quantizer wouldn't help us generating any helper data. 
To achieve that, we will need to divide a symbol step - one, that returns the corresponding quantized symbol - into multiple sub-steps.
More specifically, we will define the amount of metrics we want to use with the parameter $s$. Using $s$, we can define the step size $Delta_s$ as the division of $Delta$ by $s$:

$ Delta_s = frac(Delta, s) = frac(frac(1, 2^m), s) = frac(1, 2^m dot s) $<eq:delta_s>

After this definition, we need to make an adjustment to our previously defined quantizer function, because we cannot simply return the quantized value based on a quantizer with step size $Delta_s$. 
That would just increase the amounts of bits we will extract out of one measurement. 
Instead, we will need to return a tuple, consisting of the quantized symbol and the metric ascertained that we will save as helper data for later. 

Going on in our example, we could choose the amount of our metrics to be 2. According to @eq:delta_s, we would then half our step size: 

$ Delta'_s = lr(frac(Delta', s)mid(|))_(s=2) = frac(1, 4 dot 2) = frac(1, 8) $


This means, we can update our quantizer function with the new step size $Delta'_s = frac(1, 8)$ and redefining its output as a tuple consisting of bit value and helper data. 

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

To better demonstrate the generalization to $s$-metrics, @fig:smhd_3_2_en shows a 2-bit quantizer that generates helper data based on three metrics instead of two.
In that sense, increasing the number of metrics will increase the number of sub-steps for each symbol.

We can now perform the enrollment of a full PUF readout. 
Each measurement will be quantized with out quantizer $cal(E)$, returning a tuple consisting of the quantized symbol and helper data, as shown in @eq:smhd_quant

$ K_i = cal(E)(s, m tilde(x_i)) = (k, h)_i $ <eq:smhd_quant>

Performing the operation of @eq:smhd_quant for our whole set of measurements will yield a vector of tuples $bold(K)$.
#pagebreak()
=== Reconstruction

We already demonstrated the basic principle of the reconstruction phase in section @sect:tmhd, more specifically with @fig:tmhd_example_enroll and @fig:tmhd_example_reconstruct, which show the advantage of using more than one quantizer during reconstruction. 

We will call our repeated measurement of $tilde(x)$ that is subject to a certain error $tilde(x^*)$.
To perform reconstruction with $tilde(x^*)$, we will first need to find all $s$ quantizers for which we generated the helper data in the previous step. 

We have to distinguish two different cases for the value of $s$: 
- $s$ is odd 
- $s$ is even

If $s$ is even, we need to move our quantizer $s/2$ times some distance to the right and $s/2$ times some distance to the left.
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

As for metric 2, we can apply the same strategy and find the points for the vertical steps to be at $1/16, 5/16, 9/16$ and $13/16$. This quantizer can be visualized together with the first metric quantizer in @fig:smhd_2_2_reconstruction, forming the complete quantizer for the reconstruction phase of a 2-bit 2-metric configuration $cal(R)(2,2,tilde(x))$.

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

$ phi = lr(frac(1, 2^n dot s dot 2)mid(|))_(n=2, s=2) = 1 / 16 $<eq:offset>

This is also shown in @fig:smhd_2_2_reconstruction, as our quantizer curve is moved $1/16$ to the left and the right. 

If a odd number of metrics is given, the offset can still be calculated using @eq:offset. Additionally, we will keep the original quantizer used during enrollment (@fig:smhd_3_2_reconstruction).

Comparing @fig:smhd_2_2_reconstruction, @fig:smhd_3_2_reconstruction and their respective values of @eq:offset, we can observe, that the offset $phi$ gets smaller the more metrics we use. 


#figure(
  table(
    columns: (11),
    inset: 7pt,
    align: center + horizon,
    [$m$], 
    [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],
    [$phi$],[$1/8$],table.cell(fill: gray)[$1/16$], [$1/24$], table.cell(fill:gray)[$1/32$], [$1/40$], table.cell(fill:gray)[$1/48$], [$1/56$], table.cell(fill:gray)[$1/64$],  [$1/72$], table.cell(fill:gray)[$1/80$]
  ),
  caption: [Offset values for 2-bit configurations]
)<tab:offsets>

To find all offsets for values of $s > 3$, we can use @alg:find_offsets.
For application, we calculate $phi$ based on the metric using @eq:offset. The resulting list of offsets is correctly ordered and can be mapped to the corresponding metrics in ascending order as we will show in @fig:4_2_offsets and @fig:6_2_offsets.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  include("../pseudocode/offsets.typ")
)<alg:find_offsets>

==== Offset properties<par:offset_props>

Lets look deeper into the properties of the offset value $phi$.
As previously stated, we will need to move the enrollment quantizer $s/2$ times to the left and $s/2$ times to the right. 
For example, setting parameter $s$ to $4$ means we will need to move the enrollment quantizer $lr(s/2 mid(|))_(s=4) = 2$ times to the left and right. 
As we can see in @fig:4_2_offsets, $phi$ for the indices $i = plus.minus 2$ are identical to the offsets of a 2-bit 2-metric configuration.
In fact, this property carries on for higher even numbers of metrics.

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

At $s=6$ metrics, the biggest offset we encounter is $phi = 1/16$ at $i = plus.minus 3$.\
In conclusion, the maximum offset for a 2-bit configuration $phi$ is $1/16$ and we will introduce smaller offsets in between if we use a higher even number of metrics. More formally, we can define the maximum offset for an even number of metrics as follows: 
$ phi_("max,even") = frac(frac(s,2), 2^n dot s dot 2) = frac(1, 2^n dot 4) $<eq:max_offset_even>

Here, we multiply @eq:offset with the maximum offsetting index $i_"max" = s/2$.

Now, if we want to find the maximum offset for a odd number of metrics, we need to modify @eq:max_offset_even, more specifically its numerator. 
We know, that we need to keep the original quantizer for a odd number of metrics.
Besides that, the method stays the same. 
For that reason, we will decrease the parameter $m$ by $1$, that way we will still perform a division without remainder:

$
phi_"max,odd" &= frac(frac(s-1, 2), 2^n dot s dot 2)\
&= lr(frac(s-1, 2^n dot s dot 4)mid(|))_(n=2, s=3) = 1/24
$

It is important to note, that $phi_"max,odd"$, unlike $phi_"max,even"$, is dependent on the parameter $s$ as we can see in @tb:odd_offsets.

#figure(
  table(
    columns: (5),
    align: center + horizon, 
    inset: 7pt,
    [*s*],[3],[5],[7],[9],
    [$bold(phi_"max,odd")$],[$1/24$],[$1/20$],[$3/56$],[$1/18$]
  ),
  caption: [2-bit maximum offsets, odd]
)<tb:odd_offsets>

The higher $m$ is chosen, the closer we approximate $phi_"max,even"$ as shown in @eq:offset_limes. 
This means, while also keeping the original quantizer during the reconstruction phase, the maximum offset for an odd number of metrics will always be smaller than for an even number. 
//We will be able to observe this property later on in 

$
lim_(s arrow.r infinity) phi_"max,odd" &= frac(s-1, 2^n dot s dot 4) #<eq:offset_limes>\
&= frac(1, 2^n dot 4) = phi_"max,even" 
$

== Improvements

The here proposed S-Metric Helper Data Method can be improved by using gray coded labels for the quantized symbols instead of naive ones @smhd.
#align(center)[
#scale(x: 80%, y: 80%)[
#figure(
  include("../graphics/quantizers/two-bit-enroll-gray.typ"),
  caption: [Gray Coded 2-bit quantizer]
)<fig:2-bit-gray>]]
@fig:2-bit-gray shows a 2-bit quantizer with gray coded labelling.
In this example, we have an advantage at $tilde(x) = ~ 0.5$, because a quantization error only returns one wrong bit instead of two.

== Helper data volume

== Experiments & Results

We tested the implementation of @sect:smhd_implementation with the temperature dataset of @dataset.
The dataset contains counts of positives edges of a toggle flip flop at a set evaluation time $D$. Based on the count and the evaluation time, the frequency of a ring oscillator can be calculated using: $f = 2 dot frac(k, D)$. 
Because we want to analyze the performance of the S-Metric method over different temperatures, both during enrollment and reconstruction, we are limited to the second part of the experimental measurements of @dataset. 
We will have measurements of $50$ FPGA boards available with $1600$ and $1696$ ring oscillators each. To obtain the values to be processed, we subtract them in pairs, yielding $800$ and $848$ ring oscillator frequency differences _df_.\ 
Since the frequencies _f_ are normal distributed, the difference _df_ can be assumed to be zero-mean Gaussian distributed.
To apply the values _df_ to our implementation of the S-Metric method, we will first transform them into the Tilde-Domain using an inverse CDF, resulting in uniform distributed values $tilde(italic("df"))$.

=== General Interpretation

The bit error rate of different S-Metric configurations for naive labelling can be seen in @fig:global_errorrates.
For this analysis, enrollment and reconstruction were both performed at room temperature and the quantizer was naively labelled. 

#figure(
  image("../graphics/25_25_all_error_rates.svg", width: 95%),
  caption: [Bit error rates for same temperature execution]
)<fig:global_errorrates>

We can observe two key properties of the S-Metric method in @fig:global_errorrates.
The error rate in this plot is scaled logarithmically.\
The exponential growth of the error rate of classic 1-metric configurations can be observed through the linear increase of the error rates.
Also, as we expanded on in @par:offset_props, using more metrics will, at some point, not further improve the bit error rate of the key.
At a symbol width of $m >= 6$ bits, no further improvement through the S-Metric method can be observed.

#figure(
  include("../graphics/plots/errorrates_changerate.typ"),
  caption: [Asymptotic performance of S-Metric]
)<fig:errorrates_changerate>

This tendency can also be shown through @fig:errorrates_changerate. 
Here, we calculated the quotient of the bit error rate using one metric and 100 metrics.
From $m >= 6$ onwards, $(x_"1" (m)) / (x_"100" (m))$ approaches $~1$, which means, no real improvement is possible anymore through the S-Metric method.

//=== Observation of offset $phi$ 

//If we take a look at the 1-bit case, we can nicely observe the approximating nature of $phi_"max,odd"$ to $phi_"max,even"$ of @par:offset_props.

//#figure(
//  include("../graphics/plots/1bit_obs.typ"),
//  caption: [Yoink]
//)

=== Impact of temperature

Usually we will perform enrollment at room temperature. 
We will now take a look at the impact of changing the temperature both during the enrollment and the reconstruction phase.

==== Different reconstruction temperature


==== Different enrollment temperature

=== Gray coding


