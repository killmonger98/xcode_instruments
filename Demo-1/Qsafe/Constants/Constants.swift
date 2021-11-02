//
//  Constants.swift
//  Qsafe
//
//  Created by Abhiram on 10/02/21.
//
import UIKit
import Foundation

enum NibNames: String {

    case calendarDayCell = "CalendarDayCell"
    case visitedShopCell = "VisitedShopCell"

}

enum ViewControllerIDs: String {

    case qRCodeNavigationController = "QRCodeNavigation"

}

enum SegueIdentifires: String {

    case phoneToOTP = "phoneToOTP"
    case oTPToReg = "OTPToReg"

}

// colours
let primaryColor = UIColor(red: 0.960, green: 0.517, blue: 0.184, alpha: 1.0)
let buttonDisabledColor = UIColor(red: 0.996, green: 0.792, blue: 0.501, alpha: 1.0)

// numbers
let countDownTimerTimeConst = 59

let numberOfDaysInCalendar = 28
