---
title: 使用分支限界法解决01背包问题
urlname: 01-knapsack-using-branch-n-bound
date: 2020-05-22 12:52:54
toc: true
categories:
    - Note
    - Problem
tags:
    - BnB
---

&emsp;&emsp;在算法分析课上第一次接触分支限界法（Branch & Bound），实验要求使用分支限界法解决01背包问题。虽然很清楚代码量要远高于DP，但报告是还要写的，硬着头皮怼吧。随便在蓝桥杯题库找了一道01背包的基础题做测试，题目是算法训练的 ALGO-30 入学考试。

<!--more-->

---
<br>

## 题目

### 问题描述

&emsp;&emsp;辰辰是个天资聪颖的孩子，他的梦想是成为世界上最伟大的医师。为此，他想拜附近最有威望的医师为师。医师为了判断他的资质，给他出了一个难题。医师把他带到一个到处都是草药的山洞里对他说：“孩子，这个山洞里有一些不同的草药，采每一株都需要一些时间，每一株也有它自身的价值。我会给你一段时间，在这段时间里，你可以采到一些草药。如果你是一个聪明的孩子，你应该可以让采到的草药的总价值最大。”
&emsp;&emsp;如果你是辰辰，你能完成这个任务吗？

### 输入格式

&emsp;&emsp;第一行有两个整数T（1 <= T <= 1000）和M（1 <= M <= 100），用一个空格隔开，T代表总共能够用来采药的时间，M代表山洞里的草药的数目。接下来的M行每行包括两个在1到100之间（包括1和100）的整数，分别表示采摘某株草药的时间和这株草药的价值。

### 输出格式

&emsp;&emsp;包括一行，这一行只包含一个整数，表示在规定的时间内，可以采到的草药的最大总价值。

### 样例输入

```
70 3
71 100
69 1
1 2
```

### 样例输出

```
3
```

### 数据规模和约定

对于30%的数据，M <= 10；

对于全部的数据，M <= 100。

---

<br>

## 解题思想

### 分支限界法概述

>&emsp;&emsp;分支限界法常以广度优先或以最小耗费（最大效益）优先的方式搜索问题的解空间树。
&emsp;&emsp;在分支限界法中，每一个活结点只有一次机会成为扩展结点。活结点一旦成为扩展结点，就一次性产生其所有儿子结点。在这些儿子结点中，导致不可行解或导致非最优解的儿子结点被舍弃，其余儿子结点被加入活结点表中。
&emsp;&emsp;此后，从活结点表中取下一结点成为当前扩展结点，并重复上述结点扩展过程。这个过程一直持续到找到所需的解或活结点表为空时为止。

&emsp;&emsp;对于01背包问题来说，就是每访问一个结点，生成两个儿子结点，一个是放入物品，一个是舍弃物品。在生成结点的同时判断该结点是否为可行解，并同时计算该结点能够得到的最优解，即上界。对于不可行解直接剪枝（超重），可行结点使用优先队列存储。不断扩展队列优先级最高的结点，也就是上界最大的结点，当优先队列中优先级最高的结点最优解小于已获得的最优解时，循环结束，当前得到的最优解即为所求最优解。

### 具体思路

&emsp;&emsp;放到本题来看，每个草药包括两个属性：采集时间和价值。首先将所有草药按单位时间的价值从高到低排序，计算T时间在可拆分情况下能得到的最优解。

&emsp;&emsp;使用二叉树构造解空间树，每层结点代表正在放置第几个药草，由此根结点将扩展两个子节点，也就是放入1号草药和不放入一号草药，为两个结点分别计算上界，如果当前结点的时间超出给定时间T，则剪枝处理，否则放入优先队列。

&emsp;&emsp;不断从优先队列中取出优先级最高（最优解最大）的结点，对其进行扩展，重复执行上述操作。如果该结点已扩展至叶结点（所在路径已遍历所有草药），则与当前已知最优解比较，取最大值。

&emsp;&emsp;设定优先队列为大顶堆的数据结构，当队列中优先级最高的结点的最优解小于等于当前已知最优解时，循环结束。

---
<br>

## AC代码

``` cpp
#include <bits/stdc++.h>
using namespace std;

struct Herb {
    int tim, val;   // 时间，价值
    bool operator > (const Herb &x) const {
        return (val * 1.0 / tim) > (x.val * 1.0 / x.tim);
    }
};

struct Node {
    int nxt, sumT, sumP;    // 下一药草的序号 当前总时间 当前总价值
    double maxP;    // 该结点的上界
    bool operator < (const Node &x) const {
        return maxP < x.maxP;
    }
};

int T, M;
vector<Herb> hrbs;
priority_queue<Node> que;

double getBound(int i, int sumT, int sumP) {
    double res = sumP;
    int leftT = T - sumT;   // 剩余时间
    while (i < M && hrbs[i].tim <= leftT) {
        leftT -= hrbs[i].tim;
        sumP += hrbs[i].val;
        i++;
    }
    if (i < M) {
        res = sumP + leftT * (hrbs[i].val * 1.0 / hrbs[i].tim);
    }
    return res;
}

int getAns() {
    int ans = 0;
    Node r = {0, 0, 0, getBound(0, 0, 0)};
    que.push(r);    // 放入根结点
    while (que.top().maxP > ans) {
        Node n = que.top();
        que.pop();
        if (n.nxt == M) {
            ans = max(ans, n.sumP); // 获取实际最优值
        } else {
            Node n2 = n;
            if (n.sumT + hrbs[n.nxt].tim <= T) {    // 超时则剪掉
                n.maxP = getBound(n.nxt, n.sumT, n.sumP);   // 放
                n.sumT += hrbs[n.nxt].tim;  // 当前时间
                n.sumP += hrbs[n.nxt].val;  // 当前价值
                n.nxt++;
                que.push(n);
            }
            n2.maxP = getBound(n2.nxt + 1, n2.sumT, n2.sumP);   // 不放
            n2.nxt++;
            que.push(n2);
        }
    }
    return ans;
}

int main() {
    scanf("%d %d", &T, &M);
    for (int i = 0; i < M; i++) {
        Herb h;
        scanf("%d %d", &h.tim, &h.val);
        hrbs.push_back(h);
    }
    sort(hrbs.begin(), hrbs.end(), greater<Herb>());
    cout << getAns() << endl;
}
```
---
<br>

## 扯淡

&emsp;&emsp;没参考大佬的代码，纯按自己的理解写的，所以不清楚代码是否规范。交上去顺利AC了，数据量较大的两个测试用例用了15ms，效率比想象要高，其实还是DP效果好。算法思想是跟着这个油管的印度大叔学的。

<iframe width="560" height="315" src="https://www.youtube.com/embed/yV1d-b_NeK8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>