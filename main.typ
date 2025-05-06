#import "lab-report.typ": lab-report

// create title page and initialize all of the formating
#show: lab-report.with(
  title: "Heat Pump",
  authors: ("Raul Wagner", "Martin Kronberger"),
  supervisor: "Someone",
  groupnumber: "301",
  date: datetime(day: 8, month: 5, year: 2025),
)

#set heading(numbering: "1.1")

= Some heading
