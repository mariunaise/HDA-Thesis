#import "@preview/cetz:0.2.2"
#import "@preview/fletcher:0.5.1"
#import "@preview/gentle-clues:0.9.0"
#import "@preview/glossarium:0.4.1": *
#import "@preview/lovelace:0.3.0"
#import "@preview/tablex:0.0.8"
#import "@preview/unify:0.6.0"
#import "@preview/quill:0.3.0"
#import "@preview/equate:0.2.0": equate
#import "@preview/drafting:0.2.0": *


#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(1.1)")

#show figure.where(
  kind: table
): set figure.caption(position: top)

#import "template/conf.typ": conf

#show: make-glossary

#set document(title: "Towards Efficient Helper Data Algorithms for Multi-Bit PUF Quantization", author: "Marius Drechsler")


#show: doc => conf(
  title: "Towards Efficient Helper Data Algorithms for Multi-Bit PUF Quantization",
  author: "Marius Drechsler",
  chair: "Chair for Security in Information Technology",
  school: "School of Computation, Information and Technology",
  degree: "Bachelor of Science (B.Sc.)",
  examiner: "Prof. Dr. Georg Sigl",
  supervisor: "M.Sc. Jonas Ruchti",
  submitted: "30.08.2024",
  doc
)
#set page(footer: locate(
  loc => if calc.even(loc.page()) {
    align(right, counter(page).display("1"));
  } else {
    align(left, counter(page).display("1"));
  }
  ))
#include "content/introduction.typ"
#include "content/SMHD.typ"
#include "content/BACH.typ"
#include "content/outlook.typ"

#include "glossary.typ"

#counter(heading).update(0)
#bibliography("bibliography.bib", style: "ieee")

