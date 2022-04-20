# Trapezoid

已知梯形ABCD，AB CD为底，AD BC为边，点P满足如下不等式时，点P在梯形ABCD内：

$(\vec{AP}\times\vec{AB})\cdot(\vec{DP}\times\vec{DC}) < 0\\
(\vec{AP}\times \vec{AD})\cdot(\vec{BP}\times\vec{BC}) < 0$

# Vector2

## 直线公式

已知点 $P,Q$

求直线
$$ax + by + c = 0$$
$$a = y_P - y_Q$$
$$b = x_Q - x_P$$
$$c = \begin{bmatrix} x_P & x_Q \\
y_P & y_Q \end{bmatrix}$$

## 2D投影

$p$到$vw$的投影

$$proj = (vp · vw) × vw + v$$

## 2D旋转

$$\begin{bmatrix} cos\theta & -sin\theta \\
sin\theta & cos\theta \end{bmatrix}
\begin{bmatrix} X \\ Y \end{bmatrix}$$

# Graph Theory

## Cheeger数

对于具有$m$个顶的图$G$，若存在$n$种取法，使得删掉其中的$k$个顶之后的子图是非连通图。则称，该图$G$的$k$阶$Cheeger$数$\gamma_k$为

$$\lambda_k=1-\frac{n}{C_m^k}$$

## 稳定因子 Stability Factor

$$\gamma_\infty=\lim_{m\to\infty}\frac{\sum_{i=1}^{m}\frac{1}{i!}\lambda_i}{\sum_{i=1}^{m}\frac{1}{i!}}=\frac{1}{e}\lim_{m\to\infty}\sum_{i=1}^{m}\frac{1}{i!}\lambda_i$$

一般只计算3阶稳定因子

$$\gamma_3=\frac{\sum_{i=1}^{3}\frac{1}{i!}\lambda_i}{\sum_{i=1}^{3}\frac{1}{i!}}=\frac{3}{5}(\lambda_1+\frac{1}{2}\lambda_2+\frac{1}{6}\lambda_3)$$