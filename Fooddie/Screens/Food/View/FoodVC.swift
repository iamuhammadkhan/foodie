//
//  HomeVC.swift
//  FoodApp
//
//  Created by Muhammad Khan on 11/11/2020.
//

import UIKit
import RxSwift
import RxCocoa

class FoodVC : TabChildVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter : FoodPresenterInterface!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        populateViews()
        
    }
    
    func setupViews(){
        tableView.rx.setDataSource(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName: FoodTVCell.identifier, bundle: .main), forCellReuseIdentifier: FoodTVCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
    }
    
    func populateViews(){
        presenter.inputs.getItems.onNext(())
        presenter.outputs.items
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
}

extension FoodVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.outputs.items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.outputs.items.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodTVCell.identifier, for: indexPath) as! FoodTVCell
        cell.populate(item: item)
        cell.priceButtonTappedAction.asObservable().subscribe(onNext: {
            self.presenter.inputs.addItemToCartAction.onNext(item)
        }).disposed(by: cell.disposeBag)
        return cell
    }

}


//extension FoodVC : UITableViewDelegate {}
