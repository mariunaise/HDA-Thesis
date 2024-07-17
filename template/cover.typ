#import "colour.typ": *

#let cover_page(
  title: "",
  author: "",
  chair: "",
  school: ""
) = {
  set text(
    font: "TUM Neue Helvetica"
  )

  set page(
    paper: "a4",
    margin: (
      top: 3cm,
      bottom: 1cm,
      x: 1cm,
    ),
    header: [
      #grid(
        columns: (1fr, 1fr),
        rows: (auto),
        text(
          fill: tum_blue,
          size: 8pt,
          [#chair \ #school \ Technical University of Munich]
        ),
        align(bottom + right, image("resources/TUM_Logo_blau.svg", height: 50%))
      )
    ],
    footer: []
  )

  v(1cm)

  set align(top + left)
  text(size: 24pt, [*#title*])

  v(3cm)

  text(fill: tum_blue, size: 17pt, [*#author*])
  
  set align(bottom + right)
  image("resources/TUM_Tower.png", width: 60%)
}
