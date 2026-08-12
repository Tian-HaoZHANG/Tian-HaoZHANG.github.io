#import "../index.typ": template, tufted
#show: template.with(
  title: "Tian-Hao Zhang (张天昊)",
  description: "CV of Tian-Hao Zhang (张天昊)",
  lang: "en",
)
#import "@preview/citegeist:0.3.1": load-bibliography





= Tian-Hao Zhang (张天昊)

#tufted.margin-note[
  A PhD student majoring in space plasma physics at Peking University, Beijing, China \
  Website: #link("https://tian-haozhang.github.io/")\
  Email: #link("mailto:thzhang@stu.pku.edu.cn")
]

#link("CV-PDF.pdf")[[Click here for a PDF version]]

Research in space plasma physics, with a focus on the dynamics concerning with planetary magnetospheres.

/*== Experience

- *1983--Present*: Founder & Publisher, Graphics Press. Independent publishing house specializing in information design and data visualization.
- *1977--1999*: Professor Emeritus, Yale University. Departments of Political Science, Statistics, and Computer Science.
- *1967--1977*: Instructor, Princeton University. Woodrow Wilson School of Public and International Affairs.



== Research Contributions

Development of sparklines, a method for embedding high-resolution data graphics within text, and formulation of the data-ink ratio as a quantitative measure of graphical efficiency.

== Books

#{
  let bib = load-bibliography(read("books.bib"))
  for item in bib.values().rev() [
    #let data = item.fields
    - #strong(data.year): #emph(data.title)
  ]
}*/

== Papers

#{
  let bib = load-bibliography(read("papers.bib"))
  for item in bib.values().rev() [
    #let data = item.fields
    - #data.author, "#data.title," #emph(data.journal), #data.year. DOI: #link(data.url)[#data.doi]
  ]
}


== Education

- BS in Physics: Peking University (2026).
