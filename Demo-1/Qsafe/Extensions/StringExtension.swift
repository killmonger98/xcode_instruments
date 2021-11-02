//
//  StringExtension.swift
//  Qsafe
//
//  Created by Qburst on 11/02/21.
//

import Foundation

extension String {

    func isValidPhoneNumber() -> Bool {

        let regEx = "^[0-9]{10}$"
        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)

    }

    func isValidName() -> Bool {

       let regEx = "^[A-Za-z ]{3,18}+"
       let test = NSPredicate(format: "SELF MATCHES %@", regEx)
       return test.evaluate(with: self)

    }

    func isValidEmail () -> Bool {

        let regEx = "^[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: self)

    }

    func isValidAddress () -> Bool {

        let regEx = "^[a-zA-Z0-9 .,()/-]{3,}+$"
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: self)

    }

}
