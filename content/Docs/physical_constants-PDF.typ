#import "@preview/modern-pku-thesis:0.2.3": booktab

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init.with()

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
    [Reduced Planck constant $h/2pi$],
    [$planck$],
    [$1.054 571 817 dots times 10^(-34) "J" dot.c "s"$ (exact)],
    [Elementary charge],
    [$e$],
    [$1.602 176 634 times 10^(-19) "C"$ (exact)],
    [Vacuum permittivity],
    [$epsilon_0$],
    [$8.854 187 8188(14) times 10^(-12) "F/m"$],
    [Vacuum permeability $1/ c^2 epsilon.alt_0$],
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

To use the above physical constants in C++, `#include` the following header file:
```cpp
// physical_constants.hpp
#if !defined(PHYSICAL_CONSTANTS_HPP)
#define PHYSICAL_CONSTANTS_HPP

#include <numbers> // namespace std::numbers 中包含 e, egamma, pi, 以及一些常用的 log 和 sqrt
#include <type_traits> // for std::is_arithmetic_v<> and std::is_floating_point_v<>

// SI since 2019
namespace physical_constants {
    // Favor double over float unless there is no enough space, as the lack of precision in a float will often lead to inaccuracies.

    // Note that constexpr functions are implicitly inline, but constexpr variables are not implicitly inline.

    // Inline variables have external linkage by default, so that they are visible to the linker. This is necessary so the linker can de-duplicate the definitions.
    // Non-inline constexpr variables have internal linkage. If included into multiple translation units, each translation unit will get its own copy of the variable. This is not an ODR violation because they are not exposed to the linker.

    // Since we are using inline variables, changing anything in this header file requires recompiling those files who include it.
    // Use constexpr std::string_view for constexpr strings.

    // ============================================================
    //  Exact constants
    // ============================================================

    // Speed of light in vacuum: c = 299 792 458 m/s  (exact)
    template<typename T>
        requires std::is_arithmetic_v<T> // 要求 T 是算术类型（整数或浮点数）
    inline constexpr T speed_of_light_v { static_cast<T>(299'792'458.0L) }; // static_cast 是静态类型转换，在编译期完成
    inline constexpr double speed_of_light { speed_of_light_v<double> };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T sqrt_c2_v { speed_of_light_v<T> };
    inline constexpr double sqrt_c2 { speed_of_light };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T c_v { speed_of_light_v<T> };
    inline constexpr double c { speed_of_light };


    template<typename T>
        requires std::is_arithmetic_v<T> // 要求 T 是算术类型（整数或浮点数）
    inline constexpr T speed_of_light_square_v { static_cast<T>(89'875'517'873'681'764.0L) }; // static_cast 是静态类型转换，在编译期完成
    inline constexpr double speed_of_light_square { speed_of_light_square_v<double> };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T c2_v { speed_of_light_square_v<T> };
    inline constexpr double c2 = speed_of_light_square;



    // Planck constant: h = 6.626 070 15e-34 J·s  (exact)
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T planck_constant_v { static_cast<T>(6.626'070'15e-34L) };
    inline constexpr double planck_constant { planck_constant_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T h_v { planck_constant_v<T> };
    inline constexpr double h { planck_constant };

    // Reduced Planck constant: ħ = h / (2π)  (exact, derived)
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T planck_constant_reduced_v { static_cast<T>(3.313'035'075e-34L * std::numbers::inv_pi_v<long double>) };
    inline constexpr double planck_constant_reduced { planck_constant_reduced_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T hbar_v { planck_constant_reduced_v<T> };
    inline constexpr double hbar { planck_constant_reduced };



    // Elementary charge: e = 1.602 176 634e-19 C  (exact)
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T elementary_charge_v { static_cast<T>(1.602'176'634e-19L) };
    inline constexpr double elementary_charge { elementary_charge_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T qe_v { elementary_charge_v<T> };
    inline constexpr double qe { elementary_charge };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T e_v { elementary_charge_v<T> };
    inline constexpr double e { elementary_charge };


    // Boltzmann constant: k_B = 1.380 649e-23 J/K  (exact)
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T boltzmann_constant_v { static_cast<T>(1.380'649e-23L) };
    inline constexpr double boltzmann_constant { boltzmann_constant_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T kB_v { boltzmann_constant_v<T> };
    inline constexpr double kB { boltzmann_constant };



    // Avogadro constant: N_A = 6.022 140 76e23 mol⁻¹  (exact)
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T avogadro_constant_v { static_cast<T>(6.022'140'76e23L) };
    inline constexpr double avogadro_constant { avogadro_constant_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T NA_v { avogadro_constant_v<T> };
    inline constexpr double NA { avogadro_constant };



    // Electron volt: eV = 1.602 176 634e-19 J  (exact, same as elementary charge)
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T electron_volt_v { static_cast<T>(1.602'176'634e-19L) };
    inline constexpr double electron_volt { electron_volt_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T eV_v { electron_volt_v<T> };
    inline constexpr double eV { electron_volt };



    // Temperature of 1 eV: e / k_B (exact, derived)
    template<typename T>
        requires std::is_arithmetic_v<T> // 要求 T 是算术类型（整数或浮点数）
    inline constexpr T electron_volt_temperature_v { static_cast<T>(elementary_charge_v<long double> / boltzmann_constant_v<long double>) };
    inline constexpr double electron_volt_temperature { electron_volt_temperature_v<double> };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T eV_temp_v { electron_volt_temperature_v<T> };
    inline constexpr double eV_temp { electron_volt_temperature };

    // ============================================================
    //  Constants with experimental uncertainty (central values)
    // ============================================================

    // Newtonian constant of gravitation: G = 6.674 30(15)e-11 m³·kg⁻¹·s⁻²
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T gravitational_constant_v { static_cast<T>(6.674'30e-11L) };
    inline constexpr double gravitational_constant { gravitational_constant_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T G_v { gravitational_constant_v<T> };
    inline constexpr double G { gravitational_constant };


    // Vacuum permittivity: ε₀ = 8.854 187 818 8(14)e-12 F/m
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T vacuum_permittivity_v { static_cast<T>(8.854'187'818'8e-12L) };
    inline constexpr double vacuum_permittivity { vacuum_permittivity_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T epsilon0_v { vacuum_permittivity_v<T> };
    inline constexpr double epsilon0 { vacuum_permittivity };



    // Vacuum permeability: μ₀ = 1.256 637 061 27(20)e-6 H/m
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T vacuum_permeability_v { static_cast<T>(1.256'637'061'27e-6L) };
    inline constexpr double vacuum_permeability { vacuum_permeability_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T mu0_v { vacuum_permeability_v<T> };
    inline constexpr double mu0 { vacuum_permeability };



    // Electron mass: m_e = 9.109 383(28)e-31 kg
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T electron_mass_v { static_cast<T>(9.109'383e-31L) };
    inline constexpr double electron_mass { electron_mass_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T me_v { electron_mass_v<T> };
    inline constexpr double me { electron_mass };



    // Electron charge to mass ratio: e / m_e = 1.758 820 1e11 C/kg
    template<typename T>
        requires std::is_arithmetic_v<T> // 要求 T 是算术类型
    inline constexpr T electron_charge_to_mass_ratio_v { static_cast<T>(elementary_charge_v<long double> / electron_mass_v<long double>) };
    inline constexpr double electron_charge_to_mass_ratio { electron_charge_to_mass_ratio_v<double> };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T qe_over_me_v { electron_charge_to_mass_ratio_v<T> };
    inline constexpr double qe_over_me { electron_charge_to_mass_ratio_v<double> };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T e_over_me_v { electron_charge_to_mass_ratio_v<T> };
    inline constexpr double e_over_me { electron_charge_to_mass_ratio_v<double> };



    // Electron mass to charge ratio: m_e / e = 5.685 629 7e-12 kg/C
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T electron_mass_to_charge_ratio_v { static_cast<T>(electron_mass_v<long double> / elementary_charge_v<long double>) };
    inline constexpr double electron_mass_to_charge_ratio { electron_mass_to_charge_ratio_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T me_over_qe_v { electron_mass_to_charge_ratio_v<T> };
    inline constexpr double me_over_qe { electron_mass_to_charge_ratio_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T me_over_e_v { electron_mass_to_charge_ratio_v<T> };
    inline constexpr double me_over_e { electron_mass_to_charge_ratio_v<double> };



    // Proton mass: m_p = 1.672 621 925 95(52)e-27 kg
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T proton_mass_v { static_cast<T>(1.672'621'925'95e-27L) };
    inline constexpr double proton_mass { proton_mass_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T mp_v { proton_mass_v<T> };
    inline constexpr double mp { proton_mass_v<double> };



    // Proton charge to mass ratio: e / m_p = 9.578 833 143 0e7 C/kg
    template<typename T>
        requires std::is_arithmetic_v<T> // 要求 T 是算术类型
    inline constexpr T proton_charge_to_mass_ratio_v { static_cast<T>(elementary_charge_v<long double> / proton_mass_v<long double>) };
    inline constexpr double proton_charge_to_mass_ratio { proton_charge_to_mass_ratio_v<double> };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T qe_over_mp_v { proton_charge_to_mass_ratio_v<T> };
    inline constexpr double qe_over_mp { proton_charge_to_mass_ratio_v<double> };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T e_over_mp_v { proton_charge_to_mass_ratio_v<T> };
    inline constexpr double e_over_mp { proton_charge_to_mass_ratio_v<double> };



    // Proton mass to charge ratio: m_p / e = 1.043'968'492'9e-8 kg/C
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T proton_mass_to_charge_ratio_v { static_cast<T>(proton_mass_v<long double> / elementary_charge_v<long double>) };
    inline constexpr double proton_mass_to_charge_ratio { proton_mass_to_charge_ratio_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T mp_over_qe_v { proton_mass_to_charge_ratio_v<T> };
    inline constexpr double mp_over_qe { proton_mass_to_charge_ratio_v<double> };

    template<typename T>
        requires std::is_floating_point_v<T>
    inline constexpr T mp_over_e_v { proton_mass_to_charge_ratio_v<T> };
    inline constexpr double mp_over_e { proton_mass_to_charge_ratio_v<double> };



    // Proton-electron mass ratio: m_p / m_e = 1 836.152 673 426(32)
    template<typename T>
        requires std::is_arithmetic_v<T> // 要求 T 是算术类型（整数或浮点数）
    inline constexpr T proton_electron_mass_ratio_v { static_cast<T>(1'836.152'673'426L) };
    inline constexpr double proton_electron_mass_ratio { proton_electron_mass_ratio_v<double> };

    template<typename T>
        requires std::is_arithmetic_v<T>
    inline constexpr T mp_over_me_v { proton_electron_mass_ratio_v<T> };
    inline constexpr double mp_over_me { proton_electron_mass_ratio_v<double> };



    // (Unified) atomic mass unit: u = 1.660 539 068 92(52)e-27 kg
    template<typename T>
        requires std::is_floating_point_v<T> // 要求 T 是浮点类型
    inline constexpr T atomic_mass_unit_v { static_cast<T>(1.660'539'068'92e-27L) };
    inline constexpr double atomic_mass_unit { atomic_mass_unit_v<double> };

} // namespace physical_constants

#endif // PHYSICAL_CONSTANTS_HPP


```

