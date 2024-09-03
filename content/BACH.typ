#import "@preview/glossarium:0.4.1": *
#import "@preview/tablex:0.0.8": tablex, rowspanx, colspanx

= Boundary Adaptive Clustering with Helper Data (BACH)

//Instead of generating helper-data to improve the quantization process itself, like in #gls("smhdt"), or using some kind of error correcting code after the quantization process, we can also try to find helper-data before performing the quantization that will optimize our input values before quantizing them to minimize the risk of bit and symbol errors during the reconstruction phase. 

We can explore the option of finding helper data before performing the quantization process.
This approach  aims to optimize our input values prior to quantization, which may help minimize the risk of bit and symbol errors during the reconstruction phase. 
This differs from methods like @smhdt, which generate helper data to improve the quantization process itself, of those that apply error-correcting codes afterward.

Since this #gls("hda") modifies the input values before the quantization takes place, we will consider the input values as zero-mean Gaussian distributed and not use a CDF to transform these values into the tilde-domain.

== Optimizing single-bit sign-based quantization<sect:1-bit-opt>

Before we take a look at the higher order quantization cases, we will start with a very basic method of quantization: a quantizer, that only returns a symbol with a width of $1$ bit and uses the sign of the input value to determine the resulting bit symbol.

#figure(
  include("./../graphics/quantizers/bach/sign-based-overlay.typ"),
  caption: [1-bit quantizer with the PDF of a normal distribution]
)<fig:1-bit_normal>

If we overlay the PDF of a zero-mean Gaussian distributed variable $X$ with a sign-based quantizer function as shown in @fig:1-bit_normal, we can see that the expected value of the Gaussian distribution overlaps with the decision threshold of the sign-based quantizer.
Considering that the margin of error of the value $x$ is comparable with the one shown in @fig:tmhd_example_enroll, we can conclude that values of $X$ that reside near $0$ are to be considered more unreliable than values that are further away from the x-value 0.
This means that the quantizer used here is very unreliable as is.

Now, to increase the reliability of this quantizer, we can try to move our input values further away from the value $x = 0$. 
To do so, we can define a new input value $z$ as a linear combination of two realizations of $X$, $x_1$ and $x_2$ with a set of weights $h_1$ and $h_2$ that we will use as helper data: 
$
z = h_1 dot x_1 + h_2 dot x_2 ,
$<eq:lin_combs>

with $h_i in {plus.minus 1}$. Building only the sum of two input values $x_1 + x_2$ is not sufficient here, since the resulting distribution would be a normal distribution with $mu = 0$ as well.
=== Derivation of the resulting distribution

To find a description for the random distribution $Z$ of $z$ we can interpret this process mathematically as a maximisation of a sum.
This can be realized by replacing the values of $x_i$ with their absolute values as this always gives us the maximum value of the sum:
$
z = abs(x_1) + abs(x_2) 
$
Taking into account that $x_i$ are realizations of a normal distribution, we can assume without loss of generality that $X$ is i.i.d., /*to have its expected value at $x=0$ and a standard deviation of $sigma = 1$ --*/ defining the overall resulting random distribution $Z$ as: 
$
Z = abs(X_1) + abs(X_2).
$<eq:z_distribution>
We will redefine $abs(X)$ as a half-normal distribution $Y$ whose PDF is
$
f_Y(y, sigma) &= frac(sqrt(2), sigma sqrt(pi)) lr(exp(-frac(y^2, 2 sigma^2)) mid(|))_(sigma = 1), y >= 0 \
&= sqrt(frac(2, pi)) exp(- frac(y^2, sigma^2)) .
$<eq:half_normal>
Now, $Z$ simplifies to 
$
Z = Y_1 + Y_2.
$
We can assume for now that the realizations of $Y$ are independent of each other.
The PDF of the addition of these two distributions can be described through the convolution of their respective PDFs: 
$
f_Z(z) &= integral_0^z f_Y (y) f_Y (z-y) \dy\
&= integral_0^z [sqrt(2/pi) exp(-frac(y^2,2)) sqrt(2/pi) exp(-frac((z-y)^2, 2))] \dy\
&= 2/pi integral_0^z exp(- frac(y^2 + (z-y)^2, 2)) \dy #<eq:z_integral>
$
Evaluating the integral of @eq:z_integral, we can now describe the resulting distribution of this maximisation process analytically:
$
f_Z = 2/sqrt(pi) exp(-frac(z^2, 4)) "erf"(z/2) z >= 0.
$<eq:z_result>
Our derivation of $f_Z$ currently only accounts for the addition of positive values of $x_i$, but two negative $x_i$ values would also return the maximal distance to the coordinate origin.
The derivation for the corresponding PDF is identical, except that the half-normal distribution @eq:half_normal is mirrored around the y-axis.
Because the resulting PDF $f_Z^"neg"$ is a mirrored variant of $f_Z$ and $f_Z$ is arranged  symmetrically around the origin, we can define a new PDF $f_Z^*$ as 
$
f_Z^* (z) = abs(f_Z (z)),
$
on the entire z-axis.
$f_Z^* (z)$ now describes the final random distribution after the application of our optimization of the input values $x_i$.
#figure(
  include("../graphics/plots/z_distribution.typ"),
  caption: [Optimized input values $z$ overlaid with sign-based quantizer $cal(Q)$]
)<fig:z_pdf>

