#import "../index.typ": template, tufted
// convinent math operations
#import "../../../mod.typ": *
// 如需生成 RSS feed，必须填写 title、description 和 date 元数据

#let title = "A C++ random number generator class"
#let description = "Generate uniformly or normally distributed random numbers, one at a time."

#show: template.with(
  title: title,
  description: description,
  date: datetime(year: 2026, month: 8, day: 18),
  lang: "en",
)

= #title
#description\
Refs: @website:博客园的一个教程 @book:a-tour-of-cpp @website:cppreference.

== A minimum prototype
```cpp
#include <iostream>
#include <random>

// 生成服从均匀分布的 double 随机数的 function object (functor)
class Rand_uniform {
public:
    // 真随机数生产成本太高，因此我们以真随机数为种子，批量生产伪随机数
    Rand_uniform(double low, double high) : dist {low, high} { re.seed(std::random_device {}()); } // 用 random_device 生成一个真随机种子
    double operator()() { return dist(re); } // 播种后的引擎可以高效地产生伪随机数，dist 进而将其映射到均匀分布
    // 这样定义以后，我们在使用时就可以通过 function call () 访问随机数
    void seed(unsigned int s) { re.seed(s); } // 允许人为指定种子，便于复现随机数序列
private:
    std::mt19937 re; // 将 梅森绞扭器 (Mersenne Twister) 作为随机数引擎
    std::uniform_real_distribution<double> dist; // 均匀分布
};

int main()
{
    Rand_uniform r {0.0, 1.0}; // 像定义变量一样定义一个随机数生成器对象 r
    for (int i = 0; i < 10; ++i) {
        std::cout << r() << "\n"; // 通过 function call () 访问随机数
    }
    std::cout << "\n";
    return 0;
}
```

== Uniform distribution

