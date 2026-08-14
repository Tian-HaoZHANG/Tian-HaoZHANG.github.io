#import "../index.typ": template, tufted
#import "@preview/lilaq:0.6.0" as lq
// convinent math operations
#import "../../../mod.typ": *
// 如需生成 RSS feed，必须填写 title、description 和 date 元数据

#let title = "积分区域的导数"
#let description = "通过将微分形式“拉回”处理积分区域的导数，并据此推导了连续介质力学中的连续性方程和磁冻结定理。"
#show: template.with(
  title: title,
  description: description,
  date: datetime(year: 2025, month: 11, day: 30),
  lang: "zh",
)

= #title
#description

连续介质力学中经常需要考虑张量场在物质体 $V_t$ 或物质面 $Sigma_t$ 上的积分，例如推导连续性方程需要考虑 $(dif/dif t) integral_V_t dif V rho,$ MHD中证明磁冻结需要考虑 $(dif/dif t) integral_Sigma_t dif bold(Sigma) dot bold(B).$ 然而，在Euler观点下，作为物质对象，$V_t$ 和 $Sigma_t$ 都是随时间变化的，求导时它们也有贡献。通过换元将积分变量（Euler坐标）换成Lagrange坐标，可以将积分区域的变化转移到被积函数中，从而只需要考虑被积函数的导数——“换元”实际上就是微分形式的拉回，上述做法可以用微分几何的语言清晰地写出。

== 微分几何复习
设$ phi: & M -> N, \
     & p |-> phi(p) $ 为光滑流形间的映射。这一映射自然地诱导出切空间之间的 push forward
$
  phi_*: & T_p M -> T_phi(p) N, \
         & v |-> phi_* v,
$
其中 $(phi_* v) (f) := v(f compose phi), forall f in cal(F)(N).$ 这一 push forward 进而自然地诱导出余切空间之间的 pull back
$
  phi^*: & T^*_phi(p) N -> T^*_p M, \
         & omega |-> phi^* omega,
$
其中$(phi^* omega) (v) := omega(phi_*v), forall v in T_p M.$ 更高阶张量之间的推拉可以类似地定义。

=== 坐标形式
设 $p in M$ 附近有局部坐标 ${xi^mu}, v = v^mu partial/(partial xi^mu),$ 且 $phi(p) in N$ 附近有局部坐标 ${x^nu}, omega = omega_mu dif x^mu;$ 映射$phi$ 的坐标表示为 $x^mu = x^mu (xi^nu).$ 可以写出 $phi_* v$ 和 $phi^* omega$ 在局部坐标下的形式：
$
  (phi_* v)(f) = v^mu (partial (f compose phi))/(partial xi^mu) = v^mu (partial f)/(partial x^nu) (partial x^nu)/(partial xi^mu)\
  => phi_* v = v^mu (partial x^nu)/(partial xi^mu) partial/(partial x^nu);\
  (phi^* omega)(v) = omega_nu dif x^nu (v^mu (partial x^sigma)/(partial xi^mu) partial/(partial x^sigma)) = v^mu omega_nu (partial x^sigma)/(partial xi^mu) delta^nu_sigma = v^mu omega_nu (partial x^nu)/(partial xi^mu)\
  => phi^* omega = omega_nu (partial x^nu)/(partial xi^mu) dif xi^mu.
$
对于次数更高的微分形式，例如 3 形式，类似地有
$
  phi^* omega = omega_(nu_1 nu_2 nu_3) (partial x^(nu_1))/(partial xi^(mu_1)) (partial x^(nu_2))/(partial xi^(mu_2)) (partial x^(nu_3))/(partial xi^(mu_3)) dif xi^(mu_1) dif xi^(mu_2) dif xi^(mu_3).
$
可见，所谓的“推拉”，其形式与坐标变换相同——只不过坐标变换是在单个流形上进行的，推拉是在两个流形之间；如果$phi$是微分同胚，则推拉实际上就是坐标变换。

Theorem: 设 $phi: M -> N$ 为保定向的微分同胚，则
$ integral_N omega = integral_M phi^* omega. $ <pullback_to_integrate>

== 积分区域的导数

在连续介质力学的应用中，取$ M & = t"时刻物质体所占的空间区域" K_t subset bb(R)^3, \
N & = t+s"时刻物质体所占的空间区域" K_(t+s) subset bb(R)^3, $连续介质在 $t+s$ 时刻相对 $t$ 时刻的“变形”由映射
$
  phi^t_s: & K_t -> K_(t+s), \
           & (x^mu) |-> (x_s^mu = x_s^mu (x^nu))
