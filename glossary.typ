#import "@preview/glossarium:0.4.1": print-glossary

#counter(heading).update(0)
#heading(numbering: none)[Glossary]

#print-glossary((
  (key: "hda", short: "HDA", plural: "HDAs", long: "helper data algorithm", longplural: "helper data algorithms"),
  (key: "cdf", short: "CDF", plural: "CDFs", long: "cumulative distribution function", longplural: "cumulative distribution functions"),
  (key: "ecdf", short: "eCDF", plural: "eCDFs", long: "empirical Cumulative Distribution Function", longplural: "empirical Cumulative Distribution Functions"),
  (key: "ber", short: "BER", plural: "BERs", long: "bit error rate", longplural: "bit error rates"),
  (key: "smhdt", short: "SMHD", plural: "SMHDs", long: "S-Metric Helper Data method"),
  (key: "puf", short: "PUF", plural: "PUFs", long: "physical unclonable function", longplural: "physical unclonale functions"),
  (key: "tmhdt", short: "TMHD", plural: "TMHDs", long: "Two Metric Helper Data method"),
  (key: "bach", short: "BACH", long: "Boundary Adaptive Clustering with Helper data")
))