@fig:z_pdf shows two key properties of this optimization:
1. Adjusting the input values using the method described above does not require any adjustment of the decision threshold of the sign-based quantizer.
2. The resulting PDF is zero at $z = 0$ leaving no input value for the sign-based quantizer at its decision threshold. 

=== Generating helper-data

To find the optimal set of helper-data that will result in the distribution shown in @fig:z_pdf, we can define the vector of all possible linear combinations $bold(z)$ as the vector-matrix multiplication of the input values $x_i$ and the matrix $bold(H)$ of all weight combinations with $h_i in [plus.minus 1]$: 
$
bold(z) &= bold(x) dot bold(H)\
$<eq:z_combinations>
We will choose the optimal weights based on the highest absolute value of $bold(z)$, as that value will be the furthest away from $0$. 
//We may encounter two entries in $bold(z)$ that both have the same highest absolute value.
//In that case, we will choose the combination of weights randomly out of our possible options.
To not encounter two entries in $bold(z)$ that both have the same highest absolute value, we can set the first helper data bit to be always $h_1 = 1$. 

Considering our single-bit quantization case, @eq:z_combinations can be written as: 

$
bold(z) = vec(x_1, x_2) dot mat(delim: "[", +1, -1, +1, -1; +1, +1, -1, -1)
$

The vector of optimal weights $bold(h_"opt")$ can now be found through $op("argmax")_h (bold(z))$.
If we take a look at the dimensionality of the matrix of all weight combinations, we notice that we will need to store only $1$ helper-data bit per quantized symbol because $h_1$ is set to $1$.
In fact, we will show later, that the amount of helper-data bits used by this HDA is directly linked to the number of input values used instead of the number of bits we want to extract during quantization.

== Generalization to higher-order bit quantization

We can generalize the idea of @sect:1-bit-opt and apply it for a higher-order bit quantization.
Contrary to @smhdt, we will always use the same step function as quantizer and optimize the input values $x$ to be the furthest away from any decision threshold.
In this higher-order case, this means that we want to optimise our input values as far away as possible from the nearest decision threshold of the quantizer instead of just maximising the absolute value of the linear combination.

For a complete generalization of this method, we will also parametrize the amount of addends $N$ kin the linear combination of $z$.
That means we can define $z$ from now on as:
$
z = sum_(i=1)^(N) x_i dot h_i
$<eq:z_eq>



We can define the condition to test whereas a tested linear combination is optimal as follows:\
The optimal linear combination $z_"opt"$ is found, when the distance to the nearest quantizer decision bound is maximised. 
Finding the weights $bold(h)_"opt"$ of the optimal linear combination $z_"opt"$ can be formalized as: 

$
bold(h)_"opt" = op("argmax")_h op("min")_j abs(bold(h)^T bold(x) - b_j) "s.t." h_j in {plus.minus 1}
$<eq:optimization>

==== Example with 2-bit quantizer
//Let's consider the following example using a 2-bit quantizer:\
We can define the bounds of the two bit quantizer $bold(b)$ as $[-alpha, 0, alpha]$ omitting the bounds $plus.minus infinity$.
The values of $bold(b)$ are already placed in the real domain to directly quantize normal distributed input values.
A simple way to solve @eq:optimization is to use a brute force method and calculate all distances to every quantization bound $b_j$, because the number of possible combinations is finite.
Furthermore, fining a solution for @eq:optimization analytically poses to be significantly more complex.

