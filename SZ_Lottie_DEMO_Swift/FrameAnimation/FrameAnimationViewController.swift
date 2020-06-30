//
//  FrameAnimationViewController.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/28.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

import Then
import Lottie
import SnapKit
import RxSwift
import RxCocoa

/// Frame 动画
class FrameAnimationViewController: UIViewController {
    
    private let animViewSwitch: AnimationView = AnimationView(name: "Switch_frame")
        
//    .then {
//
//        $0.contentMode = UIViewContentMode.scaleAspectFill
//        $0.backgroundBehavior = .pause
//    }
    
    private var isOff: Bool = false
    
    private let animViewEdit: AnimationView = AnimationView(name: "Edit_frame").then {
        
        $0.contentMode = UIViewContentMode.scaleAspectFill
//        $0.backgroundBehavior = .pause
    }
    
    private var isEdit: Bool = false
    
    private let animViewPlay: AnimationView = AnimationView(name: "Play-Pause").then {
        
        $0.contentMode = UIViewContentMode.scaleAspectFill
//        $0.backgroundBehavior = .pause
    }
    
//    var anims: [AnimatedSwitch] = []
    var anims: [AnimationView] = []
    // 是否已选中，是否动画完成
    var animsState: [(Bool, Bool)] = [(true, true), (false, true)]
    
    private var isPlaying: Bool = false

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - UI
extension FrameAnimationViewController {
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.white
        
        title = "FrameAnimation DEMO"
        
//        createSwitch()
//        createEdit()
//        createPlay()
        
        setupTest()
    }
    
    func setupTest() {
        let content = UIView().then {
            $0.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        }
        view.addSubview(content)
        content.snp.makeConstraints {
            $0.center.width.equalToSuperview()
            $0.height.equalTo(80)
        }
        
//        let ani1 = createAnimateView("category", true)
//        let ani2 = createAnimateView("cart", false ,1)
        let ani1 = creatAnimView("category", true)
        let ani2 = creatAnimView("cart", false ,1)
        
        content.addSubview(ani1)
        content.addSubview(ani2)
        
        anims.append(ani1)
        anims.append(ani2)
        
        ani1.snp.makeConstraints {
            $0.left.top.height.equalToSuperview()
            $0.width.equalTo(UIScreen.main.screenWidth / 5)
        }
        
        ani2.snp.makeConstraints {
            $0.height.top.equalToSuperview()
            $0.left.equalTo(ani1.snp.right)
            $0.width.equalTo(ani1)
        }
    }
    
