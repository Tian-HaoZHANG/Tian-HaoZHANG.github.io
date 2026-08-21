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

== A minimum prototype

#figure(caption: [A minimum prototype simplified from @book:Fitzpatrick-computational-physics.])[
  ```cpp
  // To advance a set of first-order ODEs by a SINGLE step using fixed step-length RK4 scheme.
  //
  //            x ... independent variable 自变量
  //            y ... dependent variable 因变量
  //            h ... fixed step-length, could be negative 步长
  //
  // Best practice: before doing large number of steps, examine the best h.
  // Requires the right-hand side functon which defines the ODE
  //
  //            void calculate_dydx(const double x, const double& y, double &dydx)
  //
  void rk4_fixed(double& x, double& y, const double h, void (*calculate_dydx)(const double, const double&, double&))
  {
      double dydx = 0.0; // dydx 用于保存中间阶段的 dydx 值

      // First intermediate step
      calculate_dydx(x, y, dydx);
      double k1 = h * dydx;
      double f = y + k1 / 2.0;

      // Second intermediate step
      calculate_dydx(x + h / 2.0, f, dydx);

      double k2 = h * dydx;
      f = y + k2 / 2.0;

      // Third intermediate step
      calculate_dydx(x + h / 2.0, f, dydx);
      double k3 = h * dydx;
      f = y + k3;

      // Fourth intermediate step
      calculate_dydx(x + h, f, dydx);

      // Actual step：不用定义 k4
      y += (k1 + 2.0 * k2 + 2.0 * k3 + h * dydx) / 6.0;

      x += h; // advance ONE step forward
  }
  ```
]


