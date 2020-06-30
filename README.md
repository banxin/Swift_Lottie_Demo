---
title: Lottie-Swift版本介绍及基本使用
date: 2019-05-30 10:52:12
categories:
- 山竹
tags:
- iOS
- Swift
- 工具
- 效率
---

一、为什么叫Lottie？
-------------

Lottie以德国电影导演(剪影动画的最早的开拓者)命名。 她最著名的电影是“阿赫迈德王子历险记”（1926年） —— 最古老的长篇动画电影。比华特迪士尼的长篇电影白雪公主和七个小矮人（1937）早十多年。

二、Lottie是什么？
------------

Lottie 是一个可应用于Andriod和iOS的动画库，它通过[bodymovin](https://link.jianshu.com?t=https://github.com/bodymovin/bodymovin)插件来解析[Adobe After Effects ](https://link.jianshu.com?t=http://www.adobe.com/products/aftereffects.html)动画并导出为json文件，通过手机端原生的方式或者通过React Native的方式渲染出矢量动画。

这是前所未有的方式，设计师可以创作并且运行优美的动画而不需要工程师煞费苦心地通过手动调整的方式来重现动画。由于动画是通过json来加载的，使得动画源文件只需占用极小的空间就能完成相当复杂的效果！Lottie可以用于播放动画、调整尺寸、循环播放、加速、减速、甚至是精致的交互。

~~Lottie 也创造性地支持原生的UIViewController 的转场动画。（Swift版本不支持，也可能是我没找到对应的API）~~

换句话说，你也可以通过设计器直接把JSON文件放入Xcode project，让Lottie帮你下载动画。当然别误会，你还是需要为你的动画写一些代码，但是你会发现Lottie的确将为你的动画编码节省大量的时间。

效果展示： <https://github.com/airbnb/lottie-ios>

官方使用文档：http://airbnb.io/lottie/ios/dynamic.html

免费动画下载：https://www.lottiefiles.com

DEMO地址: <http://ytgit.hipac.cn/Wireless/sz_lottie_demo_swift>

三、作用（替补方案）
----------

1. 手动地创建动画。手动创建动画对于设计师以及iOS、Android工程师而言意味着付出巨额的时间。通常很难，甚至不可能证明花费这么多时间来获得动画是正确的。
2. [Facebook Keyframes](https://link.jianshu.com?t=https://github.com/facebookincubator/Keyframes)。 Keyframes是专门用来构建用户界面的， 是FaceBook的一个很棒，很新的库。但是Keyframes不支持一些Lottie所能支持的特性，比如： 遮罩，蒙版，裁切路径，虚线样式还有很多。
3. Gifs。Gifs 占用的大小是bodymovin生成的JSON大小的2倍还多，并且渲染的尺寸是固定的，并不能放大来适应更大更高分辨率的屏幕。
4. Png序列桢动画。 Png序列桢动画 甚至比gifs更糟糕，它们的文件大小通常是 bodymovin json文件大小的30-50倍，并且也不能被放大。

四、集成
----

CocoaPods：

pod 'lottie-ios'

五、Lottie 使用
-----------

最基本的方式是用AnimationView来使用它：

```Swift
// someJSONFileName 指的就是用 AE 导出的动画 本地 JSON文件名
let animationView = AnimationView(name: "someJSONFileName")
    
// 可以使用 frame 也可以 使用自动布局
animationView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    
view.addSubview(animationView)
    
animationView.play { (isFinished) in
    
    // 动画执行完成后的回调
    // Do Something
}
```

如果你使用到了跨bundle的JSON文件，你可以这么做：

```Swift
let animationView = AnimationView(name: "someJSONFileName", bundle: YOUR_BUNDLE)
```

从本地支持的JSON文件加载Lottie动画的完整方法是：

```Swift
/**
从本地支持的JSON文件加载Lottie动画.
   
- Parameter name: JSON文件名.
- Parameter bundle: 动画所在的包.
- Parameter imageProvider: 加载动画需要的图片资源（有些动画需要图片配合【可以是本地图片资源，也可以是网络图片资源，实现该协议返回对应的CGImage】）.
- Parameter animationCache: 缓存机制【需要自己实现缓存机制，Lottie本身不支持】）.
*/
convenience init(name: String,
                      bundle: Bundle = Bundle.main,
                      imageProvider: AnimationImageProvider? = nil,
                      animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache) { ... }
```

或者你可以使用磁盘路径和从服务器加载：

tips：初始化方法都在 `AnimationViewInitializers.swift` 文件中，AnimationView 的 extension

```Swift

// 从磁盘路径加载动画
convenience init(filePath: String,
                          imageProvider: AnimationImageProvider? = nil,
                          animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache) { ... }

// 从网络加载 【 DEMO 中有详细例子：ServeAnimationViewController 】
convenience init(url: URL,
                  imageProvider: AnimationImageProvider? = nil,
                  closure: @escaping AnimationView.DownloadClosure,
                  animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache) { ... }
```

Lottie 支持iOS中的`UIView.ContentMode`的 scaleAspectFit, scaleAspectFill 和 scaleToFill 这些属性。

```Swift
let animationView = AnimationView(name: "someJSONFileName")
        
// 填充模式
animationView.contentMode = .scaleToFill
...
```

Lottie 动画的播放控制，除了常规的控制，还支持进度播放、帧播放。

播放、暂停、停止

```Swift
let animationView = AnimationView(name: "someJSONFileName")

// 从上一次的动画位置开始播放
animationView.play()
// 暂停动画播放
animationView.pause()
// 停止动画播放，此时动画进度重置为0
animationView.stop() 
```

控制进度播放：参考DEMO中的 FrameAnimationViewController

```Swift
/**
 播放动画，进度（0 ~ 1）.
 
 - Parameter fromProgress: 动画的开始进度。 如果是'nil`，动画将从当前进度开始。
 - Parameter toProgress: 动画的结束进度。
 - Parameter toProgress: 动画的循环行为。 如果是`nil`，将使用视图的`loopMode`属性。默认是 .playOnce
 - Parameter completion: 动画停止时要调用的可选完成闭包。
 */
//        public func play(fromProgress: AnimationProgressTime? = nil,
//                         toProgress: AnimationProgressTime,
//                         loopMode: LottieLoopMode? = nil,
//                         completion: LottieCompletionBlock? = nil)
animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { (isFinished) in
    // 播放完成后的回调闭包
}
// 设置当前进度
animationView.currentProgress = 0.5
```

控制帧播放：参考DEMO中的 FrameAnimationViewController

```Swift
/**
 使用帧的方式播放动画
 
 - Parameter fromProgress: 动画的开始进度。 如果是'nil`，动画将从当前进度开始。
 - Parameter toProgress: 动画的结束进度
 - Parameter toProgress: 动画的循环行为。 如果是`nil`，将使用视图的`loopMode`属性。
 - Parameter completion: 动画停止时要调用的可选完成闭包。
 */
//        public func play(fromFrame: AnimationFrameTime? = nil,
//                         toFrame: AnimationFrameTime,
//                         loopMode: LottieLoopMode? = nil,
//                         completion: LottieCompletionBlock? = nil)
animationView.play(fromFrame: 50, toFrame: 80, loopMode: .loop) { (isFinished) in
    // 播放完成后的回调闭包
}
// 设置当前帧
animationView.currentFrame = 65
```

动画的循环模式：

```Swift
/// 设置`play`调用的循环行为。 默认为“playOnce”

/// 定义动画循环行为
public enum ottieLoopMode {
  /// 动画播放一次然后停止。
  case playOnce
  /// 动画将从头到尾循环直到停止。
  case loop
  /// 动画将向前播放，然后向后播放并循环直至停止。
  case autoReverse
}

// 循环模式
animationView.loopMode = .playOnce
```

动画到后台的行为模式：

```Swift
/**
到后台时AnimationView的行为。
默认为“暂停”，在到后台暂停动画。 回调会以“false”调用完成。
*/
/// 到后台时AnimationView的行为
public enum LottieBackgroundBehavior {
    /// 停止动画并将其重置为当前播放时间的开头。 调用完成回调。
    case stop
    /// 暂停动画，回调会以“false”调用完成。
    case pause
    /// 暂停动画并在应到前台时重新启动它，在动画完成时调用回调
    case pauseAndRestore
}
        
// 到后台的行为模式
animationView.backgroundBehavior = .pause
```

编辑某帧的动画对象的属性：

```Swift
 // 根据动画指定 对应的 关键路径 例如：“Background 2.Shape 1.Fill 1.Color” @山竹，这个玩意我也还没搞懂，见谅~~
/// *** Keypath Setting
    
let redValueProvider = ColorValueProvider(Color(r: 1, g: 0.2, b: 0.3, a: 1))
animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "BG-On.Group 1.Fill 1.Color"))
    