```cpp
#include <random>
#include <type_traits> // for std::is_arithmetic_v<>, std::is_integral_v<> and std::conditional_t
#include <limits> // for std::numeric_limits<>
#include <optional> // for std::optional<>
#include <stdexcept> // for std::invalid_argument
// 理论上可以用均匀分布生成任意分布（涉及反函数，见概率论教材）
// 生成服从均匀分布的随机数
template<typename T = double, typename Engine = std::mt19937_64> // 模板参数：T 是生成的随机数类型，Engine 是随机数引擎类型
    requires std::is_arithmetic_v<T>&& std::uniform_random_bit_generator<Engine> // 要求 T 是算术类型（整数或浮点数），Engine 是符合概述 uniform_random_bit_generator 的随机数引擎
// 概束 uniform_random_bit_generator<G> 指定了 G 是一种均匀随机比特生成器类型，也就是说，类型 G 的对象是一个函数对象 (function object, functor)，它返回 unsigned int，使得在可能结果范围内的每个值都具有（理想上）相等的返回概率
class Rand_uniform {
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

    // current_value 和 统计信息 使用的浮点类型（即，若 T 为整数则使用 double）
    using real_type = std::conditional_t<std::is_floating_point_v<T>, T, double>;

    // 状态结构体
    struct State {
        Engine re; // 随机数引擎
        T low = T(0); // 区间左端点
        T high = T(1); // 区间右端点
        distribution_type dist {T(0), T(1)}; // 均匀分布：默认为 [0.0, 1.0) 或 [int(0), int(1)] 上的均匀分布
        std::optional<unsigned int> current_seed = std::nullopt; // 当前种子；std::optional 表示可能有值也可能没有值，若没有值则表示尚未播种
        unsigned int count = 0; // 已经生成了的随机数数目
        real_type current_value = std::numeric_limits<real_type>::quiet_NaN(); // 当前（或者说，上一个）随机数取值；由于 optional<T> 不能跟 T 做算术运算，这里没有用 std::optional<real_type>，而是用浮点 NaN 表示尚未生成浮点随机数
        real_type sum = real_type(0); // 已经生成的随机数的和，用于计算均值
        real_type sum_sq = real_type(0); // 已经生成的随机数的平方和，用于计算方差
    };

    // ---------- 构造函数 ----------
    // 允许用户指定分布区间 [low, high)
    // 若不指定 low 则默认为 [0, high)
    // 若都不指定则默认为 [0, 1)
    Rand_uniform(T low, T high)
        : current_state {make_state(low, high)}
    {
        if (!current_state.current_seed) seed(); // 如果没有种子，则用 random_device 生成一个随机种子
    }
    Rand_uniform(T high) : Rand_uniform(T(0), high) {} // 委托构造函数
    Rand_uniform() : Rand_uniform(T(0), T(1)) {} // 委托构造函数

    // 允许从状态结构体构造对象，便于从保存的状态直接恢复；explicit 避免隐式转换
    explicit Rand_uniform(const State& state)
        : current_state {state}
    {
        validate_range(state.low, state.high);
        if (!current_state.current_seed) seed();
    }

    // ---------- 核心生成器：通过 function call () 生成随机数 ----------
    T operator()() noexcept
    {
        current_state.current_value = current_state.dist(current_state.re); // 摇一个随机数，保存到 current_value 中
        ++(current_state.count); // 计数器加一
        current_state.sum += current_state.current_value;
        current_state.sum_sq += current_state.current_value * current_state.current_value;
        return current_state.current_value;
    }

    // ---------- 状态查询 ----------
    // [[nodiscard]] 表示调用者不应忽略返回值；noexcept 表示函数不会抛出异常；被标记为 const 的函数不会修改调用它的对象 (即 *this, this 指针指向的对象) 的状态

    [[nodiscard]] State get_current_state() const noexcept { return current_state; } // 返回当前状态结构体
    [[nodiscard]] T get_low() const noexcept { return current_state.low; } // 返回当前分布区间的左端点
    [[nodiscard]] T get_high() const noexcept { return current_state.high; } // 返回当前分布区间的右端点
    [[nodiscard]] const auto& get_current_distribution() const noexcept { return current_state.dist; } // 返回当前分布
    [[nodiscard]] std::optional<unsigned int> get_current_seed() const noexcept { return current_state.current_seed; } // 返回当前种子；有可能无值 std::nullopt
    [[nodiscard]] unsigned int get_count() const noexcept { return current_state.count; } // 返回已经生成的随机数数目
    [[nodiscard]] real_type get_current_value() const noexcept { return current_state.current_value; } // 返回当前（或者说，上一个）随机数取值

    // ---------- 统计信息 ----------

    // 样本均值
    [[nodiscard]] real_type get_mean() const noexcept {
        return current_state.count > 0
            ? current_state.sum / static_cast<real_type>(current_state.count)
            : real_type(0);
    }
    // 按照总体方差公式计算的样本方差（除以 N）
    [[nodiscard]] real_type get_variance() const noexcept
    {
        if (current_state.count < 2) return real_type(0);
        const real_type mean = get_mean();
        const real_type n = static_cast<real_type>(current_state.count);
        return current_state.sum_sq / n - mean * mean;
    }
    // 样本方差（除以 N - 1）
    [[nodiscard]] real_type get_sample_variance() const noexcept
    {
        if (current_state.count < 2) return real_type(0);
        const real_type mean = get_mean();
        const real_type n = static_cast<real_type>(current_state.count);
        return current_state.sum_sq / (n - real_type(1)) - mean * mean * n / (n - real_type(1));
    }

    // ---------- 状态修改 ----------

    // 将已有状态载入当前变量；不自动播种，保持所加载的引擎的状态
    void load_state(const State& state)
    {
        validate_range(state.low, state.high);
        current_state = state;
        // 不自动播种，保持所加载的引擎的状态
    }
    // 人为指定种子；如果没有人为指定，则用 random_device 生成一个随机种子
    void seed(unsigned int s = std::random_device {}())
    {
        current_state.re.seed(s);
        current_state.current_seed = s;
        reset_state();
    }
    // 重新设置分布区间 [low, high)
    void reset_distribution(T low, T high)
    {
        validate_range(low, high);
        current_state.low = low;
        current_state.high = high;
        current_state.dist = distribution_type(low, high);
        reset_state();
    }

private:
    State current_state; // 当前状态

    // ---------- 内部辅助函数 ----------

    // 从指定的区间 [low, high) 创建状态结构体；不设置种子
    static State make_state(T low, T high)
    {
        validate_range(low, high);
        return {
            Engine{}, // re
            low, // low
            high, // high
            distribution_type{low, high}, // dist
            std::nullopt, // current_seed
            0, // count
            std::numeric_limits<real_type>::quiet_NaN(), // current_value
            real_type(0), // sum
            real_type(0) // sum_sq
        };
    }
    // 清空分布缓存、计数器、当前值、和以及平方和，不改变分布区间和种子
    void reset_state() noexcept
    {
        current_state.dist.reset();
        current_state.count = 0;
        current_state.current_value = std::numeric_limits<real_type>::quiet_NaN();
        current_state.sum = real_type(0);
        current_state.sum_sq = real_type(0);
    }

    // 验证分布区间是否有效
    static void validate_range(T low, T high) {
        if (low > high)
            throw std::invalid_argument("Uniform distribution requires low <= high.");
    }
};
```