== The header file
#figure(
  caption: [The .hpp header file @book:Fitzpatrick-computational-physics @book:a-tour-of-cpp @website:cppreference.],
)[
  ```cpp
  #ifndef RK4_H
  #define RK4_H

  #include <type_traits>
  #include <concepts>
  #include <span>
  #include <vector>
  #include <utility> // for std::pair 和 std::forward
  #include <stdexcept>

  namespace rk4 {

      // 工作区：封装 RK4 所需的临时数组，避免内部计算时重复分配
      template<typename RealType>
      struct RK4Workspace {
          RK4Workspace() = default; // 默认构造函数构造出的 std::vector 的 .size() 和 .capacity() 均为 0
          explicit RK4Workspace(std::size_t n) : RK4Workspace() { resize(n); }

          std::size_t size() const { return k1.size(); } // 返回工作区的大小（维度）

          void resize(std::size_t n)
          {
              k1.resize(n); // resize() 改变 .size()；如果这里的 n > .capacity()，则会重新分配内存，导致指针空悬 —— 为了防止此类现象，最好先 reserve()；当 vector.size() == n 时，resize() 什么也不做
              k2.resize(n);
              k3.resize(n);
              temp.resize(n);
              dydx.resize(n);
          }

          std::vector<RealType> k1, k2, k3, temp, dydx;
      };


      namespace step {
          // 使用工作区的 step 函数，内部使用可以避免反复创建工作区变量
          template<typename RealType, typename DerivFunc>
              requires std::is_floating_point_v<RealType>&& std::invocable<DerivFunc, RealType, std::span<const RealType>, std::span<RealType>>
          // std::invocable<T, Args...> 约束 T 必须要能在 Args... 上调用，并且不要求特定返回类型
          void step(RealType& x, std::span<RealType> y, RealType h, DerivFunc&& calculate_dydx, RK4Workspace<RealType>& ws)
          {
              const std::size_t n = y.size();

              if (ws.size() < n) {
                  ws.resize(n); // 确保工作区大小足够
              }
              // 引用工作区内的数组，避免重复访问 ws 成员
              auto& k1 = ws.k1;
              auto& k2 = ws.k2;
              auto& k3 = ws.k3;
              auto& temp = ws.temp;
              auto& dydx = ws.dydx;

              // --- First intermediate step ---
              calculate_dydx(x, y, dydx);
              for (std::size_t i = 0; i < n; ++i) {
                  k1[i] = h * dydx[i];
                  temp[i] = y[i] + k1[i] / RealType(2);
              }

              // --- Second intermediate step ---
              calculate_dydx(x + h / RealType(2), temp, dydx);
              for (std::size_t i = 0; i < n; ++i) {
                  k2[i] = h * dydx[i];
                  temp[i] = y[i] + k2[i] / RealType(2);
              }

              // --- Third intermediate step ---
              calculate_dydx(x + h / RealType(2), temp, dydx);
              for (std::size_t i = 0; i < n; ++i) {
                  k3[i] = h * dydx[i];
                  temp[i] = y[i] + k3[i];
              }

              // --- Fourth intermediate step ---
              calculate_dydx(x + h, temp, dydx);
              // 不用定义 k4，因为只用一次
              // --- Combine the slopes and update y ---
              for (std::size_t i = 0; i < n; ++i) y[i] += (k1[i] + RealType(2) * k2[i] + RealType(2) * k3[i] + h * dydx[i]) / RealType(6);

              x += h;  // ONE step forward
          }

          // 自行创建工作区的 step 函数，方便外部直接调用；但其效率因为反复创建工作区而较低，不推荐在内部使用
          template<typename RealType, typename DerivFunc>
              requires std::is_floating_point_v<RealType>&& std::invocable<DerivFunc, RealType, std::span<const RealType>, std::span<RealType>>
          void step(RealType& x, std::span<RealType> y, RealType h, DerivFunc&& calculate_dydx)
          {
              RK4Workspace<RealType> ws(y.size());
              step(x, y, h, std::forward<DerivFunc>(calculate_dydx), ws); // std::forward 是转发
          }

      }


      template<typename RealType = double>
          requires std::is_floating_point_v<RealType>
      class RK4Solver {
      public:
          using State = std::pair<RealType, std::vector<RealType>>;
          using FuncPtrType = void (*)(RealType, std::span<const RealType>, std::span<RealType>); // function pointer

          // 构造函数
          RK4Solver(FuncPtrType f_ptr, RealType x0, std::span<const RealType> y0, RealType h, std::size_t n)
              : ode_function(f_ptr)
          {
              set_initial_state(x0, y0);
              set_current_state(x0, y0);
              set_steps(h, n);
          }
          explicit RK4Solver(FuncPtrType f_ptr) : RK4Solver(f_ptr, RealType(0), {}, RealType(0), 0) {}
          RK4Solver() : RK4Solver(nullptr) {}

          // 重新设置 ODE 函数
          void set_ode_function(FuncPtrType f_ptr) { ode_function = f_ptr; }

          // 设置状态
          void set_initial_state(RealType x0, std::span<const RealType> y0)
          {
              initial_state.first = x0;
              initial_state.second.assign(y0.begin(), y0.end());
          }
          void set_current_state(RealType x, std::span<const RealType> y)
          {
              current_state.first = x;
              current_state.second.assign(y.begin(), y.end());
          }

          // 设置步长和步数
          void set_steps(RealType h, std::size_t n)
          {
              step_length = h;
              steps = n;
          }

          // 重置求解器至尚未初始化的状态
          void reset_all()
          {
              ode_function = nullptr;
              initial_state = {RealType(0), {}};
              current_state = {RealType(0), {}};
              step_length = RealType(0);
              steps = 0;
              state_history = {};
              workspace = {};
          }
          // 重置到 initial_state，保留 ODE 函数、步长和步数
          void reset_to_initial()
          {
              current_state = initial_state;
              state_history = {};
              workspace = {};
          }

          const State& get_initial_state() const { return initial_state; }
          RealType get_initial_independent_variable() const { return initial_state.first; }
          const std::vector<RealType>& get_initial_dependent_variables() const { return initial_state.second; }

          RealType get_step_length() const { return step_length; }
          std::size_t get_steps() const { return steps; }

          const State& get_current_state() const { return current_state; }
          RealType get_current_independent_variable() const { return current_state.first; }
          const std::vector<RealType>& get_current_dependent_variables() const { return current_state.second; }

          // 返回所有历史状态组成的 std::vector 的 const reference，避免拷贝
          const std::vector<State>& get_history() const { return state_history; }

          // 从 current_state 出发继续求解；返回当前状态（最后一步结束后的状态）的 const reference
          const State& solve()
          {
              if (ode_function == nullptr) throw std::runtime_error("ODE function pointer is null.");
              if (step_length == RealType(0)) throw std::runtime_error("Step length is zero.");
              if (steps == 0) throw std::runtime_error("Number of steps is zero.");
              if (initial_state.second.empty()) throw std::runtime_error("Initial dependent variables are empty.");

              workspace = {};
              workspace.resize(current_state.second.size()); // 初始化工作区，确保其大小足够

              if (state_history.empty()) {
                  state_history.reserve(steps + 1); // 预分配空间，避免多次扩容
                  state_history.push_back(current_state);
              } else {
                  state_history.reserve(state_history.size() + steps); // 预分配空间，避免多次扩容
              }

              for (std::size_t i = 0; i < steps; ++i) {
                  step::step<RealType>(current_state.first, current_state.second, step_length, ode_function, workspace);
                  state_history.push_back(current_state); // 每前进一步，就保存一次状态
              }

              return current_state;
          }
          // 从 current_state 出发，重新设置步长和步数，继续求解；返回当前状态（最后一步结束后的状态）的 const reference
          const State& solve(RealType h, std::size_t n)
          {
              set_steps(h, n);
              return solve();
          }

          // 重新设置 initial_state 和步长、步数并求解；返回当前状态（最后一步结束后的状态）的 const reference
          const State& solve(RealType x, std::span<const RealType> y, RealType h, std::size_t n)
          {
              set_initial_state(x, y);
              set_current_state(x, y);
              set_steps(h, n);

              return solve();
          }

      private:
          FuncPtrType ode_function {nullptr};
          State initial_state {RealType(0), {}}; // 需要维护 initial_state，因为求解从 current_state 开始，而 current_state 可能不是 initial_state
          State current_state {RealType(0), {}};
          RealType step_length {RealType(0)};
          std::size_t steps {0};
          std::vector<State> state_history {};
          RK4Workspace<RealType> workspace {};  // 内部维护一个工作区，避免重复创建工作区变量
      };

  } // namespace rk4
  #endif // RK4_H

  ```
]

