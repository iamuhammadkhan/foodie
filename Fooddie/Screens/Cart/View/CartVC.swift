//
//  CartVC.swift
//  FoodApp
//
//  Created by Muhammad Khan on 12/11/2020.
//

import UIKit
import RxCocoa
import RxSwift

class CartVC: UIViewController {

    @IBOutlet weak var tabbar: CustomTabBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var presenter : CartPresenterInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabbar.data = ["Cart", "Order", "Information"]
        tableView.rx.setDataSource(self).disposed(by: disposeBag)
        
        presenter.outputs.foodItems
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                if val.isEmpty {
                    self?.dismiss(animated: true, completion: nil)
                    return
                }
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        presenter.outputs.totalPrice
            .asObservable()
            .subscribe(onNext: { [weak self] val in
                self?.priceLabel.text = val
            })
            .disposed(by: disposeBag)
        
        
        presenter.inputs.getItemsAction.onNext(())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .themeBlack

    }
   

}

extension CartVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.outputs.foodItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTVCell.identifier, for: indexPath) as! CartTVCell
        let item = presenter.outputs.foodItems.value[indexPath.row]
        cell.populate(item: item)
        cell.deleteButtonTappedAction.asObservable().subscribe(onNext: {
            self.presenter.inputs.removeItem.onNext(item)
        }).disposed(by: cell.disposeBag)
        return cell
    }
    
    
}
