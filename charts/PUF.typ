#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#import fletcher.shapes: diamond

#diagram(
  node-stroke: 1pt,
  edge-stroke: 1pt,
  //node-inset: 2pt,
  node((0,0), [PUF], corner-radius: 2pt, name: <PUF>),
  edge(<PUF>, <init_quant>, "->", $nu$),
  node((1,0), [Initial quantization], name: <init_quant>, width: 10em),
  edge(<init_quant>, <encod>, "->", $k$),
  node((2,0), [Encoding], name: <encod>, width: 8em),
  node((1,1), [Helper data\ generation], name: <quant_hd>, width: 10em),
  edge(<init_quant>, <quant_hd>, "->"),
  node((2.25, -0.5), [Enrollment], name: <enrollment_node>, stroke: none),
  node(enclose: (<init_quant>, <encod>, <enrollment_node>), stroke: (dash: "dashed"), inset: 10pt),
  node((0, 2), [PUF], corner-radius: 2pt, name: <PUF2>),
  node((1, 2), [Repeated quantization], name: <quant2>),
  node((2, 2), [Error correction], name: <ecc>),
  node((3, 1), [$kappa = kappa^*$?],name:  <result>),
  node((2, 1), [Error correction helper data], name: <ecc_hd>, width: 8em),
  node((2.25, 2.5), [Reconstruction], stroke: none, name: <reconstruction_node>),
  node(enclose: (<quant2>, <ecc>, <reconstruction_node>), stroke: (dash: "dashed"), inset: 10pt),

  edge(<quant_hd>, <quant2>, "->", $h$),
  edge(<PUF2>, <quant2>, "->", $nu^*$),
  edge(<quant2>, <ecc>, "->", $k^*$),
  edge(<ecc_hd>, <ecc>, "->"),
  edge(<encod>, "r,d", "->", $kappa$, label-pos: 0.3),
  edge(<ecc>, "r,u", "->", $kappa^*$, label-pos: 0.4),
  edge(<encod>, <ecc_hd>, "->")
  

)
