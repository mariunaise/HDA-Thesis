#import "colour.typ": *

#let title_page(
  title: "",
  author: "",
  chair: "",
  school: "",
  degree: "",
  examiner: "",
  supervisor: "",
  submitted: ""
) = {
  set text(
    font: "TUM Neue Helvetica",
    size: 10pt
  )

  set page(
    paper: "a4",
    margin: (
      top: 5cm,
      bottom: 3cm,
      x: 2cm,
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
        align(bottom + right, image("resources/TUM_Logo_blau.svg", height: 30%))
      )
    ],
    footer: []
  )

  v(1cm)

  set align(top + left)
  text(size: 24pt, [*#title*])

  v(3cm)

  text(fill: tum_blue, size: 17pt, [*#author*])

  v(3cm)

  [Thesis for the attainment of the academic degree]
  v(1em)
  [*#degree*]
  v(1em)
  [at the #school of the Technical University of Munich.]

  v(3cm)

  [*Examiner:*\ #examiner]
  v(0em)
  [*Supervisor:*\ #supervisor]
  v(0em)
  [*Submitted:*\ Munich, #submitted]
}