    func createAnimateView(_ jsonName: String, _ isOn: Bool = false, _ tag: Int = 0) -> AnimatedSwitch {
        return AnimatedSwitch().then {
            // bundle ，命名空间
            $0.animation = Animation.named(jsonName, bundle: Bundle.main)
            $0.tag = tag
            // 设定默认选中状态
            $0.isOn = isOn
            $0.isEnabled = !isOn
            // 设定选中状态 经过的progres
            $0.setProgressForState(fromProgress: 0, toProgress: 1, forOnState: true)
            // 设定未选中状态 经过的progres
            $0.setProgressForState(fromProgress: 1, toProgress: 0, forOnState: false)
            
            $0.addTarget(self, action: #selector(tapEvent(sender:)), for: .touchDown)
//            $0.upda
        }
    }
    
    func creatAnimView(_ jsonName: String, _ isOn: Bool = false, _ tag: Int = 0) -> AnimationView {
        return AnimationView().then {
            $0.animation = Animation.named(jsonName, bundle: Bundle.main)
            $0.backgroundBehavior = .pauseAndRestore
            $0.animationSpeed = 1.5
            $0.tag = tag
            $0.currentProgress = isOn ? 1 : 0
            $0.addTouchEvent { [weak self] (_) in
                self?.animaTap(tag)
            }
        }
    }
    
    @objc func tapEvent(sender: UIControl) {
        sender.isEnabled = false
//        anims.forEach {
//            if $0.tag != sender.tag {
//                $0.isOn = false
//                $0.isEnabled = true
//            }
//        }
    }
    
    func animaTap(_ tag: Int) {
        // 当前已选中，不处理，当前动画未完成，不处理
        if animsState[tag].0 { return }
        
        animsState.forEach {
            if $0.0 && !$0.1 { return }
        }
        
        for i in 0..<animsState.count {
            if i != tag {
                animsState[i].0 = false
                animsState[i].1 = true
            }
        }
        
        for i in 0..<anims.count {
            if i != tag {
                DispatchQueue.main.async {
                    self.anims[i].play(toProgress: 0)
//                    self.anims[i].stop()
//                    self.anims[i].currentProgress = 0
//                    self.anims[i].forceDisplayUpdate()
                }
            }
        }
        
//        anims.forEach {
//            if $0.tag != tag {
////                $0.stop()
////                $0.forceDisplayUpdate()
////                $0.layoutIfNeeded()
//            }
//        }
        
        animsState[tag].0 = true
        animsState[tag].1 = false
        anims[tag].play(fromProgress: 0, toProgress: 1, loopMode: .playOnce) { (completed) in
            self.animsState[tag].1 = true
        }
    }
    
    private func createSwitch() {
        
        /*
         OC 需要验证的地方 @山竹
         */
        //    // 根据动画指定 对应的 关键路径 例如：“Background 2.Shape 1.Fill 1.Color”
        //    LOTKeypath *pathOn  = [LOTKeypath keypathWithString:@"BG-On.Group 1.Fill 1.Color"];
        //    LOTKeypath *pathOff = [LOTKeypath keypathWithString:@"BG-Off.Group 1.Fill 1.Color"];
        //
        //    // 遵守 LOTValueDelegate 协议 的对应类
        //    LOTColorValueCallback *onColorValue  = [LOTColorValueCallback withCGColor:UIColor.greenColor.CGColor];
        //    LOTColorValueCallback *offColorValue = [LOTColorValueCallback withCGColor:UIColor.redColor.CGColor];
        //
        //    [_btnSwitch setValueDelegate:onColorValue forKeypath:pathOn];
        //    [_btnSwitch setValueDelegate:offColorValue forKeypath:pathOff];
        
        // 根据动画指定 对应的 关键路径 例如：“Background 2.Shape 1.Fill 1.Color” @山竹，这个玩意我也还没搞懂
        /// *** Keypath Setting
        
//        let redValueProvider = ColorValueProvider(Color(r: 1, g: 0.2, b: 0.3, a: 1))
//        animViewSwitch.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "BG-On.Group 1.Fill 1.Color"))
//        let otherValueProvider = ColorValueProvider(Color(r: 0.3, g: 0.2, b: 0.3, a: 1))
//        animViewSwitch.setValueProvider(otherValueProvider, keypath: AnimationKeypath(keypath: "BG-Off.Group 1.Fill 1.Color"))
        
        // 打印所有子关键路径，例如：“Background 2.Shape 1.Fill 1.Color”
        animViewSwitch.logHierarchyKeypaths()
        animViewSwitch.currentProgress = 0.5
        
        view.addSubview(animViewSwitch)
        
        animViewSwitch.snp.makeConstraints { (maker) in
            
            maker.centerX.equalToSuperview()
            maker.top.equalTo(100)
            maker.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        animViewSwitch.addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.switchHandle()
        }
    }
    
    private func createEdit() {
        
        view.addSubview(animViewEdit)
        
        animViewEdit.snp.makeConstraints { (maker) in
            
            maker.centerX.equalTo(self.animViewSwitch)
            maker.top.equalTo(self.animViewSwitch.snp.bottom).offset(50)
            // btnEdit的width和height从AE文件中获得
            maker.size.equalTo(CGSize(width: 62, height: 62))
        }
        
        // 将动画的进度设置为特定的帧。 如果动画正在播放，它将停止并且完成 完成回调将被调用
        animViewEdit.currentFrame = 54
        
        animViewEdit.addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.editHandle()
        }
    }
    
    private func createPlay() {
        
        view.addSubview(animViewPlay)
        
        animViewPlay.snp.makeConstraints { (maker) in
            
            maker.centerX.equalTo(self.animViewSwitch)
            maker.top.equalTo(self.animViewEdit.snp.bottom).offset(50)
            // btnEdit的width和height从AE文件中获得
            maker.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        // 将动画的进度设置为特定的帧。 如果动画正在播放，它将停止并且完成 完成回调将被调用
        animViewPlay.currentFrame = 50
        
        animViewPlay.addTouchEvent { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            self.playHandle()
        }
    }
}

// MARK: - private method
extension FrameAnimationViewController {
    