The linear combination $z$ for the amount of addends $i = 2$ is defined as 
$
z = x_1 dot h_1 plus x_2 dot h_2
$<eq:bach_z_example>

According to @eq:z_combinations, all possible linear combinations for two input values $x_1 "and" x_2$ of @eq:bach_z_example can be collected as the vector $bold(z)$ of length $2^i |_(i=2) =4$:
$
bold(z) = vec(z_1\, z_2\, z_3\, z_4)
$
Calculating the absolute distances to every quantizer bound $b_i$ for all linear combinations $z_i$ gives us the following distance matrix:

$
bold(cal(A)) = mat(
  a_(1,1), a_(2,1), a_(3,1), a_(4,1);
  a_(1,2), a_(2,2), a_(3,1), a_(4,2);
  a_(1,3), a_(2,3), a_(3,1), a_(4,3);
),
$<mat:distance_A>

where $a_"i,j" = abs(z_i - b_j)$.

Now we want to find the bound $b_i$ for every $z_i$ to which it is closest.
This can be achieved by determining the minimum value for each column of the matrix $bold(cal(A))$.
The resulting vector $bold(nu)$ now consists of the distance to the nearest quantizer bound for every linear combination with entries defined as: 
$
nu_"j" = min{a_"i,j" | 1 <= j  <= 4} "for each" i  = 1, 2, 3.
$

The optimal linear combination $z_"opt"$ can now be found as the entry $z_j$ of $bold(z)$ where its corresponding distance $nu_j$ is maximised.

=== Simulation of the bound distance maximisation strategy<sect:instability_sim> 

Two important points were anticipated in the preceding example: 
1. We cannot define the resulting random distribution $Z$ after performing this operation analytically and thus also not the quantizer bounds $bold(b)$.
  A way to account for that is to guess the resulting random distribution and $bold(b)$ initially and repeating the optimization using quantizer bounds found through the @ecdf of the resulting linear combination values.
2. If the optimization described above is repeated multiple times using an @ecdf, the resulting random distribution $Z$ must converge to a stable random distribution. Otherwise we will not be able to carry out a reliable quantization in which the symbols are uniformly distributed.

To check that the strategy for optimizing the linear combination provided in the example above results in a converging random distribution, we will perform a simulation of the optimization as described in the example using $100 space.nobreak 000$ simulated normal distributed values as realizations of the standard normal distribution with the parameters $mu = 0$ and $sigma = 1$.

@fig:bach_instability shows various histograms of the vector $bold(z)_"opt"$ after different iterations.
Even though the overall shape of the distribution comes close to our goal of moving the input values away from the quantizer bounds $bold(b)$, the distribution itself does not converge to one specific, final shape. 
It seems that the resulting distributions for each iteration oscillate in some way, since the distributions for iterations $7$ and $25$ have the same shape.
However the distribution seems to be chaotic and thus does not seem suitable for further quantization.

#figure(
grid(
  columns: (1fr, 1fr),
  rows: (2),
  [//#figure(
  #image("../graphics/plots/bach/instability/frame_1.png")
  #v(-2em)
  //)
  Iteration 1],
  [//#figure(
  #image("../graphics/plots/bach/instability/frame_7.png")
  #v(-2em)
  //)
  Iteration 7],
  [//#figure(
  #image("../graphics/plots/bach/instability/frame_18.png")
  #v(-2em)
  //)
  Iteration 18],
  [//#figure(
  #image("../graphics/plots/bach/instability/frame_25.png")
  #v(-2em)
  //)
  Iteration 25]
),
  caption: [Probability distributions for various iterations]
)<fig:bach_instability>


=== Center Point Approximation 

For that reason, we will now propose a different strategy to find the weights for the optimal linear combination $z_"opt"$.
Instead of defining the desired outcome of $z_"opt"$ as the greatest distance to the nearest quantizer decision threshold, we will define a vector $bold(cal(o)) = [cal(o)_1, cal(o)_2 ..., cal(o)_(2^M)]$ containing the optimal values that we want to approximate with $z$.
Considering a M-bit quantizer with $2^M$ steps, we can define the values of $bold(cal(o))$ as the center points of these quantizer steps.
Its cardinality is $2^M$.
It has to be noted, that $bold(cal(o))$ consists of optimal values that we may not be able to exactly approximate using a linear combination based on weights and our given input values. 