$
给出——由于 $K_t$ 和 $K_(t+s)$ 都是 $bb(R)^3$ 的子集，局部坐标 $x$ 和 $x_s$ 都可以整体地定义。假设 $phi^t_s$ 是微分同胚，因而 $phi^t_s$ 可以看成从Euler坐标 $x_s$ 到Lagrange坐标 $x$ 的坐标变换。\
@pullback_to_integrate 为我们对含参积分区域求导提供了方便：当需要对含参数 $s$ 的积分区域 $K_(t+s)$ 求导时，可以通过微分同胚 $phi^t_s: K_t -> K_(t+s)$ 将原积分化为不依赖于参数 $s$ 的另一区域 $K_t$ 上的积分#footnote[如果存在微分同胚 $phi_t^(0*): K_0 -> K_t,$ 则当然也可以直接拉回到 $t = 0$ 时刻的区域 $K_0$ 上积分。]，从而将求导转移到被积的微分形式上#footnote[由于积分对被积形式和积分区域都是线性的——积分是积分区域与被积形式之间的双线性配对，有Leibniz律 $lr(dif/dif s |)_(s = 0) integral_K_(t+s) omega(t+s) = lr(dif/dif s |)_(s = 0) integral_K_(t+s) omega(t) + integral_K_t (partial omega(t))/(partial t).$ 不妨设$omega$不依赖于 $s,$从而可以专注于积分区域改变的影响。]：
$
  lr(dv(, s)|)_(s = 0) integral_K_(t+s) omega & = lr(dv(, s)|)_(s = 0) integral_K_t phi_s^(t *) omega \
                                              & = integral_K_t lr(dv(, s)|)_(s = 0) phi_s^(t *) omega.
$
注意到 Lie 导数的定义 $cal(L)_X omega = lr(dv(phi.alt_s^* omega, s, style: "horizontal")|)_(s = 0)$（其中 ${phi.alt_s}_(s in bb(R))$ 是由矢量场 $X$ 生成的（局部）单参微分同胚群）与上式的类似性，我们自然希望能将 $phi^t_s$ 看成某个矢量场的以 $s$ 为参数的积分曲线（从而 $lr(dv(phi.alt_s^* omega, s, style: "horizontal")|)_(s = 0)$ 就是 $omega$ 关于该矢量场的 Lie 导数）。于是我们定义一个矢量场 $v_t in cal(X)(K_t)$:

$ v_t (p) := lr(dv(, s) |)_(s = 0) phi^t_s (p), p in K_t; $ <velocity_field>

这实际上就是 $t$ 时刻位于 $p$ 处的物质点在该时刻的速度的定义。而后
$
  lr(dv(, s)|)_(s = 0) integral_K_(t+s) omega &= integral_K_t lr(dv(, s)|)_(s = 0) phi_s^(t*) omega\
  &=: integral_K_t cal(L)_v_t omega\
  &=^"Cartan's magic formula" integral_K_t (i_v_t compose dif + dif compose i_v_t) omega\
  &=^"Stokes' theorem" integral_K_t i_v_t dif omega + integral_(partial K_t) i_v_t omega,
$
其中 $i_X$ 是内乘$ (i_X omega)(Y_1, Y_2, ..., Y_(n-1)) := omega(X, Y_1, Y_2, ..., Y_(n-1)), $
而 $dif$ 是外微分：设 $X = X^mu partial/(partial x^mu), omega = 1/n! omega_(mu_1 mu_2 ... mu_n) dif x^(mu_1) and dif x^(mu_2) and ... and dif x^(mu_n),$
则
$
  i_X omega &= 1/(n-1)! X^mu omega_(mu mu_2 mu_3 ... mu_n) dif x^(mu_2) and dif x^(mu_3) and ... and dif x^(mu_n),\
  dif omega &= 1/n! (partial omega_(mu_1 mu_2 ... mu_n))/(partial x^nu) dif x^nu and dif x^(mu_1) and dif x^(mu_2) and ... and dif x^(mu_n).
$

如果考虑被积形式也随参数变化，则以下公式成立
$
  dv(, t) integral_K_t omega(t) &= integral_K_t ((partial omega(t))/(partial t) + cal(L)_v_t omega(t))\
  &= integral_K_t ((partial omega(t))/(partial t) + i_v_t dif omega(t)) + integral_(partial K_t) i_v_t omega(t).
$ <formula>

Question: 能否用 4 维 Lie 导数表达上述公式？

== 在连续介质力学中的应用

=== 连续性方程
$ omega(t) & = rho(t) epsilon, $
其中 $epsilon = sqrt(det(g_(i j)(x))) dif x^1 and dif x^2 and dif x^3$ 是体元。由散度的定义 $cal(L)_X epsilon =: "div"(X) epsilon,$ 故
$
  dif/(dif t) integral_K_t rho(t) epsilon &= integral_K_t ((partial rho(t))/(partial t) + v_t (rho(t)) + rho(t) "div"(v_t)) epsilon.
$
改用通常的写法，上式即为
$
  dif/(dif t) integral_K_t rho dif V = integral_K_t ((partial rho)/(partial t) + bold(v) dot nabla rho + rho nabla dot bold(v)) dif V.