let otherValueProvider = ColorValueProvider(Color(r: 0.3, g: 0.2, b: 0.3, a: 1))
animationView.setValueProvider(otherValueProvider, keypath: AnimationKeypath(keypath: "BG-Off.Group 1.Fill 1.Color"))
```

打印animationView的所有层级属性，从日志中获取相应的属性：

```Swift
Lottie: Logging Animation Keypaths
Switch Outline Outlines
Switch Outline Outlines.Transform
Switch Outline Outlines.Transform.Anchor Point
Switch Outline Outlines.Transform.Scale
Switch Outline Outlines.Transform.Rotation
Switch Outline Outlines.Transform.Opacity
Switch Outline Outlines.Transform.Position
Switch Outline Outlines.Group 1
Switch Outline Outlines.Group 1.Rotation
Switch Outline Outlines.Group 1.Anchor Point
Switch Outline Outlines.Group 1.Position
Switch Outline Outlines.Group 1.Skew
Switch Outline Outlines.Group 1.Scale
Switch Outline Outlines.Group 1.Opacity
Switch Outline Outlines.Group 1.Skew Axis
Switch Outline Outlines.Group 1.Path 1
Switch Outline Outlines.Group 1.Path 1.Path
Switch Outline Outlines.Group 1.Transform
Switch Outline Outlines.Group 1.Transform.Rotation
Switch Outline Outlines.Group 1.Transform.Anchor Point
Switch Outline Outlines.Group 1.Transform.Position
Switch Outline Outlines.Group 1.Transform.Skew
Switch Outline Outlines.Group 1.Transform.Scale
Switch Outline Outlines.Group 1.Transform.Opacity
Switch Outline Outlines.Group 1.Transform.Skew Axis
Switch Outline Outlines.Fill 1
Switch Outline Outlines.Fill 1.Opacity
Switch Outline Outlines.Fill 1.Color
White BG Outlines
White BG Outlines.Transform
White BG Outlines.Transform.Anchor Point
White BG Outlines.Transform.Scale
White BG Outlines.Transform.Rotation
White BG Outlines.Transform.Opacity
White BG Outlines.Transform.Position
White BG Outlines.Group 1
White BG Outlines.Group 1.Opacity
White BG Outlines.Group 1.Position
White BG Outlines.Group 1.Skew
White BG Outlines.Group 1.Anchor Point
White BG Outlines.Group 1.Scale
White BG Outlines.Group 1.Rotation
White BG Outlines.Group 1.Skew Axis
White BG Outlines.Group 1.Path 1
White BG Outlines.Group 1.Path 1.Path
White BG Outlines.Group 1.Fill 1
White BG Outlines.Group 1.Fill 1.Opacity
White BG Outlines.Group 1.Fill 1.Color
White BG Outlines.Group 1.Transform
White BG Outlines.Group 1.Transform.Opacity
White BG Outlines.Group 1.Transform.Position
White BG Outlines.Group 1.Transform.Skew
White BG Outlines.Group 1.Transform.Anchor Point
White BG Outlines.Group 1.Transform.Scale
White BG Outlines.Group 1.Transform.Rotation
White BG Outlines.Group 1.Transform.Skew Axis
Checkmark Outlines
Checkmark Outlines.Transform
Checkmark Outlines.Transform.Rotation
Checkmark Outlines.Transform.Anchor Point
Checkmark Outlines.Transform.Scale
Checkmark Outlines.Transform.Position
Checkmark Outlines.Transform.Opacity
Checkmark Outlines.Group 1
Checkmark Outlines.Group 1.Anchor Point
Checkmark Outlines.Group 1.Opacity
Checkmark Outlines.Group 1.Skew Axis
Checkmark Outlines.Group 1.Rotation
Checkmark Outlines.Group 1.Skew
Checkmark Outlines.Group 1.Position
Checkmark Outlines.Group 1.Scale
Checkmark Outlines.Group 1.Path 1
Checkmark Outlines.Group 1.Path 1.Path
Checkmark Outlines.Group 1.Trim Paths 1
Checkmark Outlines.Group 1.Trim Paths 1.Offset
Checkmark Outlines.Group 1.Trim Paths 1.End
Checkmark Outlines.Group 1.Trim Paths 1.Start
Checkmark Outlines.Group 1.Stroke 1
Checkmark Outlines.Group 1.Stroke 1.Color
Checkmark Outlines.Group 1.Stroke 1.Stroke Width
Checkmark Outlines.Group 1.Stroke 1.Opacity
Checkmark Outlines.Group 1.Stroke 1.Dashes
Checkmark Outlines.Group 1.Stroke 1.Dash Phase
Checkmark Outlines.Group 1.Transform
Checkmark Outlines.Group 1.Transform.Anchor Point
Checkmark Outlines.Group 1.Transform.Opacity
Checkmark Outlines.Group 1.Transform.Skew Axis
Checkmark Outlines.Group 1.Transform.Rotation
Checkmark Outlines.Group 1.Transform.Skew
Checkmark Outlines.Group 1.Transform.Position
Checkmark Outlines.Group 1.Transform.Scale
X Outlines
X Outlines.Transform
X Outlines.Transform.Position
X Outlines.Transform.Anchor Point
X Outlines.Transform.Opacity
X Outlines.Transform.Scale
X Outlines.Transform.Rotation
X Outlines.Group 1
X Outlines.Group 1.Rotation
X Outlines.Group 1.Anchor Point
X Outlines.Group 1.Scale
X Outlines.Group 1.Skew Axis
X Outlines.Group 1.Position
X Outlines.Group 1.Skew
X Outlines.Group 1.Opacity
X Outlines.Group 1.Path 1
X Outlines.Group 1.Path 1.Path
X Outlines.Group 1.Stroke 1
X Outlines.Group 1.Stroke 1.Dashes
X Outlines.Group 1.Stroke 1.Dash Phase
X Outlines.Group 1.Stroke 1.Opacity
X Outlines.Group 1.Stroke 1.Color
X Outlines.Group 1.Stroke 1.Stroke Width
X Outlines.Group 1.Transform
X Outlines.Group 1.Transform.Rotation
X Outlines.Group 1.Transform.Anchor Point
X Outlines.Group 1.Transform.Scale
X Outlines.Group 1.Transform.Skew Axis
X Outlines.Group 1.Transform.Position
X Outlines.Group 1.Transform.Skew
X Outlines.Group 1.Transform.Opacity
X Outlines.Trim Paths 1
X Outlines.Trim Paths 1.Start
X Outlines.Trim Paths 1.End
X Outlines.Trim Paths 1.Offset
Checkmark Outlines 2
Checkmark Outlines 2.Transform
Checkmark Outlines 2.Transform.Anchor Point
Checkmark Outlines 2.Transform.Scale
Checkmark Outlines 2.Transform.Rotation
Checkmark Outlines 2.Transform.Position
Checkmark Outlines 2.Transform.Opacity
Checkmark Outlines 2.Group 1
Checkmark Outlines 2.Group 1.Skew
Checkmark Outlines 2.Group 1.Anchor Point
Checkmark Outlines 2.Group 1.Position
Checkmark Outlines 2.Group 1.Rotation
Checkmark Outlines 2.Group 1.Scale
Checkmark Outlines 2.Group 1.Opacity
Checkmark Outlines 2.Group 1.Skew Axis
Checkmark Outlines 2.Group 1.Path 1
Checkmark Outlines 2.Group 1.Path 1.Path
Checkmark Outlines 2.Group 1.Trim Paths 1
Checkmark Outlines 2.Group 1.Trim Paths 1.End
Checkmark Outlines 2.Group 1.Trim Paths 1.Offset
Checkmark Outlines 2.Group 1.Trim Paths 1.Start
Checkmark Outlines 2.Group 1.Stroke 1
Checkmark Outlines 2.Group 1.Stroke 1.Dash Phase
Checkmark Outlines 2.Group 1.Stroke 1.Color
Checkmark Outlines 2.Group 1.Stroke 1.Dashes
Checkmark Outlines 2.Group 1.Stroke 1.Opacity
Checkmark Outlines 2.Group 1.Stroke 1.Stroke Width
Checkmark Outlines 2.Group 1.Transform
Checkmark Outlines 2.Group 1.Transform.Skew
Checkmark Outlines 2.Group 1.Transform.Anchor Point
Checkmark Outlines 2.Group 1.Transform.Position
Checkmark Outlines 2.Group 1.Transform.Rotation
Checkmark Outlines 2.Group 1.Transform.Scale
Checkmark Outlines 2.Group 1.Transform.Opacity
Checkmark Outlines 2.Group 1.Transform.Skew Axis
```

AnimationView常用的属性和方法：

```Swift
/// 动画属性
public var animation: Animation? { ... }
/// 程序到后台动画的行为，上面有详细解释
public var backgroundBehavior: LottieBackgroundBehavior = .pause
/// 如果动画需要图片资源的支持，需要设定该协议
public var imageProvider: AnimationImageProvider { ... }
/// 动画是否正在播放
public var isAnimationPlaying: Bool { ... }
/// 循环模式，上面有详细解释
public var loopMode: LottieLoopMode = .playOnce { ... }
/// 当前的播放进度（取值范围 0 ~ 1）
public var currentProgress: AnimationProgressTime { ... }
/// 当前的播放时间
public var currentTime: TimeInterval { ... }
/// 当前帧数
public var currentFrame: AnimationFrameTime { ... }
/// 动画的播放速度
public var animationSpeed: CGFloat = 1 { ... }
/// 判断是否正在播放动画
public var isAnimationPlaying: Bool { get }