    private func switchHandle() {
        
        if isOff {
            
            // 播放动画，从 xx 帧 到 xx 帧，如果 动画JSON文件中有明确的帧的话
//            animViewSwitch.play(fromFrame: <#T##AnimationFrameTime?#>, toFrame: <#T##AnimationFrameTime#>, loopMode: <#T##LottieLoopMode?#>, completion: <#T##LottieCompletionBlock?##LottieCompletionBlock?##(Bool) -> Void#>)
            
            /**
             Plays the animation from a progress (0-1) to a progress (0-1).
             
             - Parameter fromProgress: The start progress of the animation. If `nil` the animation will start at the current progress.
             - Parameter toProgress: The end progress of the animation.
             - Parameter loopMode: The loop behavior of the animation. If `nil` the view's `loopMode` property will be used.
             - Parameter completion: An optional completion closure to be called when the animation stops.
             */
            animViewSwitch.play(fromProgress: 1, toProgress: 0.5, loopMode: .playOnce, completion: { rsl in
                
                print("animViewSwitch 关闭动画播放结束~~~")
            })
            
        } else {
            
            animViewSwitch.play(fromProgress: 0.5, toProgress: 1, loopMode: .playOnce, completion: { rsl in
                
                print("animViewSwitch 打开动画播放结束~~~")
            })
        }
        
        isOff = !isOff
    }
    
    private func editHandle() {
        
        if isEdit {
            
            // Lottie总是从上一次位置开始播放动画，
            // 上一次位置停留的帧可能不是startFrmae，在播放前，需要设置其停留到startFrmae
            animViewEdit.currentFrame = 166
            /**
             Plays the animation from a start frame to an end frame in the animation's framerate.
             
             - Parameter fromProgress: The start progress of the animation. If `nil` the animation will start at the current progress.
             - Parameter toProgress: The end progress of the animation.
             - Parameter loopMode: The loop behavior of the animation. If `nil` the view's `loopMode` property will be used.
             - Parameter completion: An optional completion closure to be called when the animation stops.
             */
            animViewEdit.play(fromFrame: 166, toFrame: 218, loopMode: .playOnce, completion: { rsl in
                
                print("结束编辑~~~")
            })
            
        } else {
            
            animViewEdit.currentFrame = 54
            animViewEdit.play(fromFrame: 54, toFrame: 105, loopMode: .playOnce, completion: { rsl in
                
                print("开始编辑~~~")
            })
        }
        
        isEdit = !isEdit
    }
    
