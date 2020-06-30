
//class DailyMarketViewController: MallBaseViewController {
//    let typeTop = UIDevice.isNotchPhone() ? 65+34 : 65
//    let bannerTop = UIDevice.isNotchPhone() ? 104+34 : 104
//    let brandTop = UIDevice.isNotchPhone() ? 194+34 : 194
//    var quotationType = 1
//    let milk = "milk"
//    let diapers = "diapers"
//    var isClickToScroll = false
//    var mapData = [String: DailyMarketModel]() {
//        didSet {
//            self.model = self.quotationType == 1 ? mapData[milk] : mapData[diapers]
//        }
//    }
//
//    private let provider = DailyMarketProvider.provider()
//    var model: DailyMarketModel? {
//        didSet {
//            headerView.titleLabel.text = model?.data?.title
//            bannerView.imageView.setNetImg(model?.data?.bannerUrl ?? "")
//            brandView.config(list: model?.data?.brandList ?? [])
//            if let redpill = model?.data?.redPill {
//                if let cart = redpill["buyCart"] {
//                    shopCartBtn.newExtendFields = cart
//                }
//                typeView.bindRedpill(map: redpill)
//            }
//            tableView.reloadData()
//        }
//    }
//
//    let headerView = DailyMarketHeaderView()
//
//    let typeView = DailyMarketTypeView()
//
//    let bannerView = DailyMarketBannerView()
//
//    let brandView = DailyMarketBrandView().then {
//        $0.backgroundColor = UIColor(hexString: "f1f2f3")
//    }
//
//    private let backBtn: YTInsideBtns = YTInsideBtns(type: .custom).then { btn in
//        btn.setImage(Iconfont.imageWithIcon(content: "\u{e6b1}", backgroundColor: .clear, iconColor: .white, size: CGSize(width: 22, height: 22)), for: .normal)
//        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
//    }
//
//    private let shopCartBtn: YTInsideBtns = YTInsideBtns(type: .custom).then { btn in
//        btn.setImage(Iconfont.imageWithIcon(content: "\u{e6a2}", backgroundColor: .clear, iconColor: .white, size: CGSize(width: 22, height: 22)), for: .normal)
//        btn.addTarget(self, action: #selector(addCart), for: .touchUpInside)
//    }
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: view.bounds, style: .grouped)
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = UIColor(hexString: "f1f2f3")
//        tableView.estimatedRowHeight = 44
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.bounces = false
//        tableView.showsVerticalScrollIndicator = false
//        tableView.showsHorizontalScrollIndicator = false
//        tableView.register(DailyMarketCell.self, forCellReuseIdentifier: "DailyMarketCell")
//        tableView.register(DailyMarketGoodsHeaderView.self, forHeaderFooterViewReuseIdentifier: "DailyMarketGoodsHeaderView")
//        tableView.register(DailyMarketGoodsFooterView.self, forHeaderFooterViewReuseIdentifier: "DailyMarketGoodsFooterView")
//        return tableView
//    }()
//
//    let secreKeyBtn = UIButton().then { btn in
//        btn.layer.cornerRadius = 12
//        btn.clipsToBounds = true
//        btn.setTitle("拍口令", for: .normal)
//        btn.setTitleColor(UIColor.white, for: .normal)
//        btn.backgroundColor = UIColor(hexString: "333333")
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        btn.addTarget(self, action: #selector(secreKey), for: .touchUpInside)
//    }
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(hexString: "f1f2f3")
//        configPage()
//        typeView.selectIndex(index: quotationType)
//        configColor()
//        fetchData()
//        fd_prefersNavigationBarHidden = true
//    }
//
//    private func configPage() {
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.left.top.right.bottom.equalToSuperview()
//        }
//        tableView.contentInset = UIEdgeInsets(top: CGFloat(brandTop + 40), left: 0.0, bottom: 0.0, right: 0.0)
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
//
//        view.addSubview(bannerView)
//        bannerView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(bannerTop)
//            make.height.equalTo(90)
//        }
//
//        view.addSubview(headerView)
//        headerView.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            make.height.equalTo(typeTop)
//        }
//
//        view.addSubview(typeView)
//        typeView.delegate = self
//        typeView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(typeTop)
//            make.height.equalTo(40)
//        }
//
//        view.addSubview(brandView)
//        brandView.delegate = self
//        brandView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(brandTop)
//            make.height.equalTo(40)
//        }
//        view.addSubview(backBtn)
//        view.addSubview(shopCartBtn)
//        backBtn.snp.makeConstraints { make in
//            make.top.equalTo(UIDevice.isNotchPhone() ? 33 + 34 : 33)
//            make.left.equalTo(15)
//            make.width.height.equalTo(22)
//        }
//        shopCartBtn.snp.makeConstraints { make in
//            make.right.equalTo(-15)
//            make.top.equalTo(backBtn.snp.top)
//            make.width.height.equalTo(22)
//        }
//        typeView.tableView = tableView
//        bannerView.tableView = tableView
//
//        if OCAppInfo.shareInstance().isEmployeeStore {
//            view.addSubview(secreKeyBtn)
//            secreKeyBtn.snp.makeConstraints { make in
//                make.top.equalTo(160)
//                make.right.equalTo(8)
//                make.width.equalTo(68)
//                make.height.equalTo(24)
//            }
//        }
//    }
//
//    @objc func secreKey() {
//        YTMainDataManager.secreKey(["quotationType": quotationType])
//    }
//
//    @objc func back() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @objc func addCart() {
//        _ = Router.shared.handleClassShortName("ShopCart", target: self, parameters: nil)
//    }
//
//    func fetchData() {
//        YTProgressHUD.showAdded(to: self.view)
//        _ = provider.rx.request(.quotationConfig(type: quotationType)).mapModel(DailyMarketModel.self).subscribe(onSuccess: { [weak self] item in
//
//            guard self != nil else { return }
//            YTProgressHUD.hide(for: self?.view)
//            if item.success ?? false {
//                item.data?.brandList?.first?.isChose = true
//                self!.mapData[self?.quotationType == 1 ? self!.milk : self!.diapers] = item
//                self?.getLastBrandData(key: (self?.quotationType == 1 ? self?.milk : self?.diapers) ?? "milk")
//            }
//            }, onError: { error in
//                YTProgressHUD.hide(for: self.view)
//                if let moyaError = error as? MoyaError,
//                    case let .underlying(error, _) = moyaError,
//                    (error as NSError).code == -1009 {
//                }
//        })
//    }
//
//    func getLastBrandData(key: String) {
//        var list = [Int]()
//        for m in currentModel(key: key)?.data?.brandList ?? [] {
//            list.append(m.id ?? 0)
//        }
//        list.remove(at: 0)
//        _ = provider.rx.request(.querySeriesItemByBrandId(list)).mapModel(DailyMarketBrandIDModel.self).subscribe(onSuccess: { [weak self] item in
//
//            guard self != nil else { return }
//            if item.success ?? false {
//                for m in item.data ?? [] {
//                    if let model = self?.currentModel(key: key) {
//                        for a in model.data?.brandList ?? [] {
//                            if m.id == a.id && m.seriesList?.count != 0 {
//                                a.seriesList = m.seriesList
//                            }
//                        }
//                    }
//                }
//                self?.mapData = self?.mapData ?? [:]
//            }
//            }, onError: { error in
//
//                if let moyaError = error as? MoyaError,
//                    case let .underlying(error, _) = moyaError,
//                    (error as NSError).code == -1009 {
//                }
//        })
//    }
//
//    private func currentModel(key: String) -> DailyMarketModel? {
//        return key == milk ? mapData[milk] : mapData[diapers]
//    }
//}
//
//extension DailyMarketViewController: DailyMarketTypeViewProtocol,DailyMarketBrandViewProtocol,DailyMarketCellProtocol {
//
//    func clickType(index: Int) {
//        view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.15, animations: {
//            self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.brandTop+40)), animated: false)
//        }) { (_) in
//            self.reloadDataToTop(index: index)
//            self.configColor()
//        }
//    }
//    private func reloadDataToTop(index: Int) -> Void {
//
//        quotationType = index + 1
//        if mapData.count != 2 {
//            fetchData()
//        } else {
//            let a = mapData
//            mapData = a
//        }
//        if let list = self.model?.data?.brandList {
//            var a: Int = 0
//            for m in list {
//                m.isChose = false
//                a = a + 1
//            }
//            list.first?.isChose = true
//            brandView.refresh()
//        }
//    }
//    private func configColor() -> Void {
//        headerView.gradientLayer?.colors = quotationType == 1 ? [UIColor(hexString: "ff4b78")?.cgColor ?? UIColor.red, UIColor(hexString: "ff9f80")?.cgColor ?? UIColor.red] : [UIColor(hexString: "3C91FF")?.cgColor ?? UIColor.red, UIColor(hexString: "88BBFF")?.cgColor ?? UIColor.red]
//        typeView.gradientLayer?.colors = headerView.gradientLayer?.colors
//    }
//
//    func clickIndex(index: Int) {
//        if let m = model?.data?.brandList?[index], let list = model?.data?.customSection {
//            let id = m.seriesList?.first?.id
//            var a = 0
//            var section: Int?
//            for b in list {
//                if id == b.id {
//                    section = a
//                    break
//                }
//                a = a+1
//            }
//            if section != nil && section! < list.count {
//                brandView.refresh()
//                isClickToScroll = true
//                tableView.scrollToRow(at: IndexPath(row: 0, section: section ?? 0), at: .top, animated: true)
//            }
//        }
//    }
//
//    func didSelect(model: DailyMarketItemListModel, index: Int) {
//
//        if index == 1 {
//            addToCart(model: model)
//        }else{
//            buyNow(model: model)
//        }
//    }
//
//    private func buyNow(model: DailyMarketItemListModel) {
//
//        var url = "ytmallAppStatic/_version_/view/order/addGenerateOrder.html?nums=1&type=detail"
//        if let id = model.activeId {
//            url.append("&activeId=\(id)")
//        }
//        if let itemId = model.itemId {
//            url.append("&itemId=\(itemId)")
//        }
//        if let skuOuterBizId = model.skuOuterBizId {
//            url.append("&skuOuterBizId=\(skuOuterBizId)")
//        }
//        let webview = WebViewController.init()
//        webview.linkSuffix = url;
//        self.navigationController?.pushViewController(webview, animated: true)
//    }
//
//    private func addToCart(model: DailyMarketItemListModel) {
//
//        var map = [String:Any]()
//        map["itemCount"] = 1
//        if let id = model.activeId {
//            map["activeId"] = id
//        }
//        if let itemId = model.itemId {
//            map["itemId"] = itemId
//        }
//        if let skuOuterBizId = model.skuOuterBizId {
//            map["skuOuterBizId"] = skuOuterBizId
//        }
//
//        _ = provider.rx.request(.putItem2Cart(map)).mapModel(YTMainBaseModel.self).subscribe(onSuccess: { [weak self] (item) in
//
//            guard self != nil else { return }
//            if item.success ?? false {
//                YTShowMessageView.showMessage("成功加入购物车")
//            }
//            }, onError: { error in
//
//                if let moyaError = error as? MoyaError,
//                    case let .underlying(error, _) = moyaError,
//                    (error as NSError).code == -1009 {
//                }
//        })
//    }
//}
//
//extension DailyMarketViewController: UITableViewDelegate,UITableViewDataSource {
//
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return model?.data?.customSection?.count ?? 0
//    }
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return model?.data?.customSection?[section].itemList?.count ?? 1
//    }
//
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let list = self.model?.data?.customSection?[indexPath.section].itemList, indexPath.item == list.count - 1 {
//            return 69
//        }
//        return 59
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyMarketCell", for: indexPath)
//        let model = self.model?.data?.customSection?[indexPath.section].itemList?[indexPath.row]
//        (cell as? DailyMarketCell)?.config(model: model, agency: self)
//        return cell
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let model = self.model?.data?.customSection?[indexPath.section].itemList?[indexPath.row], let id = model.itemId {
//            _ = Router.shared.handleClassShortName("Detail", target: self, parameters: ["itemId": id])
//        }
//    }
//
//    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if  let list = self.model?.data?.customSection, section==list.count-1 {
//            return 50
//        }
//        return 0.1
//    }
//
//    public func  tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if  let list = self.model?.data?.customSection, section==list.count-1 {
//            return tableView.dequeueReusableHeaderFooterView(withIdentifier: "DailyMarketGoodsFooterView")
//        }
//        return nil
//    }
//
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 45
//    }
//
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DailyMarketGoodsHeaderView")
//        let m = model?.data?.customSection?[section]
//        (header as? DailyMarketGoodsHeaderView)?.config(m)//
//        if let a = header as? DailyMarketGoodsHeaderView {
//            a.brandView.backgroundColor = quotationType==1 ?UIColor.init(hexString: "ffe2da"):UIColor.init(hexString: "D6ECFF")
//        }
//        return header
//    }
//
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let c = UIDevice.isNotchPhone() ? brandTop+40 : brandTop+40
//        let y = c - Int(abs(scrollView.contentOffset.y))
//        if scrollView.contentOffset.y < 0 {
//            if view.subviews.contains(headerView) {
//                let a: CGFloat = CGFloat(y) * 1.2
//                let alpha = a / 15
//                let d: CGFloat = UIDevice.isNotchPhone() ? 33.0 + 34.0 : 33.0
//                headerView.titleLabel.snp.updateConstraints { make in
//                    make.top.equalTo(d - a > 15.0 ? d - a : d)
//                }
//                headerView.titleLabel.alpha = 1.0 - alpha
//            }
//
//            if view.subviews.contains(typeView) {
//                typeView.snp.updateConstraints { make in
//                    let top = typeTop - y
//                    let b = UIDevice.isNotchPhone() ? 34 + 25 : 25
//                    make.top.equalTo(top > b ? top : b)
//                }
//            }
//            if view.subviews.contains(bannerView) {
//                bannerView.snp.updateConstraints { make in
//                    make.top.equalTo(bannerTop - y)
//                }
//            }
//            if view.subviews.contains(brandView) {
//                let top: Int = brandTop - y
//                brandView.lineView.isHidden = top > typeTop
//                brandView.backgroundColor = top > typeTop ? UIColor(hexString: "f1f2f3") : UIColor.white
//                brandView.snp.updateConstraints { make in
//                    make.top.equalTo(top > typeTop ? top : typeTop)
//                }
//            }
//        }
//        if  isClickToScroll == false {
//
//            if let index = tableView.indexPathForRow(at: CGPoint.init(x: 0, y: tableView.contentOffset.y+CGFloat(bannerTop))) {
//
//                if let brandList = model?.data?.brandList, let list = model?.data?.customSection, let id = list[index.section].id {
//                    var section: Int?
//                    var a = 0
//                    for b in brandList {
//                        if let h = b.seriesList {
//                            for g in h {
//                                if id==g.id {
//                                    section = a
//                                    break
//                                }
//                            }
//                        }
//                        a = a+1
//                    }
//                    if section != nil && section! < brandList.count {
//                        var a = 0
//                        for m in brandList {
//                            m.isChose = a==section! ?true:false
//                            a = a + 1
//                        }
//                        brandView.refresh()
//                    }
//                }
//            }
//        }
//    }
//
//    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        isClickToScroll = false
//    }
//}
