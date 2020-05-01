---
title: 设计模式 - 工厂模式（Factory Pattern）
urlname: factory-pattern
date: 2020-04-25 18:24:22
toc: true
thumbnail: https://cdn.jsdelivr.net/gh/kainzhang/lokka-img/blog/20/04/25/tyler-nix-7ukf-r-Oh-k-unsplash.jpg
categories:
    - Note
    - Design Pattern
tags:
    - Java
---

&emsp;&emsp;Java设计模式 - 工厂模式


<!--more-->

---

## 简单工厂模式

**简单工厂模式组成：**
+ 工厂类：简单工厂模式的核心，负责创建所需的产品实例。
+ 抽象产品类：产品类的父类，定义产品类共有的属性和方法。
+ 产品类： 继承抽象产品类，即具体的产品。

&emsp;&emsp;首先定义抽象咖啡类，规定所有咖啡共有的接口。

``` java
public abstract class Coffee {

    protected String name;

    // 制作咖啡
    public void prepare() {
        System.out.println(name + "制作完成！");
    }

    // 打包咖啡
    public void pack() {
        System.out.println(name + "打包完成!");
    }

}
```

&emsp;&emsp;定义具体类型的咖啡。
``` java
public class Americano extends Coffee{
    public Americano() {
        this.name = "美式";
    }
}

public class Latte extends Coffee{
    public Latte() {
        this.name = "拿铁";
    }
}

public class Mocha extends Coffee{
    public Mocha() {
        this.name = "摩卡";
    }
}
```

&emsp;&emsp;创建咖啡工厂类，负责具体产品的实例化
```  java
public class CoffeeFactory {

    public Coffee createCoffee(String coffeeType) {
        Coffee coffee = null;
        if (coffeeType.equals("美式")) {
            coffee = new Americano();
        } else if (coffeeType.equals("拿铁")) {
            coffee = new Latte();
        } else if (coffeeType.equals("摩卡")) {
            coffee = new Mocha();
        }
        return coffee;
    }
}
```

&emsp;&emsp;咖啡馆类调用咖啡工厂类。
``` java
public class Cafe {
    private static String getCoffeeType() {
        try {
            BufferedReader strin = new BufferedReader(new InputStreamReader(System.in));
            System.out.println("请输入咖啡类别：");
            String str = strin.readLine();
            return str;
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
    }
    public static void main(String[] args) {
        CoffeeFactory cf = new CoffeeFactory();
        String coffeeType = getCoffeeType();
        Coffee coffee = cf.createCoffee(coffeeType);
        if (coffee != null) {
            coffee.prepare();
            coffee.pack();
        } else {
            System.out.println("请求失败！");
        }
    }
}
```

<a style="background-color:black;color:white;text-decoration:none;padding:4px 6px;font-family:-apple-system, BlinkMacSystemFont, &quot;San Francisco&quot;, &quot;Helvetica Neue&quot;, Helvetica, Ubuntu, Roboto, Noto, &quot;Segoe UI&quot;, Arial, sans-serif;font-size:12px;font-weight:bold;line-height:1.2;display:inline-block;border-radius:3px" href="https://unsplash.com/@jtylernix?utm_medium=referral&amp;utm_campaign=photographer-credit&amp;utm_content=creditBadge" target="_blank" rel="noopener noreferrer" title="Download free do whatever you want high-resolution photos from Tyler Nix"><span style="display:inline-block;padding:2px 3px"><svg xmlns="http://www.w3.org/2000/svg" style="height:12px;width:auto;position:relative;vertical-align:middle;top:-2px;fill:white" viewBox="0 0 32 32"><title>unsplash-logo</title><path d="M10 9V0h12v9H10zm12 5h10v18H0V14h10v9h12v-9z"></path></svg></span><span style="display:inline-block;padding:2px 3px">Tyler Nix</span></a>