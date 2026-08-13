// 虚数单位
#let ii = $upright(i) #h(0.05em)$
// Euler 数 e
#let ee = $upright(e)$
// Pi: 只需要 upright
#let pi = $upright(pi)$
// 数学环境中的“正体”
#let rm(x) = math.upright(x)
// 数学环境中的“加粗”
#let bm(x) = math.bold(x)
//#let bf(x) = math.bold(math.upright(x)) // 数学环境中的“正体加粗”
// 数学环境中的“单位向量”：加粗带 hat
#let uv(x) = math.hat(bm(x))
// 加速度的记号：两点; 同 diaer(x)
#let ddot(x) = math.dot.double(x)
// 竖向双点乘
#let ddotV = $:$
// 横向双点乘
#let ddotH = $dot.c#h(0em)dot.c$
// wedge product
#let wedge = $and$
// tensor product
#let tensor = $times.o$
// 某个量的微分（后面接一个长度为 1/6 em 的小空格）
#let dd(x, dim: h(-1em)) = $dif^(#dim) #x thin$
#let de(x, dim: h(-1em)) = $delta^(#dim)#h(-0.1em) #x$
#let De(x, dim: h(-1em)) = $Delta^(#dim)#h(-0.1em) #x$
// dx/dt
#let dv(x, t, dim: h(-1em), style: "vertical") = math.frac($dif^(#dim) #x$, $dif #t^(#dim)$, style: style)
// partial x/partial t
#let pdv(x, t, dim: h(-1em), style: "vertical") = math.frac($partial^(#dim) #x$, $partial #t^(#dim)$, style: style)
// Dirac bra-ket notation, 期望的符号；自动根据内部包裹的内容调整大小
#let braket(x) = $lr(chevron.l #x chevron.r)$
#let bra(x) = $lr(chevron.l #x |)$
#let ket(x) = $lr(| #x chevron.r)$
// 表征量的阶数的大 O 符号
#let order(x) = $cal(O)(#x)$
#let higherOrder(x) = $cal(o)(#x)$
