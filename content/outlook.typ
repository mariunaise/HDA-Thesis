= Conclusion and Outlook

During the course of this work, we took a closer look at an already introduced @hda, @smhdt and provided a concrete realization.
Our experiments showed that after a certain point, using more metrics $S$ won't improve the @ber any further as they behave asymptotically for $S arrow infinity$.
Furthermore, we concluded that for higher choices of the symbol width $M$, @smhdt will not be able to improve on the @ber, as the initial error is too high.
An interesting addition to our analysis provided the improvement of Gray-coded labelling for the quantizer as this resulted in an improvement of $approx 30%$. 

Going on, we introduced the idea of a new @hda which we called Boundary Adaptive Clustering with Helper data @bach. 
Here we aimed to utilize the idea of moving our initial @puf measurement values away from the quantizer bound to reduce the @ber using weighted linear combinations of our input values. 
Although this method posed promising results for a sign-based quantization yielding an improvement of $approx 96%$ in our testing, finding a good approach to generalize this concept turned out to be difficult. 
The first issue was the lack of an analytical description of the probability distribution resulting from the linear combinations. 
We accounted for that by using an algorithm that alternates between defining the quantizing bounds using an @ecdf and optimizing the weights for the linear combinations based on the found bounds.
The initial loose definition to find ideal linear combinations which maximize the distance to their nearest quantization bounds did not result in a stable probability distribution over various iterations.
Thus, we proposed a different approach to approximate the linear combination to the centers between the quantizing bounds. 
This method resulted in a stable probability distribution, but did not provide any meaningful improvements to the @ber in comparison to not using any helper data at all. 

Future investigations of the @bach idea might find a solution to the convergence of the bound distance maximization strategy.
Since the vector of bounds $bold(b)$ is updated every iteration of @bach, a limit to the deviation from the previous position of a bound might be set.
Furthermore, a recursive approach to reach higher order bit quantization inputs might also result in a converging distribution.
If we do not want to give up the approach using a vector of optimal points $bold(cal(o))$ as in the center point approximation, a way may be found to increase the distance between all optimal points $bold(cal(o))$ to achieve a better separation for the results of the linear combinations in every quantizer bin.

If a converging realization of @bach is found, using fractional weights instead of $plus.minus 1$ could provide more flexibility for the outcome of the linear combinations. 

Ultimately, we can build on this in the future and provide a complete key storage system using @bach or @smhdt to improve the quantization process. 

But in the end, the real quantizers were the friends we made along the way. 
