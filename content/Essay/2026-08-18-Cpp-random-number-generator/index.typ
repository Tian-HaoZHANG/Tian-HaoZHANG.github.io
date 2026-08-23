#import "../index.typ": template, tufted
// convinent math operations
#import "../../../mod.typ": *
// 如需生成 RSS feed，必须填写 title、description 和 date 元数据

#let title = "C++ random number generator template"
#let description = "Generate uniformly or normally distributed random numbers, one at a single call; only the standard library is used."

#show: template.with(
  title: title,
  description: description,
  date: datetime(year: 2026, month: 8, day: 18),
  lang: "en",
)

= #title
#description\
Refs: @website:博客园的一个教程 @website:std::random随机数库 @book:a-tour-of-cpp @website:cppreference.

== A minimum prototype

#figure(caption: [A minimum prototype of a random number generator in C++.])[
  ```cpp
  #include <iostream>
  #include <random>

  /*
  #include <limits>
  #include <cstdint>
  void test_random_device()
  {
      std::random_device rd {};

      std::cout << "Entropy: " << rd.entropy() << "\n\n"; // 如果返回 0 则说明这是伪随机数，> 0 则是真随机数
      std::cout << "Min value: " << std::numeric_limits<std::random_device::result_type>::min() << "\n";
      std::cout << "Max value: " << std::numeric_limits<std::random_device::result_type>::max() << "\n\n";

      std::cout << "Max value of int: " << std::numeric_limits<int>::max() << "\n";
      std::cout << "Max value of unsigned int: " << std::numeric_limits<unsigned int>::max() << "\n";
      std::cout << "Max value of long: " << std::numeric_limits<long>::max() << "\n";
      std::cout << "Max value of unsigned long: " << std::numeric_limits<unsigned long>::max() << "\n";
      std::cout << "Max value of long long: " << std::numeric_limits<long long>::max() << "\n";
      std::cout << "Max value of unsigned long long: " << std::numeric_limits<unsigned long long>::max() << "\n";
      std::cout << "Max value of std::int32_t: " << std::numeric_limits<std::int32_t>::max() << "\n";
      std::cout << "Max value of SeedType: " << std::numeric_limits<SeedType>::max() << "\n";
      std::cout << "Max value of std::int64_t: " << std::numeric_limits<std::int64_t>::max() << "\n";
      std::cout << "Max value of std::uint64_t: " << std::numeric_limits<std::uint64_t>::max() << "\n";
  }
  */

  // 生成服从正态分布的 double 随机数的 function object (functor)
  class RandNormal {
  public:
      // 真随机数生产成本太高，因此我们以真随机数（但不同平台不一样，有的平台 random_device 生成的也是伪随机数）为种子，批量生产伪随机数
      RandNormal(double mean, double stddev) : dist {mean, stddev} { re.seed(std::random_device {}()); } // 用 random_device 生成一个真随机种子
      double operator()() { return dist(re); } // 播种后的引擎可以高效地产生伪随机数，dist 进而将其映射到正态分布
      // 这样定义以后，我们在使用时就可以通过 function call () 访问随机数
      void seed(SeedType s) { re.seed(s); } // 允许人为指定种子，便于复现随机数序列
  private:
      std::mt19937 re; // 将 梅森绞扭器 (Mersenne Twister) 作为随机数引擎
      std::normal_distribution<double> dist; // 正态分布
  };

  int main()
  {
      /*
      using SeedType = std::random_device::result_type;
      test_random_device(); // 测试 random_device 的熵和 result_type
      */

      RandNormal r {0.0, 1.0}; // 像定义变量一样定义一个随机数生成器对象 r

      for (int i = 0; i < 10; ++i) {
          std::cout << r() << "\n"; // 通过 function call () 访问随机数
      }

      return 0;
  }

  ```]

