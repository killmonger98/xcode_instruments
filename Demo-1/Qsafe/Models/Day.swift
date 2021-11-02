//
//  Day.swift
//  Qsafe
//
//  Created by Abhiram on 10/02/21.
//

import Foundation

class Day {

    var date: Date
    var dayOfMonth: Int
    var dayOfWeek: String

    init(date: Date, dayOfMonth: Int, dayOfWeek: String) {

        self.date = date
        self.dayOfMonth = dayOfMonth
        self.dayOfWeek = dayOfWeek

    }

}
