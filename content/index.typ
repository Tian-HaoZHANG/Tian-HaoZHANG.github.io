#import "../config.typ": template, tufted
#show: template

// tufted.margin-note 可以让你在边栏中放置内容
// 宽大的边栏是 tufte 样式的特点，将注释放于其中并与正文并排，便于对照
#tufted.margin-note({
  image("imgs/kayamori.jpg")
})

#tufted.margin-note[
  Kayamori Ruka
]

Note: This page is under construction.


= Tufted Blog Template

这是一个基于 #link("https://typst.app/")[Typst] 和 #link("https://github.com/vsheg/tufted")[Tufted] 的静态网站构建模板，手把手教你搭建简洁、美观的个人博客、作品集和简历设计。

#figure(image("imgs/aoi&kayamori.jpg"), caption: [Erika Aoi with Kayamori Ruka.])

我编写了丰富的文档来帮助你编写页面和部署网站，你可以在 #link("/Docs/")[Docs] 页看到这些文档。

== 样式特点

#link("https://edwardtufte.github.io/tufte-css/")[*Tufte 样式*] 源于数据可视化大师 Edward Tufte 的设计理念，主张“内容至上”与极简主义，力求去除一切视觉上的干扰信息。其最鲜明的特点是采用*宽大的侧边栏布局*，将注释、参考文献和图表直接并排展示在正文旁，取代了传统的脚注或尾注；配合优雅的*衬线字体*与*类纸张背景*，它在数字屏幕上复刻了如经典学术著作般清晰、优雅、沉浸的深度阅读体验。
