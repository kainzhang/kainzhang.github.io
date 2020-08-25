---
title: N皇后（N-Queens）
urlname: n-queens
date: 2020-04-08 00:17:25
toc: true
thumbnail: https://cdn.jsdelivr.net/gh/kainzhang/kz-img/blog/20/04/08/chess-pieces-child.jpg
categories:
    - Note
    - Problem
tags:
    - Back Tracking
    - DFS
---

+ LeetCode 51 N-Queens
+ LeetCode 52 N-Queens II
+ Lanqiao BASIC-27 2N-Queens
+ Lanqiao ADV-203 8-Queens
+ PAT-A 1128 N-Queens Puzzle

<!--more-->

<br>

## N-Queens

<br>

**Description**

&emsp;&emsp;n 皇后问题研究的是如何将 n 个皇后放置在 n×n 的棋盘上，并且使皇后彼此之间不能相互攻击。

&emsp;&emsp;![](https://cdn.jsdelivr.net/gh/kainzhang/kz-img/blog/20/04/08/8-queens.png)

&emsp;&emsp;上图为 8 皇后问题的一种解法。

&emsp;&emsp;给定一个整数 n，返回所有不同的 n 皇后问题的解决方案。

&emsp;&emsp;每一种解法包含一个明确的 n 皇后问题的棋子放置方案，该方案中 'Q' 和 '.' 分别代表了皇后和空位。

&emsp;&emsp;**原题：**[LeetCode 51 N-Queens](https://leetcode-cn.com/problems/n-queens "N-Queens")

**Sample**

```
输入: 4

输出: [
 [".Q..",  // 解法 1
  "...Q",
  "Q...",
  "..Q."],

 ["..Q.",  // 解法 2
  "Q...",
  "...Q",
  ".Q.."]
]

解释: 4 皇后问题存在两个不同的解法。
```

**Thought**

&emsp;&emsp;题目要求将n个皇后放置在n * n大小的棋盘上，皇后之间不能打架，也就是每行、每列、每条对角线上不能同时有两位皇后。

&emsp;&emsp;思路就是深搜回溯，从第1行开始每次逐列放置皇后，每次放置时对已经放置完成的行进行判断，能放则放，不能放则弃。也就是检查当前位置皇后的上、左上、右上方是否存在皇后。完成n个皇后放置任务后将当前棋盘添加至结果集。

**Code 1**

&emsp;&emsp;觉得这题难度其实不大，就是个人在效率上有点难受（再见残酷的世界！），第1版写完交上去虽然一次AC了，但时间和空间居然都被95%的人碾压？？？（拐回来看代码发现参数全是形参，改了引用参数后时间击败60%空间击败100%）然后参考老哥们的题解改了改，还凑合吧，粘两个版本留念。

&emsp;&emsp;直接把整个棋盘开出来了，然后逐行放置皇后。检查已放置的行就开了3个for循环，分别对正上、左上、右上的格子进行遍历判断。

``` cpp
class Solution {
public:
    bool isValid(vector<string>& bd, int row, int col) {
        //正上
        for(int i = 0; i < row; i++) {
            if(bd[i][col] == 'Q') return false;
        }
        //左上
        for(int i = row - 1, j = col - 1; i >= 0 && j >= 0; i--, j--) {
            if(bd[i][j] == 'Q') return false;
        }
        //右上
        for(int i = row - 1, j = col + 1; i >= 0 && j < bd.size(); i--, j++) {
            if(bd[i][j] == 'Q') return false;
        }
        return true;
    }

    void dfs(vector<string>& bd, int row, int n) {
        if(row == n) {
            res.push_back(bd);
            return;
        }
        for(int i = 0; i < n; i++) {
            if(isValid(bd, row, i)) {
                bd[row][i] = 'Q';
                dfs(bd, row + 1, n);
                bd[row][i] = '.';
            }
        }
    }

    vector<vector<string>> solveNQueens(int n) {
        vector<string> bd(n, string(n, '.'));
        dfs(bd, 0, n);
        return res;
    }

private:
    vector<vector<string>> res;
};
```

**Code 2**

&emsp;&emsp;棋盘是按行开辟的，凑够一整盘后带走放入结果集（空间上没有影响，就是单纯尝试下。。。）

&emsp;&emsp;这个判断比较有意思，是在题解区学的。先开个数组用来存放棋盘每一行放置皇后的列值，在判断时，如果当前列与数组中的列重复，即正上方有皇后。对角线点坐标的x, y与当前点相减的绝对值是相同的，由此判断对角线上是否存在皇后。

``` cpp
class Solution {
public:
    bool isValid(int row, int col, vector<int> &pos) {
        for (int i = 0; i < row; i++) {
            if (col == pos[i] || abs(row - i) == abs(pos[i] - col))
                return false;
        }
        return true;
    }

    void dfs(int row, int n, vector<int> &pos, string &line) {
        if (row == n) {
            res.push_back(tmp);
            return;
        }
        for (int i = 0; i < n; i++) {
            if (isValid(row, i, pos)) {
                line[i] = 'Q';
                tmp.push_back(line);
                line[i] = '.';
                pos[row] = i;
                dfs(row + 1, n, pos, line);
                pos[row] = -1;
                tmp.pop_back();
            }
        }
    }

    vector<vector<string>> solveNQueens(int n) {
        string line(n, '.');
        vector<int> pos(n, -1);
        dfs(0, n, pos, line);
        return res;
    }

private:
    vector<vector<string>> res;
    vector<string> tmp;
};
```
<br>

## N-Queen II

<br>

**Description**

&emsp;&emsp;n 皇后问题研究的是如何将 n 个皇后放置在 n×n 的棋盘上，并且使皇后彼此之间不能相互攻击。

&emsp;&emsp;&emsp;&emsp;![](https://cdn.jsdelivr.net/gh/kainzhang/kz-img/blog/20/04/08/8-queens.png)

&emsp;&emsp;上图为 8 皇后问题的一种解法。

&emsp;&emsp;给定一个整数 n，返回 n 皇后不同的解决方案的数量。

&emsp;&emsp;**原题：**[LeetCode 52 N-Queens II](https://leetcode-cn.com/problems/n-queens-ii "N-Queens")

**Sample**

```
输入: 4

输出: 2

解释: 4 皇后问题存在如下两个不同的解法。
[
 [".Q..",  // 解法 1
  "...Q",
  "Q...",
  "..Q."],

 ["..Q.",  // 解法 2
  "Q...",
  "...Q",
  ".Q.."]
]
```

**Thought**

&emsp;&emsp;怎么说呢，我严重怀疑LeetCode的临时工把题号标错了，这个虽然是II，但明显是原版的简化。看见题就没多想，直接复制粘贴上一题代码，删掉所有棋盘数据，只保留存放每行皇后位置的数组，跑都没跑就提交了（也就这时候敢浪）。在题解区看到用位运算好像效率蛮高的，改（有）天（缘）再看吧。

**Code**

``` cpp
class Solution {
public:
    bool isValid(int row, int col, vector<int> &pos) {
        for (int i = 0; i < row; i++) {
            if (col == pos[i] || abs(row - i) == abs(pos[i] - col))
                return false;
        }
        return true;
    }

    void dfs(int row, int n, vector<int> &pos, int &res) {
        if (row == n) {
            res++;
            return;
        }
        for (int i = 0; i < n; i++) {
            if (isValid(row, i, pos)) {
                pos[row] = i;
                dfs(row + 1, n, pos, res);
                pos[row] = -1;
            }
        }
    }

    int totalNQueens(int n) {
        vector<int> pos(n, -1);
        int res = 0;
        dfs(0, n, pos, res);
        return res;
    }
};
```
<br>

## 2N-Queens

<br>

**Description**

&emsp;&emsp;给定一个n*n的棋盘，棋盘中有一些位置不能放皇后。现在要向棋盘中放入n个黑皇后和n个白皇后，使任意的两个黑皇后都不在同一行、同一列或同一条对角线上，任意的两个白皇后都不在同一行、同一列或同一条对角线上。问总共有多少种放法？n小于等于8。

- Input:

&emsp;&emsp;输入的第一行为一个整数n，表示棋盘的大小。

&emsp;&emsp;接下来n行，每行n个0或1的整数，如果一个整数为1，表示对应的位置可以放皇后，如果一个整数为0，表示对应的位置不可以放皇后。

- Output:

&emsp;&emsp;输出一个整数，表示总共有多少种放法。

**Sample**
```
输入:   // Sample 1
4
1 1 1 1
1 1 1 1
1 1 1 1
1 1 1 1

输出:
2

输入:   // Sample 2
4
1 0 1 1
1 1 1 1
1 1 1 1
1 1 1 1

输出:
0
```

**Thought**

&emsp;&emsp;和N皇后的思路一样，区别是放置两种颜色的皇后，也就是黑白皇后各来一次深搜。根据题意，棋盘上1代表可以放置，0代表不可放置。用2表示白皇后，用3表示黑皇后。放置白皇后时遇到0跳过，放置黑皇后时遇到0和2跳过，两种颜色全部放完时（q == 4)结束并计数。

**Code**
``` cpp
#include <iostream>
using namespace std;
int n, bd[10][10], res = 0;

bool isValid(int row, int col, int q) {  // q 为皇后类型
    for (int r = row - 1, t = 1; r >= 0; r--, t++ ) {
        if (bd[r][col] == q
            || (col - t >= 0 && bd[r][col - t] == q)
            || (col + t < n && bd[r][col + t] == q)) {
            return false;
        }
    }
    return true;
}

void dfs(int row, int q) {
    if (q == 4) {       // 黑白皇后均已放完
        res++;
        return;
    } else if (row == n) {
        dfs(0, q + 1);  // 放置另一种颜色的皇后
        return;
    }
    for (int col = 0; col < n; col++) {
        if (bd[row][col] == 0 || bd[row][col] == 2)
            continue;
        if (isValid(row, col, q)) {
            bd[row][col] = q;
            dfs(row + 1, q);
            bd[row][col] = 1;
        }
    }
}

int main() {
    scanf("%d", &n);
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            scanf("%d", &bd[i][j]);
    dfs(0, 2);
    cout << res << endl;
}
```
<br>


## 8-Queens

<br>

**Description**

&emsp;&emsp;规则同8皇后问题，但是棋盘上每格都有一个数字，要求八皇后所在格子数字之和最大。

- Input:

&emsp;&emsp;一个8*8的棋盘。

- Ouput:

&emsp;&emsp;所能得到的最大数字和

**Sample**
```
输入:
1 2 3 4 5 6 7 8
9 10 11 12 13 14 15 16
17 18 19 20 21 22 23 24
25 26 27 28 29 30 31 32
33 34 35 36 37 38 39 40
41 42 43 44 45 46 47 48
48 50 51 52 53 54 55 56
57 58 59 60 61 62 63 64

输出:
260

数据规模和约定: 棋盘上的数字范围 0~99
```

**Thought**

&emsp;&emsp;依然是深搜回溯，各个位置的数字已经给了，并且题目说明了数字范围为0~99，所以我们将访问的数字累加，并将值改为-1表示已经访问过，确保不被重复访问。每次满足终止条件时，比较当前放置方法的数字之和，取最大值即可。

**Code**
``` cpp
#include <iostream>
using namespace std;
int n = 8, bd[10][10], res = 0;

bool isValid(int row, int col) {
    for (int r = row - 1, t = 1; r >= 0; r--, t++ ) {
        if (bd[r][col] == -1
            || (col - t >= 0 && bd[r][col - t] == -1)
            || (col + t < n && bd[r][col + t] == -1)) {
            return false;
        }
    }
    return true;
}

void dfs(int row, int sum) {
    if (row == n) {
        res = max(res, sum);
        return;
    }
    for (int col = 0; col < n; col++) {
        if (isValid(row, col)) {
            int tmp = bd[row][col];
            bd[row][col] = -1;
            dfs(row + 1, sum + tmp);
            bd[row][col] = tmp;
        }
    }
}

int main() {
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            scanf("%d", &bd[i][j]);

    dfs(0, 0);
    cout << res << endl;
}
```
<br>

## N Queens Puzzle

<br>

**Description**

The "eight queens puzzle" is the problem of placing eight chess queens on an 8 × 8 chessboard so that no two queens threaten each other. Thus, a solution requires that no two queens share the same row, column, or diagonal. The eight queens puzzle is an example of the more general N queens problem of placing N non-attacking queens on an N×N chessboard. (From Wikipedia - "Eight queens puzzle".)

Here you are NOT asked to solve the puzzles. Instead, you are supposed to judge whether or not a given configuration of the chessboard is a solution. To simplify the representation of a chessboard, let us assume that no two queens will be placed in the same column. Then a configuration can be represented by a simple integer sequence (Q​1, Q2, ⋯, Q​N), where Qi is the row number of the queen in the i-th column. For example, Figure 1 can be represented by (4, 6, 8, 2, 7, 1, 3, 5) and it is indeed a solution to the 8 queens puzzle; while Figure 2 can be represented by (4, 6, 7, 2, 8, 1, 9, 5, 3) and is NOT a 9 queens' solution.



{% raw %}<div align="center">{% endraw %}
![Figure 1](https://cdn.jsdelivr.net/gh/kainzhang/kz-img/blog/20/04/08/7d0443cf-5c19-4494-98a6-0f0f54894eaa.jpg)

![Figure 2](https://cdn.jsdelivr.net/gh/kainzhang/kz-img/blog/20/04/08/d187e37a-4eb8-4215-8e2c-040a73c5c8d8.jpg)
{% raw %}</div>{% endraw %}

**Input Specification**

Each input file contains several test cases. The first line gives an integer K (1<K≤200). Then K lines follow, each gives a configuration in the format "N Q1 Q2 ... QN", where 4≤N≤1000 and it is guaranteed that 1≤Qi≤N for all i=1,⋯,N. The numbers are separated by spaces.

**Output Specification**

For each configuration, if it is a solution to the N queens problem, print YES in a line; or NO if not.

**Sample Input**
```
4
8 4 6 8 2 7 1 3 5
9 4 6 7 2 8 1 9 5 3
6 1 5 2 6 4 3
5 1 3 5 2 4
```
**Sample Output**
```
YES
NO
NO
YES
```

**原题：**[PAT-A N Queens Puzzle](https://pintia.cn/problem-sets/994805342720868352/problems/994805348915855360 "PAT-A N Queens Puzzle")

**Thought**

直接暴力就Vans了，为了方便思考将棋盘顺时针反转90度。输入的过程理解成逐行放置皇后的过程。以Figure 1为例，输入皇后位置分别为第1行第4列，第2行第6列... 每输入一个数字（每放置一个皇后）就遍历之前的所有行，检查是否有同列或者同对角线的。

**Code**

``` cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(0);
    int K;
    cin >> K;
    while(K--) {
        int N, t, flag = 1;
        cin >> N;
        vector<int> vec;
        for (int i = 0; i < N; i++) {
            cin >> t;
            vec.push_back(t);
            int l = t - 1, r = t + 1;
            for (int j = i - 1; j >= 0 && flag; j--) {
                if (vec[j] == t || vec[j] == l || vec[j] == r) {
                    flag = 0;
                }
                l--, r++;
            }
        }
        cout << (flag ? "YES" : "NO") << endl;
    }
}
```

<br>

## Summary

&emsp;&emsp;总得来说就是简单的暴力深搜回溯，逻辑上没什么细节好抠的。虽然LeetCode标记的难度是Hard，但实际其实还好？不过第一次信心满满地交上去，结果时间和空间都只击败5%真的难受（弱鸡枯了），确实自己经常粗心忘打取地址符，导致内存使用翻倍，尤其是变量名很长的时候都是习惯性复制粘贴，就忘了。

&emsp;&emsp;蓝桥的比LeetCode难度稍大，比较有意思的是蓝桥的2N皇后被放在“基础练习”的试题集，而相较而言更简单的8皇后被放在“算法提高”？？？可能跟LeetCode是同一个临时工吧哈哈哈哈。

<a style="background-color:black;color:white;text-decoration:none;padding:4px 6px;font-family:-apple-system, BlinkMacSystemFont, &quot;San Francisco&quot;, &quot;Helvetica Neue&quot;, Helvetica, Ubuntu, Roboto, Noto, &quot;Segoe UI&quot;, Arial, sans-serif;font-size:12px;font-weight:bold;line-height:1.2;display:inline-block;border-radius:3px" href="https://unsplash.com/@mparzuchowski?utm_medium=referral&amp;utm_campaign=photographer-credit&amp;utm_content=creditBadge" target="_blank" rel="noopener noreferrer" title="Download free do whatever you want high-resolution photos from Michał Parzuchowski"><span style="display:inline-block;padding:2px 3px"><svg xmlns="http://www.w3.org/2000/svg" style="height:12px;width:auto;position:relative;vertical-align:middle;top:-2px;fill:white" viewBox="0 0 32 32"><title>unsplash-logo</title><path d="M10 9V0h12v9H10zm12 5h10v18H0V14h10v9h12v-9z"></path></svg></span><span style="display:inline-block;padding:2px 3px">Michał Parzuchowski</span></a>