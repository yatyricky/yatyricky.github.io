# 2019年度个人总结

*孙世龙 2020-01-02*

本总结将围绕我今年参与的3个项目，讲一讲在这些项目里面的收获。

## 街头大乱斗

*工作时间：1月-5月，维护至8月*

### Phase 1

街头项目从过年开始正式开始制作联机版，我在同事重构之后开始移植客户端的业务代码。

> 这一阶段我主要学习到了ECS框架的概念，以及如何在实际应用中做到将逻辑与表现分离，所以在后续的开发中，街头的游戏内逻辑部分一直都是比较易于维护的。

### Phase 2

产品趋于稳定之后，我主要负责运营需求的开发以及重制的UI。这段时间内，产品、美术、程序的配合度达到最高效的状态，真正做到了从产品到美术到程序各领先一个版本周期。产品在这一时期快速累积到了大量的数据和经验。

> 这一阶段中，我重新整理了UI上的异步请求表现，消除了一些当时长期存在的UI和服务器状态冲突的BUG；并整理了一套精细化“运营”的配置，为后续项目打下基础。

### Phase 3

从5月底开始，我开始了新项目，此后每周有2天左右的时间持续对街头项目进行小功能开发和日常维护。

## 碰碰漂移赛车

*工作时间：5月底-8月中*

### Phase 1

第一阶段为5月底-7月初，我负责游戏内的基础功能实现，以及少量的策划工作。游戏框架为街头项目的ECS框架，运用了现成的经验。

> 在车辆碰撞部分，我先后进行了很多尝试，学习到了3D引擎的基础计算原理，下面详述。

**使用Laya的3D碰撞**

- 在小游戏上性能极差
- 在引擎渲染和游戏逻辑计算上做了很多尝试，但效果不明显
- 最终修改Laya引擎，去掉了不必要的Frustum Culling计算，能将20FPS提升到30FPS左右，但依然不解决根本问题
- 游戏中只能保证1辆车能跑

**自己手写碰撞**

- 游戏能跑60FPS
- 但是不能做到车辆掉落悬崖的真实感
- 简单实现的车辆碰撞体验很差

最终因为项目定位，我们为了做到比竞品小游戏的体验更加真实，选择保留了物理系统。

<br/>
<br/>

### Phase 2

项目经历了调整，确定去掉Laya的物理系统，并且在游戏体验上参照国外竞品进行**逐帧优化**。现在可以支持4辆以上的赛车互相碰撞，翻落悬崖时候的近乎真实表现，以及更加可控的AI。

> 这一阶段我主要复习了很多数学知识，用于处理车辆之间的碰撞，以及AI路径的计算。

## Barrett

*工作时间：8月至今*

我主要负责地图资源的工作流，包括编辑器制作，数据导出，游戏内实现。游戏内容包括场景物件，怪物类型，以及怪物出生点。另外也负责一部分周围系统的UI开发工作和少量Shader编写。

> 学习到了Unity的编辑器编写。同时通过阅读代码学习到了行为树和一些Unity相关的知识，如预制件的组织方式(PrefabUtility)，Animation与Animator，动画帧事件等等。

> 当然还有一门新的语言，Lua。

## 小结

- 今年学到了ECS的基本原理，发现一个好的框架（思路）对于开发效率和代码质量真的是太重要了
- 在街头和赛车项目里面仔细打磨性能和游戏的细节，以至于车辆的转弯倾斜多少帧，每帧要倾斜多少个像素都要去考究，这种态度以后都要保持
- Unity入门

## 展望

在新的一年里，继续深入学习Unity以及各种实用框架，提升业务能力。其他时间可以学习和巩固一些基础知识，如：一些框架的源码、词法语法分析、数据结构等等。
