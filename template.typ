// This function gets your whole document as its `body`.
#let template(
  // The Assignment's title.
  title: [Assignment Title],
  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (),
  // The assignment's running header
  header: [Assignment Header],
  // The assignment's abstract. Can be omitted if you don't have one.
  abstract: none,
  // A list of index terms to display after the abstract.
  index-terms: (),
  // The article's paper size. Also affects the margins.
  paper-size: "a4",
  // The path to a bibliography file if you want to cite some external
  // works.
  bibliography-file: none,
  // The assignments's content.
  body,
) = {
  // Set document metadata.
  set document(title: title, author: authors.map(author => author.name))

  // Set the body font.
  set text(font: "STIX Two Text", size: 10pt)

  // Configure the page.
  set page(
    paper: paper-size,
    // The margins depend on the paper size.
    margin: if paper-size == "a4" {
      (x: 41.5pt, top: 80.51pt, bottom: 89.51pt)
    } else {
      (
        x: (50pt / 216mm) * 100%,
        top: (55pt / 279mm) * 100%,
        bottom: (64pt / 279mm) * 100%,
      )
    },
    header: header,
    numbering: "1/1",
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)", supplement: [])
  show math.equation: set block(spacing: 0.65em)

  // Configure figures and tables.
  set figure(supplement: [])
  show figure: it => {
    set text(8pt)
    set align(center)
    if it.kind == image [
      #box[
        #it.body
        #v(10pt, weak: true)
        Fig#it.caption
      ]
    ] else if it.kind == table [
      #box[
        Table#it.caption
        #v(10pt, weak: true)
        #it.body
      ]
    ] else [
      ...
    ]
  }

  // Configure appearance of equation references
  show ref: it => {
    if it.element != none and it.element.func() == math.equation {
      // Override equation references.
      link(
        it.element.location(),
        numbering(
          it.element.numbering,
          ..counter(math.equation).at(it.element.location()),
        ),
      )
    } else {
      // Other references as usual.
      it
    }
  }

  // Configure Tables
  set table(stroke: 0.5pt)
  show table: set text(8pt)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "I.A.1.")
  show heading: it => {
    // Find out the final number of the heading counter.
    let loc = it.location()
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(10pt, weight: 400)
    if it.level == 1 [
      // First-level headings are centered smallcaps.
      // We don't want to number of the acknowledgment section.
      #let is-ack = it.body in ([Acknowledgment], [Acknowledgment])
      #set align(center)
      #set text(if is-ack {
        10pt
      } else {
        12pt
      })
      #show: smallcaps
      #v(20pt, weak: true)
      #if it.numbering != none and not is-ack {
        numbering("I.", deepest)
        h(7pt, weak: true)
      }
      #it.body
      #v(13.75pt, weak: true)
    ] else if it.level == 2 [
      // Second-level headings are run-ins.
      #set par(first-line-indent: 0pt)
      #set text(style: "italic")
      #v(10pt, weak: true)
      #if it.numbering != none {
        numbering("A.", deepest)
        h(7pt, weak: true)
      }
      #it.body
      #v(10pt, weak: true)
    ] else [
      // Third level headings are run-ins too, but different.
      #if it.level == 3 {
        numbering("1)", deepest)
        [ ]
      }
      _#(it.body):_
    ]
  }

  // Display the assignments's title.
  v(3pt, weak: true)
  align(center, text(22pt, title))
  v(8.35mm, weak: true)

  // Display the authors list.
  for i in range(calc.ceil(authors.len() / 4)) {
    let end = calc.min((i + 1) * 4, authors.len())
    let is-last = authors.len() == end
    let slice = authors.slice(i * 4, end)
    grid(columns: slice.len()
        * (
          1fr,
        ), gutter: 12pt, ..slice.map(author => align(
        center,
        {
          text(12pt, author.name)
          if "department" in author [
            \ #emph(author.department)
          ]
          if "organization" in author [
            \ #emph(author.organization)
          ]
          if "location" in author [
            \ #author.location
          ]
          if "email" in author [
            \ #link("mailto:" + author.email)
          ]
          if "git" in author [
            \ #author.git
          ]
        },
      )))

    if not is-last {
      v(16pt, weak: true)
    }
  }
  v(40pt, weak: true)

  // Start two column mode and configure paragraph properties.
  show: columns.with(2, gutter: 12pt)
  set par(justify: true, first-line-indent: 1em, spacing: 0.65em)

  // Display abstract and index terms.
  if abstract != none [
    // #set par(leading: 0.5em)
    #set text(weight: 700, size: 9pt)
    #h(1em) _Abstract_---#abstract

    #if index-terms != () [
      #v(9pt)
      #set text(weight: 700, size: 9pt, style: "italic")
      #h(1em)_Index terms_---#index-terms.join(", ")
    ]
    #v(2pt)
  ]

  // Display the assignments's contents.
  body

  // Display bibliography.
  if bibliography-file != none {
    show bibliography: set text(8pt)
    bibliography(
      bibliography-file,
      title: text(10pt)[References],
      style: "ieee",
    )
  }
}