== The .hpp header file
#figure(caption: [The template.])[
  ```cpp
  // 宏守卫 #ifndef... 保证这个宏只被定义一次，从而保证这个头文件只被 #include 一次；#pragma once 是较新的方式，此时不用 #define... 和 #endif //...
  #ifndef RANDOM_NUMBER_HPP
  #define RANDOM_NUMBER_HPP

  #include <random>
  #include <vector> // 保存种子序列
  #include <cstddef> // for std::size_t
  #include <type_traits> // for std::is_arithmetic_v<>, std::is_integral_v<>, std::conditional_t and std::is_floating_point_v<>
  #include <optional> // for std::optional<>；optional 通过解引用 * 或 .value() 访问值，std::nullopt 表示无值
  #include <stdexcept> // for std::invalid_argument

  namespace random_number_generator {
      // 能够从本头文件直接获取的分布类型
      enum class MyDistributionType {
          uniform,
          normal
      };

      using SeedType = std::random_device::result_type; // unsigned int

      // 理论上可以用均匀分布生成任意分布（涉及反函数，见概率论教材）
      // 生成服从均匀分布的随机数
      template<typename T = double, typename Engine = std::mt19937_64> // 模板参数：T 是生成的随机数类型，Engine 是随机数引擎类型
          requires std::is_arithmetic_v<T>&& std::uniform_random_bit_generator<Engine> // 要求 T 是算术类型（整数或浮点数），Engine 是符合概束 uniform_random_bit_generator 的随机数引擎
      // 概束 uniform_random_bit_generator<G> 指定了 G 是一种均匀随机比特生成器类型，也就是说，类型 G 的对象是一个函数对象 (function object, functor)，它返回 SeedType，使得在可能结果范围内的每个值都具有（理想上）相等的返回概率
      class RandUniform {
      public:
          // 便于外部使用的数据类型别名
          using value_type = T;
          // 便于外部使用的随机数引擎类型别名
          using engine_type = Engine;

          // 根据 T 的类型选择整数分布或实数分布
          using distribution_type = std::conditional_t<
              std::is_integral_v<T>,
              std::uniform_int_distribution<T>,
              std::uniform_real_distribution<T>
          >;

          // 统计信息使用的浮点类型（即，若 T 为整数则使用 double）
          using RealType = std::conditional_t<std::is_floating_point_v<T>, T, double>;

          // 状态结构体
          struct State {
              Engine re; // 随机数引擎
              T low = static_cast<T>(0); // 区间左端点
              T high = static_cast<T>(1); // 区间右端点
              distribution_type dist {static_cast<T>(0), static_cast<T>(1)}; // 均匀分布：默认为 [0.0, 1.0) 或 [int(0), int(1)] 上的均匀分布
              std::vector<SeedType> current_seed = {}; // 当前种子序列
              std::size_t count = 0; // 已经生成了的随机数数目
              std::optional<T> current_value = std::nullopt; // 当前（或者说，上一个）随机数取值；optional 通过解引用 * 或 .value() 访问值，std::nullopt 表示无值
              // 是否要维护以下变量取决于目的：如果只是大批量生成随机数，则不需要维护 sum 和 sum_sq；如果要统计均值和方差，则需要维护 mean 和 sum_Welford
              RealType mean = static_cast<RealType>(0); // 已经生成的随机数的均值，用于计算均值
              RealType sum_Welford = static_cast<RealType>(0); // 已经生成的随机数的 Welford 算法中的 M2，用于计算方差
          };

          // ---------- 构造函数 ----------
          // 允许用户指定分布区间 [low, high)
          // 若不指定 low 则默认为 [0, high)
          // 若都不指定则默认为 [0, 1)
          // 对整数为闭区间
          RandUniform(T low, T high)
              : current_state {make_state(low, high)}
          {
              seed(); // make_state 不设置种子，用 random_device 生成一个随机种子
          }
          explicit RandUniform(T high) : RandUniform(static_cast<T>(0), high) {} // 委托构造函数
          RandUniform() : RandUniform(static_cast<T>(0), static_cast<T>(1)) {} // 委托构造函数

          // 允许从状态结构体构造对象，便于从保存的状态直接恢复；explicit 避免隐式转换
          explicit RandUniform(const State& state)
              : current_state {state}
          {
              if (current_state.low > current_state.high) throw std::invalid_argument("Uniform distribution requires low <= high.");
              if (current_state.current_seed.empty()) seed(); // 若没有种子则用 random_device 生成一个随机种子；注意 seed() 中调用了 reset_state() —— 由于原本就没有种子，我们直接造一个新的即可
          }

          // ---------- 通过 function call () 访问随机数 ----------
          T operator()() noexcept
          {
              T temp = current_state.dist(current_state.re); // 摇一个随机数，保存到临时变量 temp 中
              current_state.current_value = temp; // 更新 current_value
              ++(current_state.count); // 计数器加一
              RealType n = static_cast<RealType>(current_state.count);
              RealType delta = static_cast<RealType>(temp) - current_state.mean;
              current_state.mean += delta / n;
              current_state.sum_Welford += delta * (static_cast<RealType>(temp) - current_state.mean); // 这里用的是 Welford 算法，避免了数值不稳定性

              return temp;
          }

          // ---------- 状态查询 ----------
          // [[nodiscard]] 表示调用者不应忽略返回值；noexcept 表示函数不会抛出异常；被标记为 const 的函数不会修改调用它的对象 (即 *this, this 指针指向的对象) 的状态

          [[nodiscard]] const State& get_current_state() const noexcept { return current_state; } // 返回当前状态结构体
          [[nodiscard]] T get_low() const noexcept { return current_state.low; } // 返回当前分布区间的左端点
          [[nodiscard]] T get_high() const noexcept { return current_state.high; } // 返回当前分布区间的右端点
          [[nodiscard]] const auto& get_current_distribution() const noexcept { return current_state.dist; } // 返回当前分布
          [[nodiscard]] const std::vector<SeedType>& get_current_seed() const noexcept { return current_state.current_seed; } // 返回当前种子；有可能为空
          [[nodiscard]] std::size_t get_count() const noexcept { return current_state.count; } // 返回已经生成的随机数数目
          [[nodiscard]] std::optional<T> get_current_value() const noexcept { return current_state.current_value; } // 返回当前（或者说，上一个）随机数取值

          // ---------- 统计信息 ----------

          // 样本均值
          [[nodiscard]] RealType get_sample_mean() const noexcept {
              return current_state.count > 0 ? current_state.mean : static_cast<RealType>(0);
          }
          // 样本方差（除以 N - 1）
          [[nodiscard]] RealType get_sample_variance() const noexcept
          {
              if (current_state.count < 2) return static_cast<RealType>(0);
              return current_state.sum_Welford / static_cast<RealType>(current_state.count - 1);
          }

          // ---------- 状态修改 ----------

          // 将已有状态载入当前变量；不自动播种，保持所加载的引擎的状态
          void load_state(const State& state)
          {
              if (state.low > state.high) throw std::invalid_argument("Uniform distribution requires low <= high.");
              current_state = state;
              // 不自动播种，保持所加载的引擎的状态
          }

          // 尚未播种时调用，用包含四个 random_device 随机数的 seed_seq 播种
          void seed()
          {
              std::random_device rd {};
              SeedType s0 = rd(), s1 = rd(), s2 = rd(), s3 = rd();
              std::seed_seq seq {s0, s1, s2, s3};
              current_state.re.seed(seq);

              std::vector<SeedType>().swap(current_state.current_seed); // 清空当前种子
              current_state.current_seed.reserve(4); // 预留空间，避免多次分配
              current_state.current_seed.assign({s0, s1, s2, s3});

              reset_state(); // 注意：播种时将所有状态都初始化了
          }

          // 用任意数目的 SeedType 序列播种，同时保存该序列供 reset() 复现
          void seed(std::vector<SeedType> seeds) // 这里必须传递 copy, 否则用 current_seed 设置 seed 会先清空 current_seed
          {
              if (seeds.empty()) seed();
              std::seed_seq seq(seeds.begin(), seeds.end());
              current_state.re.seed(seq);

              std::vector<SeedType>().swap(current_state.current_seed); // 清空当前种子
              current_state.current_seed = std::move(seeds); // move assignment

              reset_state();
          }

          // 用任意数目的非负整数序列播种的便捷变参形式：seed(4638, 1169, 5752, ...)
          template<typename... IntegerType>
              requires (std::is_integral_v<IntegerType> &&...)
          void seed(IntegerType... seeds) { seed(std::vector<SeedType> {static_cast<SeedType>(seeds)...}); }

          // 将随机数发生器恢复到初始状态（引擎和种子的状态都一致，因而再调用时会产生跟原来一样的随机数序列）
          void reset()
          {   // reset() 跟 reset_state() 的区别在于，reset_state() 并未初始化引擎 —— 引擎默认以上一步的随机数值作为下一次的种子（这正是种子的含义），而我们为了复现而保存的是最初的种子
              if (!(current_state.current_seed.empty())) {
                  seed(current_state.current_seed);
              } else {
                  seed(); // 若没有种子则用 random_device 生成一个随机种子
              }
          }
          // 重新设置分布区间 [low, high)；对整数为闭区间
          void reset_distribution(T low, T high)
          {
              if (low > high) throw std::invalid_argument("Uniform distribution requires low <= high.");
              reset_state();
              current_state.low = low;
              current_state.high = high;
              current_state.dist = distribution_type(low, high);
          }

      private:
          State current_state; // 当前状态

          // ---------- 内部辅助函数 ----------

          // 从指定的区间 [low, high) 创建状态结构体；不设置种子
          static State make_state(T low = static_cast<T>(0), T high = static_cast<T>(1))
          {
              if (low > high) throw std::invalid_argument("Uniform distribution requires low <= high.");
              return {
                  Engine{}, // re
                  low, // low
                  high, // high
                  distribution_type{low, high}, // dist
                  {}, // current_seed
                  0, // count
                  std::nullopt, // current_value
                  static_cast<RealType>(0), // mean
                  static_cast<RealType>(0) // sum_Welford
              };
          }
          // 清空分布缓存、计数器、当前值、和以及平方和，不改变分布区间和种子
          void reset_state() noexcept
          {
              current_state.dist.reset();
              current_state.count = 0;
              current_state.current_value = std::nullopt;
              current_state.mean = static_cast<RealType>(0);
              current_state.sum_Welford = static_cast<RealType>(0);
          }
      };










      // 生成服从正态分布的浮点随机数
      template<typename RealType = double, typename Engine = std::mt19937_64> // 模板参数：RealType 是生成的随机数类型，Engine 是随机数引擎类型
          requires std::is_floating_point_v<RealType>&& std::uniform_random_bit_generator<Engine> // 要求 RealType 是浮点类型，Engine 是符合概束 uniform_random_bit_generator 的随机数引擎
      class RandNormal {
      public:
          // 便于外部使用的数据类型别名
          using value_type = RealType;
          // 便于外部使用的随机数引擎类型别名
          using engine_type = Engine;

          // 状态结构体
          struct State {
              Engine re; // 随机数引擎
              RealType mu = static_cast<RealType>(0); // 均值
              RealType sigma = static_cast<RealType>(1); // 标准差
              std::normal_distribution<RealType> dist {static_cast<RealType>(0), static_cast<RealType>(1)}; // 正态分布：默认为均值 0，标准差 1
              std::vector<SeedType> current_seed = {}; // 当前种子序列
              std::size_t count = 0; // 已经生成了的随机数数目
              std::optional<RealType> current_value = std::nullopt; // 当前（或者说，上一个）随机数取值；optional 通过解引用 * 或 .value() 访问值，std::nullopt 表示无值
              RealType mean = static_cast<RealType>(0); // 已经生成的随机数的均值，用于计算均值
              RealType sum_Welford = static_cast<RealType>(0); // 已经生成的随机数的 Welford 算法中的 M2，用于计算方差
          };

          // ---------- 构造函数 ----------

          // 允许用户指定均值和标准差
          // 如果都不指定（不允许仅指定一个），则默认为均值 0，标准差 1
          RandNormal(RealType mean, RealType standard_deviation)
              : current_state {make_state(mean, standard_deviation)}
          {
              seed(); // make_state 不设置种子，用 random_device 生成一个随机种子
          }
          RandNormal() : RandNormal(static_cast<RealType>(0), static_cast<RealType>(1)) {} // 委托构造函数
          // 允许从状态结构体构造对象，便于从保存的状态直接恢复；explicit 避免隐式转换
          explicit RandNormal(const State& state)
              : current_state {state}
          {
              if (current_state.sigma <= static_cast<RealType>(0)) throw std::invalid_argument("Standard deviation must be positive.");
              if (current_state.current_seed.empty()) seed(); // 若没有种子则用 random_device 生成一个随机种子；注意 seed() 中调用了 reset_state() —— 由于原本就没有种子，我们直接造一个新的即可
          }

          // 通过 function call () 访问随机数
          RealType operator()() noexcept
          {
              RealType temp = current_state.dist(current_state.re); // 摇一个随机数，保存到临时变量 temp 中
              current_state.current_value = temp; // 更新 current_value
              ++(current_state.count);
              RealType n = static_cast<RealType>(current_state.count);
              RealType delta = temp - current_state.mean;
              current_state.mean += delta / n;
              current_state.sum_Welford += delta * (temp - current_state.mean); // 这里用的是 Welford 算法，避免了数值不稳定性

              return temp;
          }

          // ---------- 状态查询 ----------
          // [[nodiscard]] 表示调用者不应忽略返回值；noexcept 表示函数不会抛出异常；被标记为 const 的函数不会修改调用它的对象 (即 *this, this 指针指向的对象) 的状态

          [[nodiscard]] const State& get_current_state() const noexcept { return current_state; } // 返回当前状态结构体
          [[nodiscard]] RealType get_mu() const noexcept { return current_state.mu; } // 返回当前分布的均值；注意这是分布参数，不是样本均值
          [[nodiscard]] RealType get_sigma() const noexcept { return current_state.sigma; } // 返回当前分布的标准差；注意这是分布参数，不是样本标准差
          [[nodiscard]] const auto& get_current_distribution() const noexcept { return current_state.dist; } // 返回当前分布
          [[nodiscard]] const std::vector<SeedType>& get_current_seed() const noexcept { return current_state.current_seed; } // 返回当前种子序列；有可能为空
          [[nodiscard]] std::size_t get_count() const noexcept { return current_state.count; } // 返回已经生成的随机数数目
          [[nodiscard]] std::optional<RealType> get_current_value() const noexcept { return current_state.current_value; } // 返回当前（或者说，上一个）随机数取值

          // ---------- 统计信息 ----------

          // 样本均值
          [[nodiscard]] RealType get_sample_mean() const noexcept {
              return current_state.count > 0 ? current_state.mean : static_cast<RealType>(0);
          }
          // 样本方差（除以 N - 1）
          [[nodiscard]] RealType get_sample_variance() const noexcept
          {
              if (current_state.count < 2) return static_cast<RealType>(0);
              return current_state.sum_Welford / static_cast<RealType>(current_state.count - 1);
          }

          // ---------- 状态修改 ----------
          // 将已有状态载入当前变量；不自动播种，保持所加载的引擎的状态
          void load_state(const State& state)
          {
              if (state.sigma <= static_cast<RealType>(0)) throw std::invalid_argument("Standard deviation must be positive.");
              current_state = state;
              // 不自动播种，保持所加载的引擎的状态
          }

          // 尚未播种时调用，用包含四个 random_device 随机数的 seed_seq 播种
          void seed()
          {
              std::random_device rd {}; // using SeedType = std::random_device::result_type; // unsigned int
              SeedType s0 = rd(), s1 = rd(), s2 = rd(), s3 = rd();
              std::seed_seq seq {s0, s1, s2, s3};
              current_state.re.seed(seq);

              std::vector<SeedType>().swap(current_state.current_seed); // 清空当前种子
              current_state.current_seed.reserve(4); // 预留空间，避免多次分配
              current_state.current_seed.assign({s0, s1, s2, s3});

              reset_state();
          }

          // 用任意数目的 SeedType 序列播种，同时保存该序列供 reset() 复现
          void seed(std::vector<SeedType> seeds) // 这里必须传递 copy, 否则用 current_seed 设置 seed 会先清空 current_seed
          {
              if (seeds.empty()) seed();
              std::seed_seq seq(seeds.begin(), seeds.end());
              current_state.re.seed(seq);

              std::vector<SeedType>().swap(current_state.current_seed); // 清空当前种子
              current_state.current_seed = std::move(seeds); // move assignment

              reset_state();
          }

          // 用任意数目的非负整数序列播种的便捷变参形式：seed(4638, 1169, 5752, ...)
          template<typename... IntegerType>
              requires (std::is_integral_v<IntegerType> &&...)
          void seed(IntegerType... seeds) { seed(std::vector<SeedType> {static_cast<SeedType>(seeds)...}); }

          // 将随机数发生器恢复到初始状态（引擎和种子的状态都一致，因而再调用时会产生跟原来一样的随机数序列）
          void reset()
          {   // reset() 跟 reset_state() 的区别在于，reset_state() 并未初始化引擎 —— 引擎默认以上一步的随机数值作为下一次的种子（这正是种子的含义），而我们为了复现而保存的是最初的种子
              if (!(current_state.current_seed.empty())) {
                  seed(current_state.current_seed);
              } else {
                  seed(); // 若没有种子则用 random_device 生成一个随机种子
              }
          }

          // 重新设置分布的均值和标准差
          void reset_distribution(RealType mean, RealType standard_deviation)
          {
              if (standard_deviation <= static_cast<RealType>(0)) throw std::invalid_argument("Standard deviation must be positive.");
              reset_state();
              current_state.mu = mean;
              current_state.sigma = standard_deviation;
              current_state.dist = std::normal_distribution<RealType>(mean, standard_deviation);
          }

      private:
          State current_state; // 当前状态

          // ---------- 内部辅助函数 ----------
          //从指定的均值和标准差创建状态结构体；不设置种子
          static State make_state(RealType mu = static_cast<RealType>(0), RealType sigma = static_cast<RealType>(1))
          {
              if (sigma <= static_cast<RealType>(0)) throw std::invalid_argument("Standard deviation must be positive.");
              return {
                  Engine{}, // re
                  mu, // mu
                  sigma, // sigma
                  std::normal_distribution<RealType>{mu, sigma}, // dist
                  {}, // current_seed
                  0, // count
                  std::nullopt, // current_value
                  static_cast<RealType>(0), // mean
                  static_cast<RealType>(0) // sum_Welford
              };
          }
          // 清空分布缓存、计数器、当前值、和以及平方和，不改变分布参数和种子
          void reset_state() noexcept
          {
              current_state.dist.reset();
              current_state.count = 0;
              current_state.current_value = std::nullopt;
              current_state.mean = static_cast<RealType>(0);
              current_state.sum_Welford = static_cast<RealType>(0);
          }
      };
  } // namespace random_number_generator

  #endif // RANDOM_NUMBER_HPP

  ```]

