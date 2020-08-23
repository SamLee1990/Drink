//
//  OrderTableViewCell.swift
//  Drink
//
//  Created by 李世文 on 2020/8/22.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var addBubbleLable: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(order: Order) {
        
        drinkNameLabel.text = order.drinkName
        sizeLabel.text = " " + order.size
        sugarLabel.text = order.sugar
        iceLabel.text = order.ice
        
        if order.bubble == "TRUE"{
            addBubbleLable.text = "加珍珠"
        }else{
            addBubbleLable.text = " "
        }
    }

}
