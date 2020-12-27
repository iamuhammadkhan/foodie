//
//  FoodTVCell.swift
//  FoodApp
//
//  Created by Muhammad Khan on 09/11/2020.
//

import UIKit
import RxCocoa
import RxSwift

class FoodTVCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var item = PublishSubject<ModelFood>()
    var priceButtonTappedAction = PublishSubject<Void>()
    
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        priceButton.rx.tap
//            .asDriver()
//            .drive(self.priceButtonTappedAction)
//            .disposed(by: disposeBag)
        
//        self.item
//            .asObserver()
//            .observeOn(MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] item in
//                self?.imgView.imageUrl = item.image
//                self?.titleLabel.text = item.title
//                self?.descriptionLabel.text = item.description
//                self?.weightLabel.text = item.weight
//                self?.priceButton.setTitle(item.price , for: .normal)
//            })
//            .disposed(by: disposeBag)
        
    }
    
    func populate(item: ModelFood){
        self.imgView.imageUrl = item.image
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
        self.weightLabel.text = item.weight
        self.priceButton.setTitle("\(item.price) usd" , for: .normal)
        self.priceButton.setTitle("added +1" , for: .selected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
        imgView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
        weightLabel.text = ""
        priceButton.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapAction(_ sender: UIButton){
        priceButtonTappedAction.onNext(())
        
        UIView.animate(withDuration: 0.5) {
            sender.isSelected = true
            sender.backgroundColor = .themeGreen
        } completion: { (_) in
            UIView.animate(withDuration: 0.5) {
                sender.isSelected = false
                sender.backgroundColor = .themeBlack
            }
        }
    }
    
    
}
