//
//  CartTVCell.swift
//  FoodApp
//
//  Created by Muhammad Khan on 12/11/2020.
//

import UIKit
import RxCocoa
import RxSwift

class CartTVCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var deleteButtonTappedAction = PublishSubject<Void>()
    
    var disposeBag = DisposeBag()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
        imgView.image = nil
        titleLabel.text = ""
        priceLabel.text = ""
    }

    func populate(item: ModelFood){
        self.imgView.imageUrl = item.image
        self.titleLabel.text = item.title
        self.priceLabel.text = "\(item.price) usd"
    }
    
    @IBAction func buttonTapAction(_ sender: UIButton){
        deleteButtonTappedAction.onNext(())
    }
    
    
}
