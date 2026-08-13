#import "../index.typ": template, tufted
#show: template.with(
  title: "Essay",
  description: "An essay (short blog) example",
)


= Essay

//中文博客样例可参考 #link("https://yousa-mirage.github.io/Blog")[我的个人网站]。
== 2026

#tufted.blog-entry(
  date: datetime(year: 2026, month: 4, day: 8),
  path: "2026-04-08-relations-between-partition-functions/",
  title: "统计力学中不同配分函数之间的关系",
)

#tufted.blog-entry(
  date: datetime(year: 2026, month: 2, day: 15),
  path: "2026-02-15-monochromatic-plane-EM-waves/",
  title: "On the monochromatic plane electromagnetic waves",
)

== 2025

#tufted.blog-entry(
  date: datetime(year: 2025, month: 10, day: 30),
  path: "2025-10-30-normal-distribution/",
  title: "Example from template",
)
