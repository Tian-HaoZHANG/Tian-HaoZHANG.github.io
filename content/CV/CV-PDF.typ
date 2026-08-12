// 你可以在文件名包含 "PDF" 的文件中编写正常的 PDF 文档
// 这些文件会被自动编译为 PDF 文件，然后你就可以通过链接在访问
// 注意：目标是 PDF 的 Typst 文件中不能使用 `#show: template` 和来自 `tufted` 的命令
// 注意网页样式与 PDF 样式无关；此文件只控制 pdf 的显示效果

#import "@preview/citegeist:0.3.1": load-bibliography
#set page(paper: "a4")
#show link: underline //网址#link("")加下划线
#show link: set text(fill: rgb(0, 0, 255))
#show ref: set text(fill: rgb(0, 0, 255))

= Tian-Hao Zhang (张天昊)
#text(
  weight: "regular",
  size: 0.9em,
)[A PhD student majoring in space plasma physics at Peking University, Beijing, China]

Website: #link("https://tian-haozhang.github.io/")
#h(3em)
Email: #link("mailto:thzhang@stu.pku.edu.cn")

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
}
*/
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
