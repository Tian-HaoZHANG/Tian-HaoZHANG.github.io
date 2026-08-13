#import "../index.typ": template, tufted
#show: template.with(
  title: "Essay",
  description: "An essay (short blog) example",
)


= Essay

//中文博客样例可参考 #link("https://yousa-mirage.github.io/Blog")[我的个人网站]。

== 2025

#tufted.blog-entry(
  date: datetime(year: 2025, month: 10, day: 30),
  path: "2025-10-30-normal-distribution/",
  title: "Normal Distribution",
)