== Test program

#tufted.margin-note({
  image("normal_distribution_validation.png")
})

#tufted.margin-note[
  Validation of the generated normal distribution.
]

#figure(caption: [A test program, also serve as a simple example.])[
  ```cpp
  #include <iostream> // for std::cout
  #include "header_files/random_number.hpp" // for namespace random_number_generator
  #include <vector> // for std::vector; 用 std::array 会栈溢出
  #include <numeric> // for std::accumulate, std::reduce
  #include <algorithm> // for std::generate, std::for_each
  #include <execution> // for std::execution::seq, par, unseq, par_unseq
  #include <cstddef> // for std::size_t
  #include "header_files/CPU_timer.hpp" // for CPU_timer::CPUTimer


  int main()
  {
      CPU_timer::CPUTimer timer;

      random_number_generator::RandNormal r {}; // 像定义变量一样定义一个随机数生成器对象 r
      // r.seed(4638, 1169, 5752, 9876);
      std::cout << r() << "  " << r() << "\n"; // 通过 function call () 访问随机数
      std::cout << "Current value = " << *(r.get_current_value()) << "\n"; // 查看当前随机数值

      r.reset(); // 等价于 r.seed(r.get_current_seed());

      constexpr std::size_t N = 1000'0000;
      std::vector<double> v(N, 0.0);
      std::generate(std::execution::par_unseq, v.begin(), v.end(), [&]() {return r();}); // 使用 Lambda 表达式做谓词，批量向 v 中生成随机数
      std::cout << v[0] << "  " << v[1] << "\n"; // 通过 function call () 访问随机数
      double mean = std::reduce(std::execution::par_unseq, v.begin(), v.end(), 0.0) / double(N);

      std::for_each(std::execution::par_unseq, v.begin(), v.end(), [=](double& x) { x -= mean; x *= x; }); // v 的每一个元素都减去 mean，然后平方
      double sample_var = std::reduce(std::execution::par_unseq, v.begin(), v.end(), 0.0) / double(N - 1);

      std::cout << "\nMean = " << mean << " == " << r.get_sample_mean() << "\nSample var = " << sample_var << " == " << r.get_sample_variance() << "\nNote that \"==\" needs reset().\n";

      std::cout << "CPU time: " << timer.elapsedNanoseconds() << " ns\n";

      return 0;
  }

  ```
]

#figure(caption: [Compare with Python numpy.])[
  ```python
  # It turns out that the Python numpy code is approximately of same performance as the -O2 optimized C++ code,
  # which is expected because numpy is implemented in C.
  import numpy as np
  import time

  def main():
      # 开始计时（CPU时间）
      t0 = time.process_time()

      N = 1000_0000
      print(f"Statistics of {N} normally distributed doubles in [0, 1):")
      # 生成服从 N 个标准正态分布的随机数
      data = np.random.randn(N)

      # 计算样本均值和样本方差（无偏估计，ddof=1）
      mean = np.mean(data)
      variance = np.var(data, ddof=1)

      print(f"Mean: {mean}")
      print(f"Sample variance: {variance}")

      # 结束计时
      t1 = time.process_time()
      elapsed_ms = (t1 - t0) * 1000
      print(
          f"CPU time: {elapsed_ms:.2f} ms"
      )  # 保留两位小数

  if __name__ == "__main__":
      main()
  ```
]

#bibliography("refs.bib")