$\

以上处理只是在 $t$ 时刻到 $t+s$ 时刻的时间段内采用了Lagrange观点。更彻底的Lagrange观点应当是对任意时刻 $t,$ 都将积分拉回到最初的参考构型 $(K_0, {xi^mu})$ 进行（假设微分同胚 $phi_t^0:K_0 -> K_t$ 存在）：
$
  integral_K_t epsilon = integral_K_0 phi_t^(0*) epsilon = integral_K_0 sqrt(det(g_(i j)(xi))) dif xi^1 and dif xi^2 and dif xi^3 = integral_K_0 sqrt(det((phi_t^(0*)g)_(i j))) dif xi^1 and dif xi^2 and dif xi^3,
$
利用行列式求导公式和度量的 Lie 导数公式，可以直接求出
$
  dif/(dif t) integral_K_t epsilon = integral_K_0 "div"(v_t) sqrt(det(g_(i j)(xi))) dif xi^1 and dif xi^2 and dif xi^3.
$


=== 磁冻结定理
$ omega(t) = dif bold(Sigma) dot bold(B)_t = 1/2 epsilon_(i j k) B_t^k dif x^i and dif x^j = i_B_t epsilon. $
注意到
$
  dif(i_B_t epsilon) &= cal(L)_B_t epsilon = "div"(B_t) epsilon,\
  i_v_t epsilon &= dif bold(Sigma) dot bold(v)_t,\
  i_v_t (1/2 epsilon_(i j k) B_t^k dif x^i and dif x^j) &= epsilon_(i j k) v_t^i B_t^k dif x^j = (bold(B)_t times bold(v)_t) dot dif bold(l),
$
@formula 给出（用通常的写法） $ dif/(dif t) integral_Sigma_t dif bold(Sigma) dot bold(B) = integral_Sigma_t dif bold(Sigma) dot ((partial bold(B))/(partial t) + bold(v) "div"(bold(B))) + integral_(partial Sigma_t) (bold(B) times bold(v)) dot dif bold(l). $
如果 $bold(B)$ 是磁场，则 $"div"(bold(B)) = 0,$ 上式成为
$
  dif/(dif t) integral_(Sigma_t) dif bold(Sigma) dot bold(B) = integral_Sigma_t dif bold(Sigma) dot ((partial bold(B))/(partial t) - nabla times (bold(v) times bold(B))).
$\

也可以考虑微分形式 $omega(t) = dif bold(l) dot bold(A)_t = A_(t i) dif x^i$ 在物质线 $C_t$ 上的积分的导数：
$
  dif omega(t) = partial_j A_(t i) dif x^j and dif x^i,\
  i_v_t dif omega(t) = v_t^j partial_j A_(t i) dif x^i - v_t^i partial_j A_(t i) dif x^j = v_t^j (partial_j A_(t i) - partial_i A_(t j)) dif x^i = (nabla times bold(A)_t) times bold(v)_t dot dif bold(l);\
  i_v_t omega(t) = A_(t i) v_t^i.
$
@formula 给出（用通常形式）
$
  dif/(dif t) integral_C_t dif bold(l) dot bold(A) = integral_C_t ((partial bold(A))/(partial t) + (nabla times bold(A)) times bold(v)) + integral_(partial C_t) bold(A) dot bold(v),
$
其中 $partial C_t$ 就是两个点。若 $C_t$ 为 $Sigma_t$ 的边界（因而是闭合曲线），$bold(A)$ 为矢势，则上式给出
$
  dif/(dif t) integral_Sigma_t dif bold(Sigma) dot bold(B) = dif/(dif t) integral_C_t dif bold(l) dot bold(A) = integral_C_t dif bold(l) dot ((partial bold(A))/(partial t) - bold(v) times bold(B)) = integral_Sigma_t dif bold(Sigma) dot ((partial bold(B))/(partial t) - nabla times (bold(v) times bold(B))).
$\

磁冻结定理用 4 维形式证明起来更直接[4]：设 $U = U^mu partial/(partial x^mu)$ 为4速，$F = 1/2 F_(mu nu) dif x^mu and dif x^nu$ 为电磁场张量，则由 $bold(E) + bold(v) times bold(B) = bold(0)$ 知（注意 $U^mu F_(mu nu)$ 是单位电荷所受的 4 洛伦兹力）
$
  cal(L)_U F & = i_U dif F + dif (i_U F) \
             & = 0 + dif (U^mu F_(mu nu) dif x^nu) \
             & = 0.
$

Question: 为什么四维形式这样写？

*参考文献*\
[1] https://zhuanlan.zhihu.com/p/547766124.\
[2] 梅加强. 流形与几何初步. \
[3] 谢多夫. 连续介质力学（第一卷）.\
[4] Wald. Advanced Classical Electromagnetism.\
[5] https://zhuanlan.zhihu.com/p/1901151820455321836
