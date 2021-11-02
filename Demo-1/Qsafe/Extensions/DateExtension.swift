//
//  DateExtension.swift
//  Qsafe
//
//  Created by Abhiram on 10/02/21.
//

import Foundation

extension Date {

    func changeDaysBy(days: Int) -> Date {

        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: currentDate)!

    }

}