We can find the optimal linear combination $z_"opt"$ by finding the minimum of all distances to all optimal points defined in $bold(cal(o))$.
The matrix that contains the distances of all linear combinations $bold(z)$ to all optimal points $bold(cal(o))$ is defined as: $bold(cal(A))$ with its entries $a_"ij" = abs(z_"i" - o_"j")$.\
$z_"opt"$ can now be defined as the minimal value in $bold(cal(A))$:
$
z_"opt" = op("min")(bold(cal(A)))
= op("min")(mat(delim: "[", a_("00"), ..., a_("i0"); dots.v, dots.down, " "; a_"0j", " ", a_"ij" )).
$
#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  include("../pseudocode/bach_find_best_appr.typ")
)<alg:best_appr>

@alg:best_appr shows a programmatic approach to find the set of weights for the best approximation. The algorithm returns a tuple consisting of the weight combination $bold(h)$ and the resulting value of the linear combination $z_"opt"$.

Because the superposition of different linear combinations of normal distributions corresponds to a Gaussian Mixture Model, finding the ideal set of points $bold(cal(o))$ analytically is impossible.

Instead, we will first estimate $bold(cal(o))$ based on the normal distribution parameters after performing multiple convolutions with the input distribution $X$.
The parameters of a multiple convoluted normal distribution is defined as: 
$
sum_(i=1)^(n) cal(N)(mu_i, sigma_i^2) tilde cal(N)(sum_(i=1)^n mu_i, sum_(i=1)^n sigma_i^2),
$
while $n$ defines the number of convolutions performed @schmutz.

With this definition, we can define the parameters of the probability distribution $Z$ of the linear combinations $z$ based on the parameters of $X$, $mu_X$ and $sigma_X$: 

$
Z(mu_Z, sigma_Z^2) = Z(sum_(i=1^n) mu_X, sum_(i=1)^n sigma_X^2)
$<eq:z_dist_def>

The parameters $mu_Z$ and $sigma_Z$ allow us to apply an inverse CDF on a multi-bit quantizer $cal(Q)(2, tilde(x))$ defined in the tilde-domain. 
Our initial values for $bold(cal(o))_"first"$ can now be defined as the centers of the steps of the transformed quantizer function $cal(Q)(2, x)$.
These points can be found easily but for the outermost center points whose quantizer steps have a bound $plus.minus infinity$.\
However, we can still find these two remaining center points by artificially defining the outermost bounds of the quantizer as $frac(1, 2^(2 dot M))$ and $frac((2^(2 dot M))-1, 2^(2 dot M))$ in the tilde-domain and also apply the inverse CDF to them.

#scale(x: 90%, y: 90%)[
#figure(
  include("../graphics/quantizers/two-bit-enroll-real.typ"),
  caption: [Quantizer for the distribution resulting a triple convolution with distribution parameters $mu_X=0$ and $sigma_X=1$ with marked center points of the quantizer steps]
)<fig:two-bit-enroll-find-centers>]

We can now use an iterative algorithm that alternates between optimizing the quantizing bounds of $cal(Q)$ and our vector of optimal points $bold(cal(o))_"first"$.

#figure(
    kind: "algorithm",
    supplement: [Algorithm],
    include("../pseudocode/bach_1.typ")
)<alg:bach_1>

We can see both of these alternating parts in @alg:bach_1_2[Lines] and @alg:bach_1_3[] of @alg:bach_1. 
To optimize the quantizing bounds of $cal(Q)$, we will sort the values of all the resulting linear combinations $bold(z)_"opt"$ in ascending order. 
Using the inverse @ecdf defined in @eq:ecdf_inverse, we can find new quantizer bounds based on $bold(z)_"opt"$ from the first iteration.
These bounds will then be used to define a new set of optimal points $bold(cal(o))$ used for the next iteration. 
During every iteration of @alg:bach_1, we will store all weights $bold(h)$ used to generate the vector for optimal linear combinations $bold(z)_"opt"$. 

We can also use a simulation here to check the convergence of the distribution $Z$ using the same input values and quantizer configurations as in @sect:instability_sim.

