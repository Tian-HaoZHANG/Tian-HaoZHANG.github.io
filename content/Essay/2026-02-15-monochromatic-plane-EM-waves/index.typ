#import "../index.typ": template, tufted
#import "@preview/lilaq:0.6.0" as lq
// convinent math operations
#import "../../../mod.typ": *
// 如需生成 RSS feed，必须填写 title、description 和 date 元数据
#set math.equation(supplement: [Eq.])

#let title = "On the monochromatic plane electromagnetic waves"
#let description = "Notes on the monochromatic plane wave and its polarization."
#let ref = "Ref: Xiong-Jun Liu (刘雄军)'s lecture notes."
#show: template.with(
  title: title,
  description: description,
  date: datetime(year: 2026, month: 2, day: 15),
  lang: "en",
)

= #title
#description\
#ref

== Plane waves
Work in geometrized Gaussian unit ststem, Maxwell equations are $ nabla dot bm(E) = 0, nabla times bm(B) - (partial bm(E))/(partial t) = bm(0), \
nabla dot bm(B) = 0, nabla times bm(E) + (partial bm(B))/(partial t) = bm(0); $
wave equations are $ nabla^2 bm(E) - (partial^2 bm(E))/(partial t^2) = bm(0), nabla^2 bm(B) - (partial^2 bm(B))/(partial t^2) = bm(0). $

=== Properties of plane waves

- *Def* (plane wave)
  A _plane wave_ is a solution to the wave equation that propagates along a fixed direction. A plane wave propagating along the $bm(n)$ direction is of the form $bm(E)(bm(x), t) = bm(E)_"profile" (bm(n) dot bm(x) - t).$

From $pdv(bm(B), t, style: "horizontal") = - nabla times bm(E)$ we shall have
$
  (partial B_i)/(partial t) & = -epsilon_(i j k) nabla^j E_"profile"^k \
                            & = - epsilon_(i j k) n^j (dif E_"profile"^k)/(dif phi),
$
where $dv(E_"profile"^k, phi, style: "horizontal")$ is the derivative of $E_"profile"^k$ w.r.t. its argument $phi = bm(n) dot bm(x) - t.$ Now
$ (partial E_"profile"^k)/(partial t) = - (dif E_"profile"^k)/(dif phi), $
so $ (partial B_i)/(partial t) = epsilon_(i j k) n^j (partial E_"profile"^k)/(partial t)\
=> B_i = epsilon_(i j k) n^j E^k + "static magnetic filed". $
The static magnetic field is of no interest since we are considering time-dependent waves. Thus
$ bm(B) = bm(n) times bm(E). $
Similarly, drop another static field, $nabla dot bm(E) = 0$ gives
$
  0 = nabla_i E_"profile"^i = n_i (dif E_"profile"^i)/(dif phi) = - partial/(partial t) (bm(n) dot bm(E))\
  => bm(n) dot bm(E) = 0.
