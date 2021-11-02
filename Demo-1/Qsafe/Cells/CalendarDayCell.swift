//
//  CalendarDayCell.swift
//  Qsafe
//
//  Created by Abhiram on 09/02/21.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override var isSelected: Bool {
        didSet {

            self.cellContentView.backgroundColor = isSelected ? #colorLiteral(red: 0.9520422816, green: 0.6224794984, blue: 0.2874153852, alpha: 1): #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.dayOfWeekLabel.textColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.dateLabel.textColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
      }

    func setAttributes(_ day: Day) {

        dayOfWeekLabel.text = day.dayOfWeek
        dateLabel.text = String(day.dayOfMonth)

    }

}