#figure(
  grid(
    columns: (2),
    [#figure(
      image("./../graphics/plots/bach/stability/frame_1.png"),
      //caption: [Iteration 1]
    )
    #v(-2em)
    Iteration 1],
    [#figure(
      image("./../graphics/plots/bach/stability/frame_25.png")
    )
    #v(-2em)
    Iteration 25],
  ),
  caption: [Probability distributions for the first and 25th iteration of the center point approximation method]
)<fig:bach_stability>

Comparing the distributions in @fig:bach_stability, we can see that besides a closer arrangement the overall shape of the probability distribution $Z$ converges to a stable distribution representing the original estimated distribution $Z$ through @eq:z_dist_def through smaller normal distributions. 

The output of @alg:bach_1 is the vector of optimal weights $bold(h)_"opt"$.
$bold(h)_"opt"$ can now be used to complete the enrollment phase and quantize the values $bold(z)_"opt"$.

To perform reconstruction, we can calculate the same linear combination used during enrollment with the generated helper-data and the new PUF readout measurements.
We can lower the computational complexity of this approach by using the assumption that $X$ are i.i.d.. 
The end result of $bold(cal(o))$ can be calculated once for a specific device series and saved in the ROM of. 
During enrollment, only the vector $bold(h)_"opt"$ has to be calculated.

=== Helper-data size and amount of addends

The amount of helper data is directly linked to the symbol bit width $M$ and the amount of addends $N$ used in the linear combination.
Because we can set the first helper data bit $h_1$ of a linear combination to $1$ to omit the random choice, the resulting extracted bit to helper data bit ratio $cal(r)$ can be defined as $cal(r) = frac(M, N-1)$, whose equation is similar tot he one we used in the @smhdt analysis.

== Experiments 
To test our implementation of @bach using the prior introduced center point approximation we conducted a similar experiment as in @sect:smhd_experiments.
However, we have omitted the analysis over different temperatures for the enrollment and reconstruction phase here, as the behaviour of @bach corresponds to that of @smhdt in this matter.
As in the S-Metric analysis, the resulting dataset consists of the bit error rates of various configurations with quantization symbol widths of up to $4$ bits evaluated with up to $10$ addends for the linear combinations.  

== Results & Discussion 

We can now compare the #glspl("ber") of different @bach configurations.

/*#figure(
  table(
    columns: (9),
    align: center + horizon, 
    inset: 7pt,
    [*BER*],[N=2],[N=3],[N=4],[N=5], [N=6], [$N=7$], [$N=8$], [$N=9$],
    [$M=1$], [$0.09$], [$0.09$], [$0.012$], [$0.018$], [$0.044$], [$0.05$], [$0.06$], [$0.07$],
    [$M=2$], [$0.03$], [$0.05$], [$0.02$], [$0.078$], [$0.107$], [$0.114$], [$0.143$], [$0.138$],
    [$M=3$], [$0.07$], [$0.114$], [$0.05$], [$0.15$], [$0.2$], [$0.26$], [$0.26$], [$0.31$],
    [$M=4$], [$0.13$], [$0.09$], [$0.18$], [$0.22$], [$0.26$], [$0.31$], [$0.32$],[$0.35$]
  ),
  caption: [#glspl("ber") of different @bach configurations]
)<tab:BACH_performance>*/


#figure(
  kind: table,
  tablex(
    columns: 9,
    align: center + horizon,
    inset: 7pt,
    // Color code the table like a heat map
    
   map-cells: cell => {
  if cell.x > 0 and cell.y > 0 {
    cell.content = {
      let value = float(cell.content.text)
      let text-color = if value >= 0.3 {
        red.lighten(15%)
      } else if value >= 0.2 {
        red.lighten(30%)
      } else if value >= 0.15 {
        orange.darken(10%)
      } else if value >= 0.1 {
        yellow.darken(13%)      } else if value >= 0.08 {
        yellow
      } else if value >= 0.06 {
        olive
      } else if value >= 0.04 {
        green.lighten(10%)
      } else if value >= 0.02 {
        green
      } else {
        green.darken(10%)
      }
      cell.fill = text-color
      strong(cell.content)
    }
  }
  cell
},

    [*BER*],[N=2],[N=3],[N=4],[N=5], [N=6], [$N=7$], [$N=8$], [$N=9$],
    [$M=1$], [0.01], [0.01], [0.012], [0.018], [0.044], [0.05], [0.06], [0.07],
    [$M=2$], [0.03], [0.05], [0.02], [0.078], [0.107], [0.114], [0.143], [0.138],
    [$M=3$], [0.07], [0.114], [0.05], [0.15], [0.2], [0.26], [0.26], [0.31],
    [$M=4$], [0.13], [0.09], [0.18], [0.22], [0.26], [0.31], [0.32],[0.35],
    [$M=5$], [0.29], [0.21], [0.37], [0.31], [0.23], [0.23], [0.19], [0.15],
    [$M=6$], [0.15], [0.33], [0.15], [0.25], [0.21], [0.23], [0.19], [0.14]
    
  ),
  caption: [#glspl("ber") of different @bach configurations]
)<tab:BACH_performance>

