---
layout: post
title: 对于传统PVE型RPG地图设计的一些看法
categories: [war3, game, design]
---

## 介绍

最近几个月笔者一直在和朋友更新自己的那个地图，并且有了一些心得，这里拿出来和大家分享下。

这篇帖子主要会通过分析以前那张发布的成品图（旧图）里面的失败点，结合现在（新图）的更新的设计思路，讲讲魔兽争霸地图编辑的英雄设计原则，技能设计思路，和系统使用强度。

笔者的这张图的制作初衷是模仿《魔兽世界-燃烧的远征》（WOW-TBC）里面的一个10人副本《祖阿曼》（ZAM），并且数年前是DOTA玩家，所以帖子里面会提到一些与TBC-ZAM和DOTA相关的内容，并且假设读者知道这些东西是什么。

## 英雄的设计

一个英雄的功能应该是独一无二的。

旧图里面，德鲁伊被理所当然地设计成了变形大师，于是，在熊形态下，德鲁伊可以做坦克（T），在豹形态下，德鲁伊可以输出伤害，在人形态下，他可以加血。在这样的设计下，这个英雄是独一无二的，他可以扮演多种角色，可是，他的功能则与其他职业发生了重叠，其主要原因是，在旧图里面，T都会嘲讽，单体巨大仇恨技能，AOE仇恨技能，免伤技能，等等。

从地图设计的角度考虑，我们总是希望不同的玩家为了同样的地图目标而在玩着不同的东西，这个观念与DOTA的默认英雄选择模式不谋而合，这样玩家不会觉得作者换汤不换药，弄个不一样的模型和视觉效果来糊弄他们。

而比较典型的反面例子则是，比如在一些年代比较久远的地图里面，比如《守护雅典娜》之类，这里没有贬低这个地图的意思，它在那个自由作者的技术和编辑器都不成熟的年代里面，是很多魔兽争霸RPG玩家热爱的对象，包括笔者。但是如果要深入分析里面的英雄，会发现可以分为如下两类：

1. 战士，他们都有类似的废技能，和一两个暴击或/和闪避技能，加上一个在后期没什么太大用的天神下凡或者恶魔变身。
2. 法师，他们通常都会召唤一大堆前期很暴力的召唤生物，和施展大规模杀伤性魔法。

然后有的战士也许会有几个法师技能，但是他们到后期一定会有一个共同特点，就是吃书买吸血面具，然后所有怪都是直接A死，如果这个英雄有幸自带分裂攻击，弹幕攻击，弹射攻击这样的技能，通常就会变成影响平衡的抢手货。

在新图里面，德鲁伊被重新定位和设计，最终被拆分成了两个职业：利爪德鲁依和丛林守护者，分别是一个做T，一个做治疗。可能有人会觉得，德鲁伊不能变身了，那就不是德鲁伊了。

但是我们更加关注一个技能设计出来的必要性，试想，熊德在人形态能干嘛？加爪子吗，我们大可设计出一个爪子光环，这样省去了玩家每半个小时不必要的刷BUFF；加血吗，要熊德来加血，这场战斗也不用打了，或者加血技能可以干脆放在熊形态里面使用，如果需要变人再使用这个技能，那么，这个技能就和魔法书没什么本质上的区别了，后面会讲到魔法书的坏处。

并且，如果一个奶德具有变熊扛怪的能力了，那还要T做什么，如果需要他来临时扛怪，那么我们可以直接在编辑器里面修改，让奶德比较耐打。

因此，在设计好一个英雄的属性，技能，成长，未来装备选择以后，我们要对其进行反复推敲，剪除那些不必要的设计，将设计最简化，让玩家将时间用在玩地图上，而不是研究这些复杂的设计。

在旧图里面，虽然有WOW-TBC九大职业，可是笔者觉得这些职业的定位非常杂乱无章，他们的功能互相重叠，有的职业的功能是另外一个职业的功能的子集，有的职业和另外一个职业的使用手法完全一样，所以在新图里面，我们将原有的九大职业拆解和融合，再结合魔兽争霸，设计出了11个功能和使用手法各异的职业。

## 技能的设计

一个技能应该是有用的。

旧图里面，战士拥有冲锋技能，在WOW-TBC里面，冲锋需要在非战斗状态下使用，于是笔者也照搬。结果问题出现了，作为一个玩家，当他的英雄有一个技能栏位在99.9%的战斗时间里面被一个总是无法使用的技能占用的时候，他会做何感想。

因此，不要为了做一个技能而去做一个技能，要让设计出来的技能是有实际作用的，这些技能需要能体现出这个英雄的特色。

其实，技能的设计是一个很简单的工作，我们在将新的11个职业定好位以后，开始列出一些这些职业原有的技能，和我们自主设计的认为能体现职业特色的技能，放在一个候选列表里面，然后从这个列表挑出5个技能，因为我们认为，一个英雄最多只能有5个主动技能，如果太多，会让玩家感到厌烦，玩家通常不会愿意多花1秒去研究7个甚至8个的技能。

接下来，我们会在文档里面模拟出一些这个职业会面临的场景，看这个职业能通过哪些技能来应付，如果有发现不合适的技能，我们会对这样的技能进行修改，如果是有硬伤，那么就从候选列表里面挑新的，能应付这个场景的技能，如果候选列表空了，那么我们会重新设计，直到这个职业能以它的特色应付所有它需要面对的场景为止。

举个例子，新图里面，我们给圣骑士的定位是：“单体高效治疗，少量防护型增益魔法（BUFF）”，圣骑士是一个治疗职业，因此我们给他治疗场景模拟，我们模拟出来的一些基本治疗场景有：