// ------------------------ 分割线 -----------------------------

/// 初始化方法，上面有详细解释
... （略过）

/// 播放方法，带可选完成回调
public func play(completion: LottieCompletionBlock? = nil) { ... }

/// 从一个进度到另一个进度，上面有详细解释
public func play(fromProgress: AnimationProgressTime? = nil,
                   toProgress: AnimationProgressTime,
                   loopMode: LottieLoopMode? = nil,
                   completion: LottieCompletionBlock? = nil) { ... }

/// 从一个帧到另一个帧，上面有详细解释                   
public func play(fromFrame: AnimationFrameTime? = nil,
                   toFrame: AnimationFrameTime,
                   loopMode: LottieLoopMode? = nil,
                   completion: LottieCompletionBlock? = nil) { ... }                                  
                   
/// 停止
public func stop() 
/// 暂停
public func pause()  
/// 打印所有的层级属性
public func logHierarchyKeypaths()   
/// 强制AnimationView重绘其内容。
public func forceDisplayUpdate() { ... }               

```

六、Lottie 优势
-----------

1. 开发成本低。设计师导出 json 文件后，扔给开发同学即可，可以放在本地，也支持放在服务器。原本要1天甚至更久的动画实现，现在只要不到一小时甚至更少时间了。

2. 动画的实现成功率高了。设计师的成果可以最大程度得到实现，试错成本也低了。

3. 支持服务端 URL 方式创建。所以可以通过服务端配置 json 文件，随时替换客户端的动画，不用通过发版本就可以做到了。比如 app 启动动画可以根据活动需要进行变换了。

4. 性能。可以替代原来需要使用帧图完成的动画。节省了客户端的空间和加载的内存。对硬件性能好一些。

5. 跨平台。iOS、安卓平台可以使用一套文件。省时省力，动画一致。不用设计师跑去两边去跟着微调确认了。

6. ~~支持转场动画。 PresentViewController／DismissViewController 时可以做转场效果。Swift版本不支持，也可能是我没找到对应的API，@山竹。~~

七、Lottie 适用场景：参考DEMO
-------------

* 首次启动引导页（这个要做比较好的效果，也比较复杂，DEMO中暂时没有这个，有兴趣可以尝试~~）
* 启动(splash)动画：典型场景是APP logo动画的播放
* 上下拉刷新动画：所有APP都必备的功能，利用 Lottie 可以做的更加简单酷炫了
* 加载(loading)动画：典型场景是网络请求的loading动画
* 提示(tips)动画：典型场景是空白页的提示
* 按钮(button)动画：典型场景如switch按钮、编辑按钮、播放按钮等按钮的切换过 渡动画
* 礼物(gift)动画：典型场景是直播类APP的高级动画播放
* ~~视图转场动画（目前不支持push和pop）[Swift不支持，也可能是我没有找到对应的API @山竹]~~

八、Lottie 使用注意
-------------

Lottie是基于CALayer的动画, 所有的路径预先在AE中计算好, 转换为Json文件, 然后自动转换为Layer的动画, 所以性能理论上是非常不错的, 在实际使用中, 确实很不错, 但是有几点需要注意的:

 -- 如果使用了素材, 那么素材图片的每个像素都会直接加载进内存, 并且是不能释放掉的(实测, 在框架中有个管理cache的类, 并没有启动到作用, 若大家找到方法请告诉我), 所以, 如果是一些小图片, 加载进去也还好, 但是如果是整页的启动动画, 如上面的启动页动画, 不拆分一下素材, 可能一个启动页所需要的内存就是50MB以上. 如果不使用素材, 而是在AE中直接绘制则没有这个问题.

 -- 如果使用的PS中绘制的素材, 在AE中做动画, 可能在动画导出的素材中出现黑边, 建议的解决办法是将素材拖入PS去掉黑边, 同名替换.

 -- 拆分素材的办法是将一个动画中静态的部分直接切出来加载, 动的部分单独做动画

 -- 如果一个项目中使用了多个Lottie的动画, 需要注意Json文件中的路径及素材名称不能重复, 否则会错乱

 -- 不支持渐变色

 -- AE中的属性不全，具体可参考官网

 基于以上的问题, 建议使用Lottie的场合为复杂的播放式形变动画, 因为形变动画由程序员一点点的写路径确实不直观且效率低. 但即便如此, Lottie也是我们在CoreAnimation之后一个很好的补充.

九、对Lottie的小建议
--------------

1. 有些需要展示动画的AnimationView，可能也会有点击事件，但又并不需要使用AnimatedSwitch，如果需要添加点击事件的话，就需要一个个地加，比价麻烦。

AnimationView也是继承自UIView的，所以加了一个UIView的extension：

```Swift
/// 关联属性 key
private var kUIViewTouchEventKey = "kUIViewTouchEventKey"