== Normal distribution

```cpp
#include <random>
#include <type_traits> // for std::is_floating_point_v<>
#include <limits> // for std::numeric_limits<>
#include <optional> // for std::optional<>
#include <stdexcept> // for std::invalid_argument
// 生成服从均匀分布的浮点随机数
template<typename RealType = double, typename Engine = std::mt19937_64> // 模板参数：RealType 是生成的随机数类型，Engine 是随机数引擎类型
    requires std::is_floating_point_v<RealType>&& std::uniform_random_bit_generator<Engine> // 要求 RealType 是浮点类型，Engine 是符合概束 uniform_random_bit_generator 的随机数引擎
class Rand_normal {
public:
    // 便于外部使用的数据类型别名
    using value_type = RealType;
    // 便于外部使用的随机数引擎类型别名
    using engine_type = Engine;

    // 状态结构体
    struct State {
        Engine re; // 随机数引擎
        RealType mu = RealType(0); // 均值
        RealType sigma = RealType(1); // 标准差
        std::normal_distribution<RealType> dist {RealType(0), RealType(1)}; // 正态分布：默认为均值 0，标准差 1
        std::optional<unsigned int> current_seed = std::nullopt; // 当前种子；std::optional 表示可能有值也可能没有值
        unsigned int count = 0; // 已经生成了的随机数数目
        RealType current_value = std::numeric_limits<RealType>::quiet_NaN(); // 当前（或者说，上一个）随机数取值；由于 optional<RealType> 不能跟 RealType 做算术运算，这里没有用 std::optional<RealType>，而是用浮点 NaN 表示尚未生成浮点随机数
        RealType sum = RealType(0); // 已经生成的随机数的和，用于计算均值
        RealType sum_sq = RealType(0); // 已经生成的随机数的平方和，用于计算方差
    };

    // ---------- 构造函数 ----------

    // 允许用户指定均值和标准差
    // 如果都不指定（不允许仅指定一个），则默认为均值 0，标准差 1
    Rand_normal(RealType average, RealType standard_deviation)
        : current_state {make_state(average, standard_deviation)}
    {
        if (!current_state.current_seed) seed(); // 如果没有种子，则用 random_device 生成一个随机种子
    }
    Rand_normal() : Rand_normal(RealType(0), RealType(1)) {} // 委托构造函数
    // 允许从状态结构体构造对象，便于从保存的状态直接恢复；explicit 避免隐式转换
    explicit Rand_normal(const State& state)
        : current_state {state}
    {
        validate_sigma(current_state.sigma);
        if (!current_state.current_seed) seed();
    }

    // ---------- 核心生成器 ----------
    // 通过 function call () 生成随机数
    RealType operator()() noexcept
    {
        current_state.current_value = current_state.dist(current_state.re);
        ++(current_state.count);
        current_state.sum += current_state.current_value;
        current_state.sum_sq += current_state.current_value * current_state.current_value;
        return current_state.current_value;
    }

    // ---------- 状态查询 ----------
    // [[nodiscard]] 表示调用者不应忽略返回值；noexcept 表示函数不会抛出异常；被标记为 const 的函数不会修改调用它的对象 (即 *this, this 指针指向的对象) 的状态

    [[nodiscard]] State get_current_state() const noexcept { return current_state; } // 返回当前状态结构体
    [[nodiscard]] RealType get_mu() const noexcept { return current_state.mu; } // 返回当前分布的均值；注意这是分布参数，不是样本均值
    [[nodiscard]] RealType get_sigma() const noexcept { return current_state.sigma; } // 返回当前分布的标准差；注意这是分布参数，不是样本标准差
    [[nodiscard]] const auto& get_current_distribution() const noexcept { return current_state.dist; } // 返回当前分布
    [[nodiscard]] std::optional<unsigned int> get_current_seed() const noexcept { return current_state.current_seed; } // 返回当前种子；有可能无值 std::nullopt
    [[nodiscard]] unsigned int get_count() const noexcept { return current_state.count; } // 返回已经生成的随机数数目
    [[nodiscard]] RealType get_current_value() const noexcept { return current_state.current_value; } // 返回当前（或者说，上一个）随机数取值

    // ---------- 统计信息 ----------
    // 样本均值
    [[nodiscard]] RealType get_mean() const noexcept
    {
        return current_state.count > 0
            ? current_state.sum / static_cast<RealType>(current_state.count)
            : RealType(0);
    }
    // 根据总体方差公式计算出的样本方差 （除以 N）
    [[nodiscard]] RealType get_variance() const noexcept
    {
        if (current_state.count < 2) return RealType(0);
        const RealType mean = get_mean();
        const RealType n = static_cast<RealType>(current_state.count);
        return current_state.sum_sq / n - mean * mean;
    }
    // 样本方差 （除以 N - 1）
    [[nodiscard]] RealType get_sample_variance() const noexcept
    {
        if (current_state.count < 2) return RealType(0);
        const RealType mean = get_mean();
        const RealType n = static_cast<RealType>(current_state.count);
        return current_state.sum_sq / (n - RealType(1)) - mean * mean * n / (n - RealType(1));
    }

    // ---------- 状态修改 ----------
    // 将已有状态载入当前变量；不自动播种，保持所加载的引擎的状态
    void load_state(const State& state)
    {
        validate_sigma(state.sigma);
        current_state = state;
        // 不自动播种，保持所加载的引擎的状态
    }
    // 人为指定种子；如果没有人为指定，则用 random_device 生成一个随机种子
    void seed(unsigned int s = std::random_device {}())
    {
        current_state.re.seed(s);
        current_state.current_seed = s;
        reset_state();
    }
    // 重新设置分布的均值和标准差
    void reset_distribution(RealType average, RealType standard_deviation)
    {
        validate_sigma(standard_deviation);
        current_state.mu = average;
        current_state.sigma = standard_deviation;
        current_state.dist = std::normal_distribution<RealType>(average, standard_deviation);
        reset_state();
    }

private:
    State current_state; // 当前状态

    // ---------- 内部辅助函数 ----------
    //从指定的均值和标准差创建状态结构体；不设置种子
    static State make_state(RealType mu = RealType(0), RealType sigma = RealType(1))
    {
        validate_sigma(sigma);
        return {
            Engine{}, // re
            mu, // mu
            sigma, // sigma
            std::normal_distribution<RealType>{mu, sigma}, // dist
            std::nullopt, // current_seed
            0, // count
            std::numeric_limits<RealType>::quiet_NaN(), // current_value
            RealType(0), // sum
            RealType(0) // sum_sq
        };
    }
    // 清空分布缓存、计数器、当前值、和以及平方和，不改变分布参数和种子
    void reset_state() noexcept
    {
        current_state.dist.reset();
        current_state.count = 0;
        current_state.current_value = std::numeric_limits<RealType>::quiet_NaN();
        current_state.sum = RealType(0);
        current_state.sum_sq = RealType(0);
    }
    // 验证标准差是否有效
    static void validate_sigma(RealType sigma)
    {
        if (sigma <= RealType(0))
            throw std::invalid_argument("Standard deviation must be positive.");
    }
};
```