$
- *Prop* (plane wave) $bm(n) dot bm(E) = 0, bm(B) = bm(n) times bm(E)=>bm(n) dot bm(B) = 0, bm(E) dot bm(B) = 0, abs(bm(E)) = abs(bm(B)).$
- *Remark* The propertity $bm(n) dot bm(E) = 0$ will not hold in general in media where the charge density is not zero, whereas $bm(B) = bm(n) times bm(E)$ always holds.
=== Monochromatic plane waves
- *Def* (monochromatic wave) A _monochromatic wave_ is a solution to the wave equation that has a definite frequency, so that its time dependence is of sinusoidal form.
A monochromatic plane wave is of the form
$ bm(E) = "Re"(bm(E)_0 exp(ii(bm(k) dot bm(x) - omega t)), $
where $bm(E)_0 in CC^3, omega > 0, bm(k) = bm(n) omega.$ Since the Maxwell equations are linear, we could just work in the complex notation#footnote[Extra attention is needed when dealing with non-linear quantities, such as the energy density which is quadratic in the fields.] with the understanding that we take the real part to get the physical quantity. Thus we simply write
$ bm(E) = bm(E)_0 exp(ii(bm(k) dot bm(x) - omega t)). $
- *Prop* (monochromatic plane wave) $omega = abs(bm(k)), bm(k) dot bm(E)_0 = 0, bm(B)_0 = bm(k)/omega times bm(E)_0 => bm(k) dot bm(B)_0 = 0, bm(E)_0 dot bm(B)_0 = 0, abs(bm(E)_0) = abs(bm(B)_0).$

== Polarization of a monochromatic plane EM wave

For a monochromatic plane EM wave, since $bm(n) dot bm(E)_0 = 0,$ we could write
$
  bm(E)_0 = E_0 uv(e)_1 + tilde(E)_0 uv(e)_2,\
  bm(E) = (E_0 uv(e)_1 + tilde(E)_0 uv(e)_2) exp(ii(bm(k) dot bm(x) - omega t)),
$ <basis_linear>
where $E_0, tilde(E)_0 in CC$ while $uv(e)_1, uv(e)_2$ are orthonormal and are both orthogonal to $bm(n).$

WLOG set $bm(n) = uv(e)_z, uv(e)_1 = uv(e)_x, uv(e)_2 = uv(e)_y, E_0 in RR_(>=0),$ then
$
  bm(E) = mat(uv(e)_x | uv(e)_y | uv(e)_z) mat(a_1; a_2 exp(ii delta); 0) exp(ii omega (z - t)),
$ <polarization_plane_wave>
where $a_1, a_2 in RR_(>=0)$ and $delta in [-pi, pi)$ is the phase difference between $tilde(E)_0$ and $E_0.$

If we fix a value of $z$ (e.g. $z = 0$), then the end point of the vector
$ bm(E) = uv(e)_x a_1 cos(omega t) + uv(e)_y a_2 cos(omega t - delta) $
will in general depict a ellipse in the $x O y$ plane
$ x^2/a_1^2 + y^2/a_2^2 - (2 x y)/(a_1 a_2) cos delta = sin^2 delta. $ <ellipse>
It is in this sense that the monochromatic plane wave is _elliptically polarized_.

=== Linear polarization

- *Def* (linear polarization) A monochromatic plane wave is said to be _linearly polarized_, if the direction of its electric field does not change, that is, if the ellipse in @ellipse degenerates into a straight line.

Using @polarization_plane_wave, a wave is linearly polarized if one of the following conditions holds:
+ $a_1 = 0, a_2 != 0;$
+ $a_1 != 0, a_2 = 0;$
+ $a_1 != 0, a_2 != 0, delta = 0;$
+ $a_1 != 0 , a_2 != 0, delta = pi.$

Note that the basis we used in @basis_linear are linearly polarized.

=== Circular polarization

- *Def* (linear polarization) A monochromatic plane wave is said to be _circularly polarized_, if the ellipse in @ellipse degenerates into a circle.

Using @polarization_plane_wave, a wave is circularly polarized if $a_1 = a_2 != 0$ and $delta = plus.minus pi/2.$\
For $delta = pi/2,$ the vector
$ bm(E) = a (uv(e)_x cos(omega t) + uv(e)_y sin(omega t)) $
ratotes anticlockwise in the $x O y$ plane; this wave is said to be right-hand circularly polarized (labelled by $lambda = +$) and have positive helicity#footnote[Positive helicity means that the ratotion is parallel to the direction of propagation. Indeed, the helicity, which is defined as the component of spin angular momentum along the direction of propagation, of the mode characterized by wave vector $bm(k)$ and polarization $lambda (= plus.minus),$ is given by $sigma_(bm(k), lambda) = "sgn"(lambda) braket(E)_(bm(k), lambda)/omega,$ where $braket(E)_(bm(k), lambda)$ is the time-averaged total energy of the mode; this can be compared with the Planck formula in quantum mechanics $E = planck omega.$ In the transition from classical to quantum physics, the helicity of the EM field becomes the spin of the photon.]. Likewise, the wave with $delta = - pi/2$ is said to be left-hand circularly polarized (labelled by $lambda = -$) and have negative helicity.

It is sometimes convenient to expand $bm(E)$ in terms of circularly-polarized waves, rather than linearly polarized waves as in @basis_linear. Define
$ uv(e)_plus.minus := 1/sqrt(2) (uv(e)_1 plus.minus i uv(e)_2); $
that is
$ mat(uv(e)_+ | uv(e)_-) = mat(uv(e)_1 | uv(e)_2) mat(1/sqrt(2), 1/sqrt(2); i/sqrt(2), -i/sqrt(2)). $
Note that $uv(e)_plus.minus^* = uv(e)_minus.plus.$ It follows from the orthonormality of $uv(e)_1, uv(e)_2$ that
$ uv(e)_+ dot uv(e)_+ = 0, uv(e)_- dot uv(e)_- = 0, uv(e)_+ dot uv(e)_- = 1. $
The inverse transform is
$ uv(e)_1 = 1/sqrt(2) (uv(e)_+ + uv(e)_-), uv(e)_2 = -i/sqrt(2) (uv(e)_+ - uv(e)_-); $
that is
$ mat(uv(e)_1 | uv(e)_2) = mat(uv(e)_+ | uv(e)_-) mat(1/sqrt(2), -i/sqrt(2); 1/sqrt(2), i/sqrt(2)). $

=== Stokes parameters

The magnitude and phase information is sometimes expressed in terms of the so called _Stokes parameters_ $(s_0, s_1, s_2, s_2),$ which are defined by (using the convensions and notations in @polarization_plane_wave)
$
  s_0 & := E_x E_x^* + E_y E_y^* && = a_1^2 + a_2^2, \
  s_1 & := E_x E_x^* - E_y E_y^* && = a_1^2 - a_2^2, \
  s_2 & := 2 "Re"(E_x^* E_y)     && =2 a_1 a_2 cos delta, \
  s_3 & := 2 "Im"(E_x^* E_y)     && = 2 a_1 a_2 sin delta.
$
Note that $ s_0^2 = s_1^2 + s_2^2 + s_3^2. $
The parameter $s_0$ characterizes the intensity of the wave, while $s_1$ characterizes the amount of $x$ polarization versus $y$ polatization; the third independent parameter, either $s_2$ or $s_3$, characterizes the phase difference between the $y$ and $x$ polarized waves.

- *Prop* (characterization of linear/circular polarization)

  - Linear polarization corresponds to $s_3 = 0;$
  - circular polarization corresponds to $s_1 = s_2 = 0.$



== Doppler effect

#figure(
  image("doppler.png"),
  caption: [Doppler effect of light. Copied from 梁灿彬&周彬《微分几何入门与广义相对论（上册）》.],
)
The world lines of the observer and the illuminant (light source) are both time-like. Assume that at spacetime point $p$ the illuminant whose 4-velocity is $V^a$ in abstract index notation, emits a monochromatic plane wave (at least in the geometric optics approximation sense) with 4-wavevector $K^a,$ which is received at spacetime point $q$ by the observer whose 4-velocity is $U^a.$