/// 点击事件闭包
public typealias UIViewTouchEvent = (AnyObject) -> ()

extension UIView {
    
    private var touchEvent: UIViewTouchEvent? {
        
        set {
            objc_setAssociatedObject(self, &kUIViewTouchEventKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let event = objc_getAssociatedObject(self, &kUIViewTouchEventKey) as? UIViewTouchEvent {
                return event
            }
            return nil
        }
    }
    
    /// 添加点击事件
    ///
    /// - Parameter event: 闭包
    func addTouchEvent(event: @escaping UIViewTouchEvent) {
        
        self.touchEvent = event
        // 先判断当前是否有交互事件，如果没有的话。。。所有gesture的交互事件都会被添加进gestureRecognizers中
        if (self.gestureRecognizers == nil) {
            self.isUserInteractionEnabled = true
            // 添加单击事件
            let tapEvent = UITapGestureRecognizer.init(target: self, action: #selector(touchedAciton))
            self.addGestureRecognizer(tapEvent)
        }
    }
    
    /// 点击事件处理
    @objc private func touchedAciton() {
        guard let touchEvent = self.touchEvent else {
            return
        }
        touchEvent(self)
    }
}
```  

2. 缓存机制

Lottie 本身不支持缓存机制，需要自己实现，目前暂时建议使用YYCache，以动画的JSON名为KEY，尤其是网络资源，可以提高一定的性能。

如果有更好的缓存机制，望不吝赐教。

十、其他
--------------

其他的内容，详见DEMO！！！

 [传送门](https://github.com/banxin/Swift_Lottie_Demo)


