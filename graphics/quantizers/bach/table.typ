#import "@preview/tablex:0.0.8": tablex, rowspanx, colspanx

#grid(
columns: (10fr, 0.0000000001fr, 1fr),
[
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
)],
[],
[#figure(
  table(
    columns: 1,
    inset: 7pt,

    [*BER*], [$0.013$], [$0.02$], [$0.04$], [$0.07$], [$0.11$], [$0.16$]
  ),
)])
