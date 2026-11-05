// `education[].area` beside `studyType`: it leads the score line
// (`Engineering · Distinction`), stands alone there without a score,
// and is the title when `studyType` is missing (not repeated below).

#import "/lib.typ": alta

#alta((
  basics: (name: "Jane Doe"),
  education: (
    (
      institution: "Trinity College Dublin",
      studyType: "Bachelor",
      area: "Engineering",
      score: "Distinction",
      startDate: "2014",
      endDate: "2018",
    ),
    (
      institution: "University College Cork",
      studyType: "Master",
      area: "Data Science",
      startDate: "2018",
      endDate: "2019",
    ),
    (
      institution: "Open University",
      area: "Philosophy",
      score: "Merit",
      courses: ("Logic", "Ethics"),
    ),
  ),
))