== A practical example

#figure(caption: [A simple example.])[
  ```cpp
  #include <iostream>
  #include <cmath>
  #include <span>
  #include <array>
  #include <vector>
  #include "header_files/rk4.hpp"

  // 谐振子右端函数：dx/dt = v, dv/dt = - x
  void ode_function(double t, std::span<const double> y, std::span<double> dydx) {
      dydx[0] = y[1]; // dx/dt = v
      dydx[1] = -y[0]; // dv/dt = - x
  }

  // 为 std::vector<rk4::RK4Solver<double>::State> 重载 << 运算符，方便输出历史状态
  std::ostream& operator<<(std::ostream& os, const std::vector<rk4::RK4Solver<double>::State>& history) {
      for (auto& state : history) {
          double t = state.first;
          auto& y = state.second;
          double error_x = y[0] - std::cos(t);
          double error_v = y[1] + std::sin(t);
          double error = std::sqrt(error_x * error_x + error_v * error_v);
          os << "t: " << t << ", x: " << y[0] << ", v: " << y[1] << ", error: " << error << "\n";
      }
      os << "\n" << "History size: " << history.size() << "\n";
      return os;
  }

  int main()
  {
      rk4::RK4Solver<double> solver {ode_function}; // 创建 RK4 求解器对象

      solver.solve(0.0, std::array<double, 2> {1.0, 0.0}, 0.01, 100); // 从 initial_state = (0.0, {1.0, 0.0}) 开始，以 0.01 为步长求解 100 步
      auto herstory = solver.get_history(); // auto 是按值推导，如果不写 & （就像这里一样）得到的就是 copy of state_history
      const auto& history = solver.get_history(); // 这里得到的是 const reference of state_history；同 auto& history = solver.get_history();, 因为 const 可以被推导出来
      solver.solve(0.02, 100); // 从上一次求解所得的结果出发，以 0.02 为步长求解 100 步
      solver.solve(0.01, 100); // 从上一次求解所得的结果出发，以 0.01 为步长求解 100 步

      std::cout << history << "\n\n\n" << herstory << "\n\nHistory has changed, but herstory is not.";
      // history 指向的 state_history 已经被修改了，而 herstory 是在第一次调用 get_history() 时的 copy，所以 herstory 没有被修改
      // const 是说 history 不能被直接修改，而不是说 history 指向的 state_history 不能被修改
      // 当 history 指向的 state_history 被修改时，history 作为引用也就被间接修改了
      return 0;
  }

  ```
]
#bibliography("ref.bib")
