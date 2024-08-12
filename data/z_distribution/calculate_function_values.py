import csv
import numpy as np
import math

with open('z_distribution.csv', "w") as csvfile:
    writer = csv.writer(csvfile)
    for i in np.linspace(-10, 10, 1000): 
        calculation = 2/math.sqrt(math.pi) * math.exp(-(i**2)/4) * math.erf(i/2) 
        if i < 0:
            calculation = calculation * -1
        writer.writerow([i, calculation])
