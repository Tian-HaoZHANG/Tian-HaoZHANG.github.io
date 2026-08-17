#import "../index.typ": template, tufted
#import "@preview/lilaq:0.6.0" as lq
// convinent math operations
#import "../../../mod.typ": *
// 如需生成 RSS feed，必须填写 title、description 和 date 元数据

#let title = "Saddle point method in complex plane"
#show: template.with(
  title: title,
  description: "Summary of the saddle point method.",
  date: datetime(year: 2026, month: 6, day: 7),
  lang: "en",
)

= #title
Summary of the saddle point method @website:鞍点近似法及其应用.


The saddle point method is also known as the method of _steepest descent_ or _stationary phase_. It estimates the asymptotic behavior of an integral of the following form
$ I(lambda) = integral_C dd(z) ee^(lambda S(z)), quad lambda in bb(R) $
as $lambda -> +infinity.$ Here, $C$ is a contour in the complex $z$ plane and $S$ is a holomorphic function.

In order to evaluate this integral, we deform $C$ such that it passes through the saddle points of $S$ (where $S'(z) = 0)$ in the steepest descent directions. The idea of the saddle point method is that, as $lambda -> +infinity,$ the main contribution to the integral comes from the neighborhood of the saddle points. For simplicity, let's assume that $S$ has only one saddle point $z = z_0;$ if $S$ has multiple saddle points, we need only to sum the contributions from each. Taylor expanding @book:Kardar-statistical-physics $S$ about $z_0$ and noting that the Gaussian profile has width $abs(z - z_0) = order(lambda^(-frac(1, 2, style: "horizontal"))),$ we have
$
  I(lambda) &= integral_C dd(z) exp(lambda S(z_0) + 1/2 lambda S''(z_0) (z - z_0)^2 + order(lambda (z - z_0)^3) + order(lambda (z - z_0)^4))\
  &= ee^(lambda S(z_0)) integral_C dd(z) exp(1/2 lambda S''(z_0) (z - z_0)^2) times (1 + order(lambda (z - z_0)^3) + order(lambda (z - z_0)^4)).
$

Now we need to determine the direction of the steepest descent. Let $z - z_0 = (rho/sqrt(lambda)) ee^(ii theta)$ and $S''(z_0) = abs(S''(z_0)) ee^(ii alpha),$ then the real part of the exponent
$
  "Re"(1/2 lambda S''(z_0) (z - z_0)^2) = 1/2 abs(S''(z_0)) rho^2 "Re" ee^(ii (2 theta + alpha)) = 1/2 abs(S''(z_0)) rho^2 cos(2 theta + alpha)
$
decreases most rapidly when $cos(2 theta + alpha) = -1,$ i.e., when $theta = plus.minus pi/2 - alpha/2 equiv theta_0$ @book:陈骝-plasma-waves. Choosing $C$ to pass through $z_0$ along the direction determined by the proper $theta = theta_0,$ we find
$
  I(lambda) &= ee^(lambda S(z_0)) ee^(ii theta_0)/sqrt(lambda) integral_bb(R) dd(rho) exp(-1/2 abs(S''(z_0)) rho^2) times (1 + order(1/sqrt(lambda)) cancel(rho^3) + order(1/lambda) rho^4)\
  &= sqrt((2pi)/(lambda abs(S''(z_0)))) ee^(ii theta_0 + lambda S(z_0)) (1 + order(1/lambda)).
$

In physical problems, one often encounter integrals of the following form
$ I(lambda) = integral_C dd(z) f(z) ee^(lambda S(z)) $
with $f$ being holomorphic. In this case, we may repeat the above derivation to obtain
$
  I(lambda) &= f(z_0) ee^(lambda S(z_0)) ee^(ii theta_0)/sqrt(lambda) integral_bb(R) dd(rho) exp(-1/2 abs(S''(z_0)) rho^2) times (1 + order(1/sqrt(lambda)) rho + order(1/lambda) rho^2) (1 + order(1/sqrt(lambda)) rho^3 + order(1/lambda) rho^4)\
  &= sqrt((2pi)/(lambda abs(S''(z_0)))) f(z_0) ee^(ii theta_0 + lambda S(z_0)) (1 + order(1/lambda)).
$


For more physical applications of the saddle point method, see @website:鞍点近似法及其应用 and @website:勒让德变换和拉普拉斯变换的关系.
#bibliography("refs.bib")
