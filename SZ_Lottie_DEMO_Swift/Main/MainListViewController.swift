//
//  MainListViewController.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 山竹 on 2019/5/20.
//  Copyright © 2019 颜浪. All rights reserved.
//

import UIKit

import Then
import Lottie
import SnapKit
import RxSwift
import RxCocoa

/*
 官方文档: http://airbnb.io/lottie/ios/dynamic.html
 免费动画下载: https://www.lottiefiles.com/
 
 Lottie也有一定的限制(来源：https://github.com/syik/JR):
 
 -- Lottie是基于CALayer的动画, 所有的路径预先在AE中计算好, 转换为Json文件, 然后自动转换为Layer的动画, 所以性能理论上是非常不错的, 在实际使用中, 确实很不错, 但是有几点需要注意的:
 
 -- 如果使用了素材, 那么素材图片的每个像素都会直接加载进内存, 并且是不能释放掉的(实测, 在框架中有个管理cache的类, 并没有启动到作用, 若大家找到方法请告诉我), 所以, 如果是一些小图片, 加载进去也还好, 但是如果是整页的启动动画, 如上面的启动页动画, 不拆分一下素材, 可能一个启动页所需要的内存就是50MB以上. 如果不使用素材, 而是在AE中直接绘制则没有这个问题.
 
 -- 如果使用的PS中绘制的素材, 在AE中做动画, 可能在动画导出的素材中出现黑边, 我的解决办法是将素材拖入PS去掉黑边, 同名替换.
 
 -- 拆分素材的办法是将一个动画中静态的部分直接切出来加载, 动的部分单独做动画
 
 -- 如果一个项目中使用了多个Lottie的动画, 需要注意Json文件中的路径及素材名称不能重复, 否则会错乱
 
 -- 不支持渐变色
 
 -- 不支持AE中的mask属性
 
 基于以上的问题, 建议使用Lottie的场合为复杂的播放式形变动画, 因为形变动画由程序员一点点的写路径确实不直观且效率低. 但即便如此, Lottie也是我们在CoreAnimation之后一个很好的补充.
 */

private let cellId = "cellId"

/// 主页面
class MainListViewController: UIViewController {
    
    /// 头部动画
    private let animViewHead: AnimationView = AnimationView(name: "coding_ape").then {
        
        $0.contentMode = UIViewContentMode.scaleAspectFill
        // 默认值到后台暂停，到前台继续播放完，然后暂停
        // pauseAndRestore 后台到前台，接着没播放完的继续播放，如果是已经暂停了，则从开始开始播放，需要循环播放的动画，使用该属性
        $0.backgroundBehavior = .pauseAndRestore
    }
    
    private let tableView: UITableView = UITableView().then {
        
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        $0.tableFooterView = UIView.init()
    }
    
    private let bag: DisposeBag = DisposeBag()
    
    /// 数据数组
    private var dataList = [["title": "UIControls Demo",
                             "vcName": "ControlsViewController"],
                            ["title": "Refresh Demo",
                             "vcName": "RefreshViewController"],
                            ["title": "FrameAnimation Demo",
                             "vcName": "FrameAnimationViewController"],
                            ["title": "Loading & DefaultView Demo",
                             "vcName": "LoadingViewController"],
                            ["title": "ServeAnimation Demo",
                             "vcName": "ServeAnimationViewController"],
                            ["title": "Transition Demo(Swift 不支持)",
                             "vcName": "TransitionViewController"],
                            ["title": "ScrollerTest Demo",
                             "vcName": "ScrollerTestViewController"]];
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        animViewHead.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        animViewHead.pause()
    }
}

// MARK: - public method
extension MainListViewController {
    
    /// 播放头部动画
    func playHeadAnimation() {
        
        animViewHead.play()
    }
}

// MARK: - UI
extension MainListViewController {
    
    private func setupUI() {
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        title = "Main Title"
        
        setupNavLeftBtn()
        createNavigationRightButton()
        setupHeadView()
        setupTableView()
    }
    
    private func setupHeadView() {
        
        animViewHead.addTouchEvent { [weak self] (_) in
            guard let `self` = self else { return }
            self.showHeadAnimation()
        }
        
        view.addSubview(animViewHead)
        
        animViewHead.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.height.equalTo(UIScreen.main.bounds.height * 0.4)
        }
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.animViewHead.snp.bottom)
            maker.left.bottom.right.equalToSuperview()
        }
        
        handleRxTableView()
    }
    
    private func setupNavLeftBtn() {
        
        let leftBtn: AnimatedSwitch = AnimatedSwitch()
        leftBtn.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        
        // bundle ，命名空间
        leftBtn.animation = Animation.named("floating_action_button", bundle: Bundle.main)
        // 设置 frame 无效 @山竹
        leftBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 100)
//        leftBtn.contentMode = UIViewContentMode.scaleAspectFill
        // 设定默认选中状态
        leftBtn.isOn = false
        // 设定选中状态 经过的progres
        leftBtn.setProgressForState(fromProgress: 0.5, toProgress: 0, forOnState: true)
        // 设定未选中状态 经过的progres
        leftBtn.setProgressForState(fromProgress: 0, toProgress: 0.5, forOnState: false)
        
        // 不能用 rx ，获取不到 sender
//        leftBtn.rx.controlEvent(UIControlEvents.touchDragOutside).subscribe(onNext: { (leftSwitch) in
//
//            print("The selected state is \(leftSwitch.on ? "YES" : "NO")")
//        })
//        .disposed(by: bag)
        
        leftBtn.addTarget(self, action: #selector(touchuedNavLeftButton(sender:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    }
    
    private func createNavigationRightButton() {
        
        let rightBtn: AnimationView = AnimationView(name: "notification")
        
        rightBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        /*
         /// Animation is played once then stops.
         case playOnce
         /// Animation will loop from end to beginning until stopped.
         case loop
         /// Animation will play forward, then backwards and loop until stopped.
         case autoReverse
         */
        rightBtn.loopMode = .loop
        rightBtn.backgroundBehavior = .pauseAndRestore
        rightBtn.play()
        
//        rightBtn.addTouchEvent { [weak self] (_) in
//
//            guard let `self` = self else { return }
//
//            self.navigationController?.pushViewController(LoadingViewController(), animated: true)
//        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
}

// MARK: - IBAction
extension MainListViewController {
    
    @objc func touchuedNavLeftButton(sender: AnimatedSwitch) {
        
        print("The selected state is \(sender.isOn ? "YES" : "NO")")
    }
}

// MARK: - rx handle
extension MainListViewController {
    
    /// 使用 rx 处理 DataSource 和 delegate
    private func handleRxTableView() {
        
        Observable.just(dataList)
            .bind(to: tableView.rx.items) { (tb, row, dic) -> UITableViewCell in
            
            let cell = tb.dequeueReusableCell(withIdentifier: cellId)
            
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.textLabel?.text = dic["title"]
            
            return cell ?? UITableViewCell()
            
        }.disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            
            guard let `self` = self else { return }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            if let vcClassName = self.dataList[indexPath.row]["vcName"],
                let vcClass = NSClassFromString(Bundle.main.namespace + "." + vcClassName) as? UIViewController.Type {

                self.navigationController?.pushViewController(vcClass.init(), animated: true)
            }
            
        }).disposed(by: bag)
    }
}

/// MARK: - private method
extension MainListViewController {
    
    /// 播放头部动画
    private func showHeadAnimation() {
        // 重置当前进度
        animViewHead.currentProgress = 0
        animViewHead.play()
    }
}
