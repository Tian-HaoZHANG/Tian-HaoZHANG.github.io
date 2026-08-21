#import "@preview/modern-pku-thesis:0.2.3": booktab
#import "../../mod.typ": *
// 行内公式的分式设为横向
#show math.equation.where(block: false): set math.frac(style: "horizontal")
#set text(
  font: ("New Computer Modern", "STSong"),
  size: 11pt,
)
#show raw: set text(font: "Fira Code")

#align(center)[
  *Physical Constants*
  #booktab(
    caption: [Physical Constants],
    columns: (auto, 1fr, auto),
    align: (center, center, center),
    outlined: false,
    [Name],
    [Symbol],
    [Value (SI)],
    [Speed of light in vacuum],
    [$c$],
    [$2.99792458 times 10^8 "m/s"$ (exact)],
    [Newtonian constant of gravitation],
    [$G$],
    [$6.674 30(15) times 10^(-11) " m"^3 dot.c "kg"^(-1) dot.c "s"^(-2)$],
    [Planck constant],
    [$h$],
    [$6.626 070 15 times 10^(-34) "J" dot.c "s"$ (exact)],
    [Reduced Planck constant],
    [$planck$],
    [$1.054 571 817 dots times 10^(-34) "J" dot.c "s"$ (exact)],
    [Elementary charge],
    [$e$],
    [$1.602 176 634 times 10^(-19) "C"$ (exact)],
    [Vacuum electric permittivity],
    [$epsilon_0$],
    [$8.854 187 8188(14) times 10^(-12) "F/m"$],
    [Vacuum magnetic permeability $1/ c^2 epsilon.alt_0$],
    [$mu_0$],
    [$1.256 637 061 27(20) times 10^(-7) "H/m"$],
    [Electron mass],
    [$m_e$],
    [$9.109 383(28) times 10^(-31) "kg"$],
    [Proton mass],
    [$m_p$],
    [$1.672 621 925 95(52) times 10^(-27) "kg"$],
    [Proton-electron mass ratio],
    [$m_p/m_e$],
    [$1836.152 673 426(32)$],
    [Boltzmann constant],
    [$k_rm(B)$],
    [$1.380649 times 10^(-23) "J/K"$ (exact)],
    [Avogadro constant],
    [$N_rm(A)$],
    [$6.022 140 76 times 10^(23) " mol"^(-1)$ (exact)],
    table.hline(),
    [Electron volt $(e/rm(C)) "J"$],
    [$"eV"$],
    [$1.602 176 634 times 10^(-19) "J"$ (exact)],
    [(Unified) atomic mass unit $m(attach(rm(C), tl: 12))/12$],
    [$rm(u), m_rm(u)$],
    [$1.660 539 068 92(52) times 10^(-27) "kg"$],
    [Temperature $1 "eV"$ ],
    [--],
    [$1.160451812 dots times 10^4 "K"$ (exact)],
  )<tab:physical-constants>
]
#pagebreak()

Use the physical constants in C++.\
```cpp
// 宏守卫 #ifndef... 保证这个宏只被定义一次，从而保证这个头文件只被 #include 一次；#pragma once 是较新的方式，此时不用 #define... 和 #endif //..
#ifndef PHYSICAL_CONSTANTS_H
#define PHYSICAL_CONSTANTS_H

#include <numbers> // namespace std::numbers 中包含 e, egamma, pi, 以及一些常用的 log 和 sqrt

namespace physical_constants {
    // ============================================================
    //  Exact constants (2019 SI redefinition)
    // ============================================================
    // Speed of light in vacuum: c = 299 792 458 m/s  (exact)
    template<typename T>
    inline constexpr T speed_of_light_v = T(299792458.0);
    inline constexpr double speed_of_light = speed_of_light_v<double>;

    // Planck constant: h = 6.626 070 15e-34 J·s  (exact)
    template<typename T>
    inline constexpr T planck_constant_v = T(6.62607015e-34);
    inline constexpr double planck_constant = planck_constant_v<double>;

    // Reduced Planck constant: ħ = h / (2π)  (exact, derived)
    template<typename T>
    inline constexpr T planck_constant_reduced_v = T(3.313035075e-34 * std::numbers::inv_pi);
    inline constexpr double planck_constant_reduced = planck_constant_reduced_v<double>;

    // Elementary charge: e = 1.602 176 634e-19 C  (exact)
    template<typename T>
    inline constexpr T elementary_charge_v = T(1.602176634e-19);
    inline constexpr double elementary_charge = elementary_charge_v<double>;

    // Boltzmann constant: k_B = 1.380 649e-23 J/K  (exact)
    template<typename T>
    inline constexpr T boltzmann_constant_v = T(1.380649e-23);
    inline constexpr double boltzmann_constant = boltzmann_constant_v<double>;

    // Avogadro constant: N_A = 6.022 140 76e23 mol⁻¹  (exact)
    template<typename T>
    inline constexpr T avogadro_constant_v = T(6.02214076e23);
    inline constexpr double avogadro_constant = avogadro_constant_v<double>;

    // Electron volt: eV = 1.602 176 634e-19 J  (exact, same as elementary charge)
    template<typename T>
    inline constexpr T electron_volt_v = T(1.602176634e-19);
    inline constexpr double electron_volt = electron_volt_v<double>;

    // Temperature of 1 eV: e / k_B (exact, derived)
    template<typename T>
    inline constexpr T electron_volt_temperature_v = T(elementary_charge / boltzmann_constant);
    inline constexpr double electron_volt_temperature = electron_volt_temperature_v<double>;

    // ============================================================
    //  Constants with experimental uncertainty (central values)
    // ============================================================

    // Newtonian constant of gravitation: G = 6.674 30(15)e-11 m³·kg⁻¹·s⁻²
    template<typename T>
    inline constexpr T gravitational_constant_v = T(6.67430e-11);
    inline constexpr double gravitational_constant = gravitational_constant_v<double>;

    // Vacuum electric permittivity: ε₀ = 8.854 187 818 8(14)e-12 F/m
    template<typename T>
    inline constexpr T vacuum_permittivity_v = T(8.8541878188e-12);
    inline constexpr double vacuum_permittivity = vacuum_permittivity_v<double>;

    // Vacuum magnetic permeability: μ₀ = 1.256 637 061 27(20)e-6 H/m
    template<typename T>
    inline constexpr T vacuum_permeability_v = T(1.25663706127e-6);
    inline constexpr double vacuum_permeability = vacuum_permeability_v<double>;

    // Electron mass: m_e = 9.109 383(28)e-31 kg
    template<typename T>
    inline constexpr T electron_mass_v = T(9.109383e-31);
    inline constexpr double electron_mass = electron_mass_v<double>;

    // Proton mass: m_p = 1.672 621 925 95(52)e-27 kg
    template<typename T>
    inline constexpr T proton_mass_v = T(1.67262192595e-27);
    inline constexpr double proton_mass = proton_mass_v<double>;

    // Proton-electron mass ratio: m_p / m_e = 1836.152 673 426(32)
    template<typename T>
    inline constexpr T proton_electron_mass_ratio_v = T(1836.152673426);
    inline constexpr double proton_electron_mass_ratio = proton_electron_mass_ratio_v<double>;

    // (Unified) atomic mass unit: u = 1.660 539 068 92(52)e-27 kg
    template<typename T>
    inline constexpr T atomic_mass_unit_v = T(1.66053906892e-27);
    inline constexpr double atomic_mass_unit = atomic_mass_unit_v<double>;

} // namespace physical_constants

#endif // PHYSICAL_CONSTANTS_H

```