1. 常规、T垂危、全团掉血、全团垂危。在常规情况下，圣骑士通过使用圣光术和圣光闪现就能应付；
2. 在T垂危的情况下，圣骑士需要使用圣光闪现，神恩术，圣光术，神圣震击，圣光术这样的手法来迅速为T回血；
3. 在全团掉血的情况下，圣骑士可以为某个队友施放圣光印记，然后轮流给队友圣光闪现，圣光术，神圣震击；
4. 在全团垂危的情况下，圣骑士无法有效地救场，只能尽可能地使用全团掉血的手段去治疗。

这里似乎看到圣骑士不能应付全团垂危这个场景，可是我们给圣骑士的定位是单体治疗，于是我们认为，圣骑士对于这种场面感到吃力是职业特色的负面体现，因此，圣骑士的技能设计被通过。

同时，所有技能的使用频率与其冷却（CD）时间的积应该是差不多的。

比如一个冷却时间为4秒的小招，它在1分钟之内应该被使用7-9次，考虑到走位，和一些不可抗拒的情况，4秒CD时间的技能不可能在1分钟内被使用15次。而这个技能确实有必要被使用7-9次，如果发现这个技能的实际使用频率与预期使用频率不符，那么，这个技能可能需要被重新设计了。

举例说明，前面提到了德鲁伊加爪子这样的事情，这个技能在WOW里面是一个正常情况下1个小时只要使用1次的，而没有CD时间的技能（请不要吐槽公共CD时间）。这样的技能在WAR3里面是行不通的，因为我们的技能栏位太紧张了，我们需要呆在里面的技能是经常被使用的，在WAR3里面，一个每小时只需使用1次的技能，变成光环，不是更合适吗？

以前一个同学给我谈设计的时候讲过：“一个设计，它应该是一个有机体，在一个小的整体里面能完成几乎所有的完整的事情，并且它们之间应该根据实际情况需要具有或强或弱的联系，不然，这就不是一个整体了，这是一堆零散的无机物。”

DOTA能风靡全球，我相信其有一个原因是其技能设计之间的配合，说得通俗一点，就是技能要形成连击。

DOTA里面，笔者认为最经典的连击要数6.41以后屠夫的“肉钩-肢解-腐烂”连击了，而这些技能的设计，又不完全依赖于连击，单独使用也能经常发挥奇效，可谓收放自如。

新图里面，前面讲到了圣骑士的各种治疗技能，技能效果不在这里赘述，这一套技能无论是文档模拟，还是游戏内初步测试，都达到了不错的效果，使用频率，连击效果，单独使用效果，都比较令人满意。

## 系统的设计

游戏系统不应过度违反魔兽争霸特色。

有的作者在写地图的时候，喜欢使用大量复杂的系统，比如自定义属性啦，全屏装备啦，复杂的技能升级啦，之类的。这一段将讨论这个问题。

在旧图里面，笔者经历过这样的失败。因为是做WOW RPG图，所以必然会涉及到仇恨系统，说之前的仇恨系统失败，不是讲其功能性的失败，而是表现形式的失败，之前，笔者将这个仇恨系统，显示到多面板上面，而这个多面板，是整个游戏里面唯一的一个多面板。

试想，现在正统的WOW玩家都懒得看着仇恨面板去打怪，我们难道能期望WAR3地图玩家会看着字体那么小的多面板去打怪吗？这显然不可能。可是，仇恨系统能没有吗？当然必须得有。

所以，笔者并不是批评使用这些系统的做法是错误的，而是，地图作者不应该把太复杂的，而不属于WAR3的东西过多地展示出来。这样，不仅可以提升整个界面的清爽程度，还原WAR3操作的感觉，还能让有内涵的玩家感受到这个作者的内涵。

举个例子，有的地图，这里点名TKOK和黑暗入侵，笔者可以看出这两张地图的作者花费了很大的心血，可是他们不知道，他们的地图做得太复杂了，世界上只有很少的变态玩家，比如笔者，会拉着朋友去玩这样的地图，正常人通常在看到满屏幕的多面板数据，和复杂的包裹操作界面以后，就退出了游戏，因为作者不应该期望玩家会花10分钟来研究他们设计出来的复杂系统应该怎么使用。

所以，这个问题就很自然地跳到了地图的魔兽争霸特色这一点上面。笔者认为，正常的RPG地图，应该是以魔兽争霸3的默认操作为基础，最多扩展一些简单的口令输入和方向键操作，这些不应该超过5%的使用。并且，作者也不应该在游戏界面里面做太多的手脚，有人喜欢双页物品栏，而笔者则不太认可这个做法，玩家在WAR3里面通常比较愿意看到他们现在有什么装备，有什么东西可以使用。这样的设计会让玩家有一种容易上手的感觉，就增加了留住玩家的机会。

与此同时，根据地图的需要，一些复杂的系统仍然是需要被实现和使用的，比如在新图里面，所有的魔兽争霸默认的攻击伤害模式全部被通过使用触发器而重写，涉及到的新增属性有法术强度，法术急速，暴击，招架，等等。

而这些属性的具体数值，是不会被显示出来的，玩家需要知道的仅仅是：

>将一个+10智力的匕首更换为+15智力的魔杖会提升他们的寒冰箭伤害  
装备一件+20敏捷的斗篷会提升他们的躲闪几率

这样就够了，当然，笔者会考虑增加通过输入命令来显示单位的详细属性，以满足部分玩家的需要。

## 总结

这篇帖子主要讲述了笔者通过重新设计新的祖阿曼地图而体会出来的一些魔兽争霸地图编辑设计理念，并且结合实际操作和一些现实存在的例子加以说明，以将这些论点阐述清楚。具体如何去设计自己的地图，要根据地图的类型，以及作者赋予其之设定，作最终的调节，最后，希望本帖能够对读者有一定的帮助。