== Test program

```cpp
// To use these classes

#include <iostream>
#include "my_random_number.h"
#include <ctime>

int main()
{
    auto start = std::clock();

    constexpr int N = 1000'0000;
    std::cout << "Statistics of " << N << " normally distributed doubles in [0, 1):\n";

    random_number_generator::Rand_normal<double> r {0, 1};
    for (int i = 0; i < N; ++i) r();
    double mean = r.get_mean();
    double sample_variance = r.get_sample_variance();
    std::cout << "Average: " << mean << "\nSample variance: " << sample_variance << '\n';

    // 设置固定种子，复现随机序列
    r.seed(12345);
    std::cout << "\nAfter seed(12345), first value: " << r() << '\n';

    random_number_generator::Rand_normal r2;
    r.seed(12345);
    r2.seed(12345);
    std::cout << "Seeding again, same first value: " << r() << " == " << r2() << '\n';

    auto end = std::clock();
    double cpu_time = static_cast<double>(end - start);
    std::cout << "CPU time: " << cpu_time << "ms\n";
    return 0;
}
```

```python
# Compare with Python; it turns that the Python version is twice faster than the C++ one
import numpy as np
import time

def main():
    N = 1000_0000
    print(f"Statistics of {N} normally distributed doubles in [0, 1):")

    # 开始计时（CPU时间，包括用户态和系统态）
    t0 = time.process_time()

    # 生成 N 个标准正态分布随机数
    data = np.random.randn(N)

    # 计算样本均值和样本方差（无偏估计，ddof=1）
    mean = np.mean(data)
    variance = np.var(data, ddof=1)

    # 输出结果
    print(f"Average: {mean}")
    print(f"Sample variance: {variance}")
    # 结束计时
    t1 = time.process_time()
    elapsed_ms = (t1 - t0) * 1000
    print(
        f"CPU time: {elapsed_ms:.2f}ms"
    )  # 保留两位小数，与C++的整数毫秒稍有不同，但更精确

if __name__ == "__main__":
    main()

```

#bibliography("refs.bib")
