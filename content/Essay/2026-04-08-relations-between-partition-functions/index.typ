#import "../index.typ": template, tufted
#import "@preview/lilaq:0.6.0" as lq
// convinent math operations
#import "../../../mod.typ": *
// 如需生成 RSS feed，必须填写 title、description 和 date 元数据

#let title = "统计力学中不同配分函数之间的关系"
#show: template.with(
  title: title,
  description: "一个神奇的观察：不同配分函数之间通过通过（类） Laplace 变换相联系。",
  date: datetime(year: 2026, month: 4, day: 8),
  lang: "en",
)

= #title
一个神奇的观察：不同配分函数之间通过通过（类） Laplace 变换相联系。 本文记号跟随 @book:Kardar-statistical-physics.

== 正则配分函数实质上是哈密顿量的特征函数

=== 特征函数的概念

概率论中，随机变量是可测空间 $(Omega, cal(F))$ 上的可测函数。在可测空间上给定概率测度 $P$ 后便可求期望。随机变量 $X$ 的特征函数定义为
$ tilde(p)(k) := rm(E) e^(-i k X), $
其中 $rm(E)$ 表示求期望。对连续型随机变量，特征函数 $tilde(p)$ 就是概率密度函数 $p$ 的 Fourier 变换 $ tilde(p)(k) = integral_bb(R) dd(x) e^(-i k x) p(x); $ 在这个意义上，可以说，特征函数是 Fourier 变换的某种推广。

=== 正则配分函数

统计力学给出可测空间 $(Omega = M, cal(F) = 2^(M))$ #footnote[$M$ 是系统的宏观状态，由一些宏观（热力学）参量确定 —— 系综就是众多宏观状态相同 (都是$M)$ 但微观状态 $mu$ 不同的系统的集合；$M$ 在经典统计力学中是（或者说，可以认同为）$6N$ 维相空间 $Gamma$ 的子空间，在量子统计力学中是系统量子态所在的 Hilbert 空间的子空间。]上的概率测度
$ P_M: 2^(M) & -> [0, 1]. $

对正则系综，$M = (T, bm(x), N),$ 这一概率测度在 $M subset 2^(M)$ 上的限制为
$
  p: M & -> [0, 1], \
    mu & |-> p(mu) = frac(e^(-beta cal(H)(mu)), Z, style: "horizontal"),
$
其中 $mu in M$ 表示系统的微观状态，$cal(H): Gamma -> bb(R)$ 是系统的哈密顿量，$beta = frac(1, k_B T, style: "horizontal"),$ 而
$ Z = sum_(mu in M) e^(-beta cal(H)(mu)) $ 是正则配分函数。


哈密顿量 $cal(H)$ 是概率空间 $(Omega = M, cal(F) = 2^(M), P_M)$ 上的随机#footnote[按定义，随机变量是可测空间上的可测函数，既不“随机”，也不是“变量”；实际上，它是一个确定的对应法则（函数），其取值的随机性完全来自于取样的随机性（即输入的自变量的随机性）。当我们只能对系统做出概率性的描述时（这时我们说系统处于 mixed state），哈密顿量就成为了随机变量。]变量，其特征函数按定义为

$
  tilde(p)_(cal(H))(k) & = rm(E) e^(-i k cal(H)) \
                       & = sum_(mu) p(mu) e^(-i k cal(H)(mu)) \
                       & = frac(1, Z) sum_(mu) e(-beta cal(H)(mu) - i k cal(H)(mu)) \
                       & = frac(Z(beta + i k), Z(beta)),
$
最后一行将配分函数写为 $Z(beta)$ 以强调其温度 $beta.$ 可见，正则配分函数实质上是哈密顿量的特征函数。


== 正则配分函数是态密度的 Laplace 变换

$
  Z (beta) & = sum_(mu) e^(-beta cal(H)(mu)) \
           & = sum_(epsilon) Omega(epsilon) e^(-beta epsilon) \
           & stretch(=)^"准连续" integral_bb(R) dd(epsilon) e^(-beta epsilon) g(epsilon),
$

其中第二个等号就是重新组织了一下求和（从对所有微观态的求和转变为对所有能量不同的态的求和，这时要乘上能级简并度 $Omega(epsilon)$），第三个等号在准连续情形将简并度替换为态密度 $Omega(epsilon) -> dd(epsilon) g(epsilon).$ 由于哈密顿量有下界，通过平移原点总可以把能量取成正的, 所以上式就是 Laplace 变换。这样，正则配分函数是态密度的 Laplace 变换；因此，可以说态密度是“微正则配分函数”。




== Gibbs 配分函数是正则配分函数的 Laplace 变换

$
  cal(Z) (bm(J)) & = sum_(mu, bm(x)) e^(beta bm(J) dot bm(x) - beta cal(H)(mu)) \
                 & = sum_(bm(x)) e^(beta bm(J) dot bm(x)) sum_(mu|bm(x)) e^(-beta cal(H)(mu)) \
                 & = sum_(bm(x)) e^(beta bm(J) dot bm(x)) Z(bm(x)),
$

其中 $sum_(mu|bm(x))$ 表示在固定 $bm(x)$ 的条件下对 $mu$ 求和；同样，这里写出了配分函数的自变量作为强调：Gibbs 配分函数的自变量是广义力 $bm(J),$ 正则配分函数则是广义坐标 $bm(x).$ 如果广义坐标的取值是连续的，上式就是 Laplace 变换；例如，对理想气体，我们有 $J = -p, x = V,$
$ cal(Z)(p) = integral_(0)^(+infinity) dif V e^(-beta p V) Z(V). $




== 巨配分函数是正则配分函数的 Z 变换

$
  cal(Q)(mu) & = sum_(mu_S) e^(beta mu N(mu_S) - beta cal(H)(mu_S)) \
             & = sum_(N=0)^(+infinity) e^(beta mu N) sum_(mu_S|N) e^(-beta cal(H)(mu_S)) \
             & = sum_(N=0)^(+infinity) e^(beta mu N) Z(N),
$

其中 $mu$ 是化学势，$mu_S$ 是系统的微观状态 $(S$ for “System”)；同样，这里写出了配分函数的自变量作为强调：巨配分函数的自变量是化学势 $mu,$ 正则配分函数则是粒子数 $N.$ 上式表明，巨配分函数是正则配分函数的 Z 变换。


#bibliography("refs.bib")