Note that $lr(K^a |)_p = lr(K^a |)_q,$ the angular-frequency measured by the illuminant at emitting is
$ omega = - K_a V^a, V^a in T_p RR^4 $
and by the observer at receiving is
$ omega' = -K_a U^a, U^a in T_q RR^4. $
Since the Minkowski space $(RR^4, eta, nabla = partial)$ is flat, $U^a in T_q RR^4$ can be can be identified with the vector $U^a in T_p RR^4$ via the global parallelism; from now on it is understood that all the calculations are done at $p.$

Let $gamma = - V^a U_a,$ then
$ U^a = gamma (V^a + u^a), $
where $gamma u^a$ is the projection of $U^a$ on the "space plane" perpendicular to $V^a.$
Also
$ K_a = -omega V_a + k_a, $
thus
$
  omega' & = -K_a U^a \
         & = -gamma (-omega V_a + k_a)(V^a + u^a) \
         & = gamma (omega - k_a u^a) \
         & stretch(=)^" in 3d notation" gamma (omega - bm(k) dot bm(u)).
$
Let $theta$ be the angle between $bm(k)$ and $bm(u)$ and note that $abs(bm(k)) = omega,$ the result is written
$ omega' = gamma omega (1-u cos theta) $
where $u = abs(bm(u)), gamma = 1/sqrt(1-u^2).$ Note that $bm(u)$ is just the 3-velocity of the observer relative to the illuminant.

