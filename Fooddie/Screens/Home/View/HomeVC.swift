//
//  HomeVC.swift
//  FoodApp
//
//  Created by Muhammad Khan on 11/11/2020.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC : UIViewController {
    
    @IBOutlet weak var offersScrollView: UIScrollView!
    @IBOutlet weak var offersStackView: UIStackView!
    @IBOutlet weak var stickyHeaderView: UIView!
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var curvedView: UIView!
    @IBOutlet weak var cartCuntLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    
    var presenter : HomePresenterInterface!
    private let disposeBag = DisposeBag()
    
    var pageViewController = UIPageViewController()
    var pageCollection = PageCollection()
    var topViewInitialHeight : CGFloat = 600
    let topViewFinalHeight : CGFloat = 120
    var dragInitialY: CGFloat = 0
    var dragPreviousY: CGFloat = 0
    var dragDirection: DragDirection = .Up
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        populateViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: View Setup
    
    func setupView(){
        setupOffersView()
        setupCollectionView()
        setupPagingViewController()
        addPanGestureToTopViewAndCollectionView()
    }
    
    func populateViews(){
        populateOffers()
        presenter.inputs.getCategoriesAction.onNext(())
        populateBottomView()
        presenter.outputs.cartItems
            .asObservable()
            .subscribe(onNext: { value in
                self.cartButton.isHidden = value == 0
                self.cartCuntLabel.isHidden = value == 0
                self.cartCuntLabel.text = "\(value)"
            })
            .disposed(by: disposeBag)
    }
    
    func setupOffersView(){
        offersScrollView.delegate = self
        headerViewHeightConstraint.constant = topViewInitialHeight
    }
    
    func setupCollectionView() {
        tabBarCollectionView.register(UINib(nibName: TabBarCollectionViewCellID, bundle: nil),
                                      forCellWithReuseIdentifier: TabBarCollectionViewCellID)
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.delegate = self
        curvedView.layer.backgroundColor = UIColor.white.cgColor
        curvedView.layer.masksToBounds = true
        curvedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        curvedView.layer.cornerRadius = 16
    }
    
    func setupPagingViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        bottomView.addSubview(pageViewController.view)
        
        pinPagingViewControllerToBottomView()
    }
    
    func populateOffers(){
        presenter.inputs.getOffersAction.onNext(())
        presenter.outputs.offers
            .asObservable()
            .subscribe(onNext: { val in
                for item in val {
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.offersScrollView.frame.width, height: self.offersScrollView.frame.height))
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.imageUrl = item.image
                    imageView.contentMode = .scaleAspectFill
                    imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                    self.offersStackView.addArrangedSubview(imageView)
                }
                self.pageControl.numberOfPages = val.count
            })
            .disposed(by: disposeBag)
    }
    
    func populateBottomView() {
        pageCollection.pages.removeAll()
        presenter.outputs.pages
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                self?.pageCollection.pages = val
                self?.pageCollection.selectedPageIndex = 0
                for item in val {
                    (item.vc as? TabChildVC)?.innerTableViewScrollDelegate = self
                }
                self?.tabBarCollectionView.reloadData()
                if let vc = val.first?.vc {
                    self?.pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
                    self?.tabBarCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func pinPagingViewControllerToBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pageViewController.view.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
    }

    func addPanGestureToTopViewAndCollectionView() {
        let topViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(topViewMoved))
        stickyHeaderView.isUserInteractionEnabled = true
        stickyHeaderView.addGestureRecognizer(topViewPanGesture)
    }
    
    @objc func topViewMoved(_ gesture: UIPanGestureRecognizer) {
        
        var dragYDiff : CGFloat
        
        switch gesture.state {
            
        case .began:
            
            dragInitialY = gesture.location(in: self.view).y
            dragPreviousY = dragInitialY
            
        case .changed:
            
            let dragCurrentY = gesture.location(in: self.view).y
            dragYDiff = dragPreviousY - dragCurrentY
            dragPreviousY = dragCurrentY
            dragDirection = dragYDiff < 0 ? .Down : .Up
            innerTableViewDidScroll(withDistance: dragYDiff)
            
        case .ended:
            
            innerTableViewScrollEnded(withScrollDirection: dragDirection)
            
        default: return
        
        }
    }
    
    //MARK:- UI Laying Out Methods
    
    func setBottomPagingView(toPageWithAtIndex index: Int, andNavigationDirection navigationDirection: UIPageViewController.NavigationDirection) {
        
        pageViewController.setViewControllers([pageCollection.pages[index].vc],
                                                  direction: navigationDirection,
                                                  animated: true,
                                                  completion: nil)
    }
    
    @IBAction func cartButtonAction(_ sender: Any) {
        self.presenter.inputs.cartButtonTappedAction.onNext(())
    }
    
}

