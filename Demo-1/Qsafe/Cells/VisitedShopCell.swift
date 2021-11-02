//
//  VisitedShopCell.swift
//  Qsafe
//
//  Created by Abhiram on 09/02/21.
//

import UIKit

class VisitedShopCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopLocationLabel: UILabel!
    @IBOutlet weak var shopVisitedTimeLabel: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)

    }

    static func nib() -> UINib {

        return UINib(nibName: NibNames.visitedShopCell.rawValue, bundle: nil)

    }

    func setAttributes(shop: Shop) {

        shopNameLabel.text = shop.name
        shopLocationLabel.text = shop.location
        // convert shop time and add to label
        shopVisitedTimeLabel.text = "12:36 PM"

    }

}