@tab:BACH_performance shows the #glspl("ber") of @bach configurations with $N$ addends and extracting $M$ bits out of one input value $z$.
The first interesting property we can observe, is the caveat @bach produces for the first three bit combinations $M = 1, 2 "and" 3$ at around $N = 3$ and $N = 4$. 
At these points, the @ber experiences a drop followed by a steady rise again for higher numbers of $N$. 
//This observation could be explained through the fact that the higher $N$ is chosen, the shorter the resulting key, since $N$ divides out values available for quantization by $N$. 
If $M$ is generally chosen higher, @bach seems to return unstable results, halving the @ber as $N$ reaches $9$ for $M=5$ but showing no real improvement for various addends if $M=6$.

We can also compare the performance of @bach using the center point approximation approach with the #glspl("ber") of higher order bit quantizations that don't use any helper data.

#figure(
  table(
    columns: 7,

    [*M*], [$1$], [$2$], [$3$], [$4$], [$5$], [$6$],
    [*BER*], [$0.013$], [$0.02$], [$0.04$], [$0.07$], [$0.11$], [$0.16$]
  ),
  caption: [#glspl("ber") for higher order bit quantization without helper data ]
)<tab:no_hd>

Unfortunately, the comparison of #glspl("ber") of @tab:no_hd[Tables] and @tab:BACH_performance[] shows that our current realization of @bach either ties the @ber in @tab:no_hd or is worse.
Let's find out why this happens.

==== Discussion

If we take a step back and look at the performance of the optimized single-bit sign-based quantization process of @sect:1-bit-opt, we can compare the following #glspl("ber"):

#figure(
  table(
    columns: 2,
    [*No helper data*], [$0.013$],
    [*With helper data using greatest distance*],[$0.00052$],
    [*With helper data using center point approximation*], [$0.01$]

  ), 
  caption: [Comparison of #glspl("ber") for the single-bit quantization process with and without helper data]
)<tab:comparison_justification>

As we can see in @tab:comparison_justification, generating the helper data based on the original idea where @eq:optimization is used improves the @ber of the single-bit quantization by approx. $96%$.
The probability distributions $Z$ of the two different realizations of @bach -- namely the distance maximization strategy and the center point approximation -- give an indication of this discrepancy: 

#figure(
grid(
  columns: (2),
  [#figure(
    image("../graphics/plots/bach/compare/bad.png")
  )
  #v(-2em)
  Center point approximation],
  [#figure(
    image("../graphics/plots/bach/compare/good.png")
  )
  #v(-2em)
  Distance maximization],
),
  caption: [Comparison of the histograms of the different strategies to obtain the optimal weights for the single-bit case]
)<fig:compar_2_bach>

@fig:compar_2_bach shows the two different probability distributions. 
We can observe that using a vector of optimal points $bold(cal(o))$ results in a more narrow distribution for $Z$ than just maximizing the linear combination to be as far away from $x=0$ as possible. 
This difference in the shape of both distributions seem to be the main contributor to the fact that the optimization using center point approximation yields no improvement for the quantization process. 
Unfortunately, we were not able define an algorithm translating this idea to a higher order bit quantization for which the resulting probability distribution $Z$ converges.

Taking a look at the unstable probability distributions issued by the bound distance maximization strategy in @fig:bach_instability, we can get an idea of what kind of distribution a @bach algorithm should achieve. 
While the inner parts of the distributions do not overlap with each other like in the stable iterations shown in @fig:bach_stability, the outermost values of these distributions resemble the shape of what we achieved using the distance maximization for a single-bit optimization.
These two properties could -- if the distribution converges -- result in far better #glspl("ber") for higher order bit quantization, as the comparison in @tab:comparison_justification indicates.