    private func playHandle() {
        
        animViewPlay.loopMode = .playOnce
        
        if isPlaying {
            
            animViewPlay.currentFrame = 180
            animViewPlay.play(fromFrame: 180, toFrame: 213, loopMode: .playOnce, completion: { rsl in
                
                print("恢复开始播放动画~~~")
            })
            
        } else {
            
            animViewPlay.currentFrame = 50
            animViewPlay.play(fromFrame: 50, toFrame: 90, loopMode: .playOnce, completion: { [weak self] rsl in
                
                guard let `self` = self else { return }
                
                self.animViewPlay.play(fromFrame: 90, toFrame: 180, loopMode: .loop, completion: { rsl in
                    
                    print("暂停动画播放完成~~~")
                })
            })
        }
        
        isPlaying = !isPlaying
    }
}

// MARK: - --------------- Snapkit Array 扩展 ---------------
// FIXME: - 需要优化~

public typealias ConstraintEdgeInsets = UIEdgeInsets

public enum ConstraintAxis: Int {
    case horizontal
    case vertical
}

public struct ConstraintArrayDSL {
    @discardableResult
    public func prepareConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        var constraints = Array<Constraint>()
        for view in array {
            constraints.append(contentsOf: view.snp.prepareConstraints(closure))
        }
        return constraints
    }

    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in array {
            view.snp.makeConstraints(closure)
        }
    }

    public func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in array {
            view.snp.remakeConstraints(closure)
        }
    }

    public func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in array {
            view.snp.updateConstraints(closure)
        }
    }

    public func removeConstraints() {
        for view in array {
            view.snp.removeConstraints()
        }
    }

    /// distribute with fixed spacing
    ///
    /// - Parameters:
    ///   - axisType: which axis to distribute items along
    ///   - fixedSpacing: the spacing between each item
    ///   - leadSpacing: the spacing before the first item and the container
    ///   - tailSpacing: the spacing after the last item and the container
    public func distributeViewsAlong(axisType: ConstraintAxis, fixedSpacing: CGFloat = 0, leadSpacing: CGFloat = 0, tailSpacing: CGFloat = 0) {

        guard array.count > 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }

        if axisType == .horizontal {
            var prev: ConstraintView?
            for (i, v) in array.enumerated() {
                v.snp.makeConstraints({ make in
                    guard let prev = prev else { // first one
                        make.left.equalTo(tempSuperView).offset(leadSpacing)
                        return
                    }
                    make.width.equalTo(prev)
                    make.left.equalTo(prev.snp.right).offset(fixedSpacing)
                    if i == self.array.count - 1 { // last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing)
                    }
                })
                prev = v
            }
        } else {
            var prev: ConstraintView?
            for (i, v) in array.enumerated() {
                v.snp.makeConstraints({ make in
                    guard let prev = prev else { // first one
                        make.top.equalTo(tempSuperView).offset(leadSpacing)
                        return
                    }
                    make.height.equalTo(prev)
                    make.top.equalTo(prev.snp.bottom).offset(fixedSpacing)
                    if i == self.array.count - 1 { // last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing)
                    }
                })
                prev = v
            }
        }
    }

    /// distribute with fixed item size
    ///
    /// - Parameters:
    ///   - axisType: which axis to distribute items along
    ///   - fixedItemLength: the fixed length of each item
    ///   - leadSpacing: the spacing before the first item and the container
    ///   - tailSpacing: the spacing after the last item and the container
    public func distributeViewsAlong(axisType: ConstraintAxis, fixedItemLength: CGFloat = 0, leadSpacing: CGFloat = 0, tailSpacing: CGFloat = 0) {

        guard array.count > 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }

        if axisType == .horizontal {
            var prev: ConstraintView?
            for (i, v) in array.enumerated() {
                v.snp.makeConstraints({ make in
                    make.width.equalTo(fixedItemLength)
                    if prev != nil {
                        if i == self.array.count - 1 { // last one
                            make.right.equalTo(tempSuperView).offset(-tailSpacing)
                        } else {
                            let offset = (CGFloat(1) - (CGFloat(i) / CGFloat(self.array.count - 1))) *
                                (fixedItemLength + leadSpacing) -
                                CGFloat(i) * tailSpacing / CGFloat(self.array.count - 1)
                            make.right.equalTo(tempSuperView).multipliedBy(CGFloat(i) / CGFloat(self.array.count - 1)).offset(offset)
                        }
                    } else { // first one
                        make.left.equalTo(tempSuperView).offset(leadSpacing)
                    }
                })
                prev = v
            }
        } else {
            var prev: ConstraintView?
            for (i, v) in array.enumerated() {
                v.snp.makeConstraints({ make in
                    make.height.equalTo(fixedItemLength)
                    if prev != nil {
                        if i == self.array.count - 1 { // last one
                            make.bottom.equalTo(tempSuperView).offset(-tailSpacing)
                        } else {
                            let offset = (CGFloat(1) - (CGFloat(i) / CGFloat(self.array.count - 1))) *
                                (fixedItemLength + leadSpacing) -
                                CGFloat(i) * tailSpacing / CGFloat(self.array.count - 1)
                            make.bottom.equalTo(tempSuperView).multipliedBy(CGFloat(i) / CGFloat(self.array.count - 1)).offset(offset)
                        }
                    } else { // first one
                        make.top.equalTo(tempSuperView).offset(leadSpacing)
                    }
                })
                prev = v
            }
        }
    }

    /// distribute Sudoku with fixed item size
    ///
    /// - Parameters:
    ///   - fixedItemWidth: the fixed width of each item
    ///   - fixedItemLength: the fixed length of each item
    ///   - warpCount: the warp count in the super container
    ///   - edgeInset: the padding in the super container
    public func distributeSudokuViews(fixedItemWidth: CGFloat, fixedItemHeight: CGFloat, warpCount: Int, edgeInset: ConstraintEdgeInsets = .zero) {

        guard array.count > 1, warpCount >= 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }

        let remainder = array.count % warpCount
        let quotient = array.count / warpCount

        let rowCount = (remainder == 0) ? quotient : (quotient + 1)
        let columnCount = warpCount

        for (i, v) in array.enumerated() {

            let currentRow = i / warpCount
            let currentColumn = i % warpCount

            v.snp.makeConstraints({ make in
                make.width.equalTo(fixedItemWidth)
                make.height.equalTo(fixedItemHeight)
                if currentRow == 0 { // fisrt row
                    make.top.equalTo(tempSuperView).offset(edgeInset.top)
                }
                if currentRow == rowCount - 1 { // last row
                    make.bottom.equalTo(tempSuperView).offset(-edgeInset.bottom)
                }

                if currentRow != 0 && currentRow != rowCount - 1 { // other row
                    let offset = (CGFloat(1) - CGFloat(currentRow) / CGFloat(rowCount - 1)) *
                        (fixedItemHeight + edgeInset.top) -
                        CGFloat(currentRow) * edgeInset.bottom / CGFloat(rowCount - 1)
                    make.bottom.equalTo(tempSuperView).multipliedBy(CGFloat(currentRow) / CGFloat(rowCount - 1)).offset(offset)
                }

                if currentColumn == 0 { // first col
                    make.left.equalTo(tempSuperView).offset(edgeInset.left)
                }
                if currentColumn == columnCount - 1 { // last col
                    make.right.equalTo(tempSuperView).offset(-edgeInset.right)
                }

                if currentColumn != 0 && currentColumn != columnCount - 1 { // other col
                    let offset = (CGFloat(1) - CGFloat(currentColumn) / CGFloat(columnCount - 1)) *
                        (fixedItemWidth + edgeInset.left) -
                        CGFloat(currentColumn) * edgeInset.right / CGFloat(columnCount - 1)
                    make.right.equalTo(tempSuperView).multipliedBy(CGFloat(currentColumn) / CGFloat(columnCount - 1)).offset(offset)
                }
            })
        }
    }

    /// distribute Sudoku with fixed item spacing
    ///
    /// - Parameters:
    ///   - fixedLineSpacing: the line spacing between each item
    ///   - fixedInteritemSpacing: the Interitem spacing between each item
    ///   - warpCount: the warp count in the super container
    ///   - edgeInset: the padding in the super container
    public func distributeSudokuViews(fixedLineSpacing: CGFloat, fixedInteritemSpacing: CGFloat, warpCount: Int, edgeInset: ConstraintEdgeInsets = .zero) {

        guard array.count > 1, warpCount >= 1, let tempSuperView = commonSuperviewOfViews() else {
            return
        }

        let remainder = array.count % warpCount
        let quotient = array.count / warpCount

        let rowCount = (remainder == 0) ? quotient : (quotient + 1)
        let columnCount = warpCount

        var prev: ConstraintView?

        for (i, v) in array.enumerated() {

            let currentRow = i / warpCount
            let currentColumn = i % warpCount

            v.snp.makeConstraints({ make in
                guard let prev = prev else { // first row & first col
                    make.top.equalTo(tempSuperView).offset(edgeInset.top)
                    make.left.equalTo(tempSuperView).offset(edgeInset.left)
                    return
                }
                make.width.height.equalTo(prev)
                if currentRow == rowCount - 1 { // last row
                    if currentRow != 0 && i - columnCount >= 0 { // just one row
                        make.top.equalTo(self.array[i - columnCount].snp.bottom).offset(fixedLineSpacing)
                    }
                    make.bottom.equalTo(tempSuperView).offset(-edgeInset.bottom)
                }

                if currentRow != 0 && currentRow != rowCount - 1 { // other row
                    make.top.equalTo(self.array[i - columnCount].snp.bottom).offset(fixedLineSpacing)
                }
                if currentColumn == warpCount - 1 { // last col
                    if currentColumn != 0 { // just one line
                        make.left.equalTo(prev.snp.right).offset(fixedInteritemSpacing)
                    }
                    make.right.equalTo(tempSuperView).offset(-edgeInset.right)
                }

                if currentColumn != 0 && currentColumn != warpCount - 1 { // other col
                    make.left.equalTo(prev.snp.right).offset(fixedInteritemSpacing)
                }
            })
            prev = v
        }
    }

    internal let array: Array<ConstraintView>

    internal init(array: Array<ConstraintView>) {
        self.array = array
    }
}

public extension Array {
    var snp: ConstraintArrayDSL {
        return ConstraintArrayDSL(array: self as! Array<ConstraintView>)
    }
}

private extension ConstraintArrayDSL {
    func commonSuperviewOfViews() -> ConstraintView? {
        var commonSuperview: ConstraintView?
        var previousView: ConstraintView?

        for view in array {
            if previousView != nil {
                commonSuperview = view.closestCommonSuperview(commonSuperview)
            } else {
                commonSuperview = view
            }
            previousView = view
        }

        return commonSuperview
    }
}

private extension ConstraintView {
    func closestCommonSuperview(_ view: ConstraintView?) -> ConstraintView? {
        var closestCommonSuperview: ConstraintView?
        var secondViewSuperview: ConstraintView? = view
        while closestCommonSuperview == nil && secondViewSuperview != nil {
            var firstViewSuperview: ConstraintView? = self
            while closestCommonSuperview == nil && firstViewSuperview != nil {
                if secondViewSuperview == firstViewSuperview {
                    closestCommonSuperview = secondViewSuperview
                }
                firstViewSuperview = firstViewSuperview?.superview
            }
            secondViewSuperview = secondViewSuperview?.superview
        }
        return closestCommonSuperview
    }
}