=== Non-relativistic limit of the Doppler effect

In this subsection, SI units is used.

For the light waves, $ omega' = omega (1 - u/c cos theta). $
For other non-relativistic waves, the Doppler shift is most easily derive from the Galilean transformation.

Since the wave equation $((1/v_rm(p)^2) pdv(, t, dim: 2, style: "horizontal") - nabla^2) f = 0$ is invariant under the Galilean transformation, the plane wave phase $bm(k) dot bm(x) - omega t$ is also invariant. Since in Newtonian mechanics, the concept of the length is absolute, the wave-length#footnote[The wave-length is defined as the distance between the two material points (连续介质力学中的物质点) whose phase difference is $2 pi.$] and thus the wave-vector $bm(k)$ is Galilean invariant. Thus, under the Galilean transformation $bm(x)' = bm(x) - bm(u) t,$ the angular-frequency transforms according to
$
  omega' t - bm(k) dot bm(x)' = omega - bm(k) dot bm(x)\
  => omega' = omega - bm(k) dot bm(u),
$
where $omega$ is the angular-frequency measured by the illuminant and $omega'$ by the observer, $bm(u)$ is the velocity of the observer relative to the illuminant.
#pagebreak()

== Electrostatic waves

The electrostatic field satisfies the equations
$ nabla^2 phi = - 4 pi rho, bm(E) = - nabla phi, $
from which we derive the Fourier transform
$ phi(bm(k)) = (4pi rho(bm(k)))/k^2, bm(E)(bm(k)) = -i (4pi rho(bm(k)))/k^2 bm(k). $
In particular, the electrostatic field is longitudinal (instead of transverse) $bm(E)(bm(k)) parallel bm(k).$

When coupling to the matters (such as plasmas), it is possible for an electrostatic pertubation to propagate through the system; this is an electrostatic wave.\
If the coupling is linear, then the mode characterized by wave vector $bm(k)$ evolves as (let $omega = omega(bm(k)) = omega_rm(r) (bm(k)) + i gamma(bm(k)) in CC$ be the dispersion relation which encodes the linear interaction of the electric field and the matter)
$
  bm(E)_bm(k)(bm(x), t) & = uv(k) E_0(bm(k)) exp(ii(bm(k) dot bm(x) - omega(bm(k))t)) \
                        & = uv(k) E_0(bm(k)) exp(gamma(bm(k)) t) exp(ii(bm(k) dot bm(x) - omega_rm(r) (bm(k))t)),
$
where $E_0(bm(k)) in CC$ is determined by solving the linear system (including boundary and initial conditions). This is sometimes referred to as the "plane wave ansatz." Note that if the coupling is non-linear (as is generally the case), then the most general solution need not possess a monochromatic plane wave form (although we could always try to search for solutions of this form).#footnote[The essence of "plane wave ansatz", or the "superposition principle" in linear systems, is two fold: First, the physical quantity under consideration can be decomposed into Fourier modes — we can always do this with aid of the mathematical Fourier theory. Second each Fourier mode evolves independently, and there is no interaction between any two of the modes — this is a consequence of linearity. Note, however, that if there exist non-linear phenomena, then different Fourier modes will indeed couple and cannot be solved independently. In such systems, for example, a pertubation with angular-frequency $omega$ might excite frequency multiplications $2 omega, 3 omega, dots.c.$]