//MARK:- Collection View Data Source

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCollection.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let tabCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCollectionViewCellID, for: indexPath) as? TabBarCollectionViewCell {
            tabCell.tabNameLabel.text = pageCollection.pages[indexPath.row].name
            return tabCell
        }
        
        return UICollectionViewCell()
    }
}

//MARK:- Collection View Delegate

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == pageCollection.selectedPageIndex {
            
            return
        }
        
        var direction: UIPageViewController.NavigationDirection
        
        if indexPath.item > pageCollection.selectedPageIndex {
            
            direction = .forward
            
        } else {
            
            direction = .reverse
        }
        
        pageCollection.selectedPageIndex = indexPath.item
        
        tabBarCollectionView.scrollToItem(at: indexPath,
                                          at: .left,
                                          animated: true)
        
        setBottomPagingView(toPageWithAtIndex: indexPath.item, andNavigationDirection: direction)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let title = pageCollection.pages.last?.name ?? ""
        let width = collectionView.frame.width - title.widthOfString(usingFont: .boldSystemFont(ofSize: 35)) + 30
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = pageCollection.pages[indexPath.row].name
//        let width = UILabel.textWidth(font: .boldSystemFont(ofSize: 30), text: title)
        return CGSize(width: title.widthOfString(usingFont: .boldSystemFont(ofSize: 35)) + 30, height: collectionView.frame.height)
    }

}

//MARK:- Delegate Method to give the next and previous View Controllers to the Page View Controller

extension HomeVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (1..<pageCollection.pages.count).contains(currentViewControllerIndex) {
                
                // go to previous page in array
                
                return pageCollection.pages[currentViewControllerIndex - 1].vc
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (0..<(pageCollection.pages.count - 1)).contains(currentViewControllerIndex) {
                
                // go to next page in array
                
                return pageCollection.pages[currentViewControllerIndex + 1].vc
            }
        }
        return nil
    }
}

//MARK:- Delegate Method to tell Inner View Controller movement inside Page View Controller
//Capture it and change the selection bar position in collection View

extension HomeVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        
        guard let currentVCIndex = pageCollection.pages.firstIndex(where: { $0.vc == currentVC }) else { return }
        
        let indexPathAtCollectionView = IndexPath(item: currentVCIndex, section: 0)
        tabBarCollectionView.selectItem(at: indexPathAtCollectionView,
                                        animated: true,
                                        scrollPosition: .left)
    }
}

//MARK:- Sticky Header Effect

extension HomeVC: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        
        return headerViewHeightConstraint.constant + headerViewTopConstraint.constant
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
       
        if headerViewHeightConstraint.constant >= topViewFinalHeight {
            if scrollDistance < 0 && headerViewTopConstraint.constant == 0{
                headerViewHeightConstraint.constant -= scrollDistance
            }else if scrollDistance >= 0{
                headerViewHeightConstraint.constant -= scrollDistance
            }
        }
        
        if headerViewHeightConstraint.constant <= topViewFinalHeight {
            headerViewTopConstraint.constant -= scrollDistance
        }
        
        /* Don't restrict the downward scroll.
 
        if headerViewHeightConstraint.constant > topViewInitialHeight {

            headerViewHeightConstraint.constant = topViewInitialHeight
        }
         
        */

        if headerViewTopConstraint.constant < -(topViewFinalHeight) {
            headerViewTopConstraint.constant = -(topViewFinalHeight)
        }

        if headerViewTopConstraint.constant > 0 {
            headerViewTopConstraint.constant = 0
        }
        
        if headerViewHeightConstraint.constant < topViewFinalHeight {
            headerViewHeightConstraint.constant = topViewFinalHeight
        }
    }
    
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection) {
        
        let topViewHeight = headerViewHeightConstraint.constant
        
        /*
         *  Scroll is not restricted.
         *  So this check might cause the view to get stuck in the header height is greater than initial height.
 
        if topViewHeight >= topViewInitialHeight || topViewHeight <= topViewFinalHeight { return }
         
        */
        
        if topViewHeight <= topViewFinalHeight + 20 {
            
            scrollToFinalView()
            
        } else if topViewHeight <= topViewInitialHeight - 20 {
            
            switch scrollDirection {
                
            case .Down: scrollToInitialView()
            case .Up: scrollToFinalView()
            
            }
            
        } else {
            
            scrollToInitialView()
        }
    }
    
    func scrollToInitialView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewInitialHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewInitialHeight
        headerViewTopConstraint.constant = 0
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollToFinalView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewFinalHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewFinalHeight
        headerViewTopConstraint.constant = -(topViewFinalHeight)
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
}

extension HomeVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if offersScrollView == scrollView {
            pageControl.currentPage = Int((scrollView.contentOffset.x/scrollView.frame.width))
        }
    }
}
