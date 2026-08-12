#import "../index.typ": template, tufted
#show: template.with(
  title: "Docs",
  description: "Docs",
)

#show link: underline//网址#link("")加下划线
#show link: set text(fill: rgb(0, 0, 255))
#show ref: set text(fill: rgb(0, 0, 255))

= Documents

- #link("website-config-en/", "Website Configuration")
- #link("typst-example-en/", "Typst Example")
- #link("github-deploy-en/", "GitHub Deployment")
- #link("custom-styling-en/", "Custom Styling")
- #link(
    "waves and instabilities in plasmas 20260810.pdf",
    "Liu Chen (陈骝)'s textbook《Waves and Instabilities in Plasmas》— retypesetted",
  )
