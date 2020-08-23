//
//  MenuTableViewCell.swift
//  Drink
//
//  Created by 李世文 on 2020/8/18.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var priceMiddleLabel: UILabel!
    @IBOutlet weak var priceLargeLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with menu: Menu) {
        nameLabel.text = menu.name
        introductionLabel.text = menu.introduction
        priceMiddleLabel.text = menu.priceMiddle.description
        if menu.priceLarge == 0{
            largeLabel.text = ""
            priceLargeLabel.text = ""
        }else{
            largeLabel.text = "大："
            priceLargeLabel.text = menu.priceLarge.description
        }
    }

}
