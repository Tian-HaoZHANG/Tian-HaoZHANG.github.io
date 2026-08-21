#import "../index.typ": template, tufted
// convinent math operations
#import "../../../mod.typ": *
// 如需生成 RSS feed，必须填写 title、description 和 date 元数据

#let title = "C++ rk4 algorithm"
#let description = "A C++ implementation of the 4th-order Runge-Kutta method for solving ordinary differential equations."

#show: template.with(
  title: title,
  description: description,
  date: datetime(year: 2026, month: 1, day: 17),
  lang: "en",
)

= #title
#description\

#figure(caption: [The header file @book:Fitzpatrick-computational-physics @book:a-tour-of-cpp @website:cppreference.])[
  ```cpp
  #ifndef RK4_H
  #define RK4_H

  #include <span> // serve as the interface for std::vector and std::array
  #include <vector>

  namespace rk4 {
      /* To advance a set of first-order ODEs by a SINGLE step using fixed step-length RK4 scheme.

                  x ... independent variable 自变量 (modified)
                  y ... span of dependent variables 因变量 (modified in place)
                  h ... fixed step-length, could be negative 步长

      Best practice: examine the best h value for your problem.

      Requires the right-hand side function that defines the ODEs:

                  void calculate_dydx(double x, std::span<const double> y, std::span<double> dydx)
      */
      void fixed(double& x, std::span<double> y,
          void (*calculate_dydx)(double, std::span<const double>, std::span<double>),
          const double h)
      {
          const int n = y.size();  // number of dependent variables

          // Declare local arrays：由于要定义以 variable （而不是 constexpr）为大小的数组，不能用 std::array；由于这些中间数组需要实际持有数据，不用 std::span
          std::vector<double> k1(n, 0.0), k2(n, 0.0), k3(n, 0.0), k4(n, 0.0), f(n, 0.0), dydx(n, 0.0); // f 用于保存中间阶段的 y 值, dydx 用于计算 k1-k4 时保存 dydx 值

          // --- First intermediate step ---
          calculate_dydx(x, y, dydx);
          for (int i = 0; i < n; ++i) {
              k1[i] = h * dydx[i];
              f[i] = y[i] + k1[i] / 2.0;
          }

          // --- Second intermediate step ---
          calculate_dydx(x + h / 2.0, f, dydx);
          for (int i = 0; i < n; ++i) {
              k2[i] = h * dydx[i];
              f[i] = y[i] + k2[i] / 2.0;
          }

          // --- Third intermediate step ---
          calculate_dydx(x + h / 2.0, f, dydx);
          for (int i = 0; i < n; ++i) {
              k3[i] = h * dydx[i];
              f[i] = y[i] + k3[i];
          }

          // --- Fourth intermediate step ---
          calculate_dydx(x + h, f, dydx);
          for (int i = 0; i < n; ++i) {
              k4[i] = h * dydx[i];
          }

          // --- Combine the slopes and update y ---
          for (int i = 0; i < n; ++i) {
              y[i] += (k1[i] + 2.0 * k2[i] + 2.0 * k3[i] + k4[i]) / 6.0;
          }

          x += h;  // advance ONE step further
      } // function fixed()

  } // namespace rk4
  #endif // RK4_H

  ```
]

#figure(caption: [A simple example.])[
  ```cpp
  #include <iostream>
  #include <cmath>
  #include <span>
  #include <array>
  #include "header_files/rk4.hpp"

  // 谐振子右端函数：dx/dt = v, dv/dt = - x
  void harmonic_ode(double t, std::span<const double> y, std::span<double> dydx) {
      dydx[0] = y[1]; // dx/dt = v
      dydx[1] = -y[0]; // dv/dt = - x
  }

  int main()
  {
      constexpr double h = 0.01;             // 固定步长
      constexpr int n_steps = 100;          // 总步数

      double t = 0.0;                       // 初始时间
      std::array<double, 2> y = {1.0, 0.0};   // 初始状态 [x, v]

      // 主积分循环
      for (int i = 0; i < n_steps; ++i) {
          // 使用 RK4 推进一步（t 和 y 会被修改）
          rk4::fixed(t, y, harmonic_ode, h);
      }

      double error_x = y[0] - std::cos(t);
      double error_v = y[1] + std::sin(t);
      double error = std::sqrt(error_x * error_x + error_v * error_v);
      std::cout << error << "\n";

      return 0;
  }

  ```
]
#bibliography("ref.bib")
