#import "../index.typ": template, tufted
#show: template.with(
  title: "Tian-Hao Zhang (张天昊)",
  description: "CV of Tian-Hao Zhang (张天昊)",
  lang: "en",
)
#import "@preview/citegeist:0.3.1": load-bibliography

= Curriculum Vitae

#tufted.margin-note[
  A PhD student majoring in space plasma physics\
  \
  Institute of Space Physics and Applied Technology, Peking University, Beijing, China\
  \
  Email: #link("mailto:thzhang@stu.pku.edu.cn")\
  \
  Github: #link("https://github.com/Tian-HaoZHANG")
]

#link("CV-PDF.pdf")[[Click here for a PDF version]]

I am Tian-Hao Zhang (张天昊), a PhD student at Institute of Space Physics and Applied Technology, Peking University, China, supervised by Professor Xu-Zhi Zhou (周煦之). I recently completed my bachelor's degree in general physics.

My research examines space plasma physics and focus on the plasma dynamics in the terrestrial magnetosphere. Currently, I investigate cross-scale couplings among wave modes in the solar wind plasma, using MMS data and kinetic simulations. I collaborate with Qiu-Gang Zong (宗秋刚)’s research group on magnetospheric physics.

I aim to uncover the coupling mechanisms between mesoscale and macroscale processes in the magnetosphere, and accomplish something interesting and/or influential. I intend to transition toward industry after my PhD. I welcome conversations with colleagues who share interests in space plasma physics.


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
