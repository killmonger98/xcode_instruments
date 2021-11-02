//
//  PhoneViewController.swift
//  Qsafe
//
//  Created by Qburst on 09/02/21.
//

import UIKit

class PhoneViewController: UIViewController {

    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var generateOtpBtn: UIButton!

    var phoneNumber: String?

    override func viewDidLoad() {

        super.viewDidLoad()
        setupHideKeyboardOnTap()
        keyboardHideAndShow()
        phoneTextFieldFunctions()
        btnStatus(generateOtpBtn, 0)
    }

    @objc func textFieldDidChange(textField: UITextField) {

        if let text = textField.text, text.isValidPhoneNumber() {
            btnStatus(generateOtpBtn, 1)
        } else {
            btnStatus(generateOtpBtn, 0)
        }

    }

    @objc func keyboardWillShow(notification: NSNotification) {

        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= generateOtpBtn.frame.origin.y - 100
            }
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {

        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }

    }

    @IBAction func generateOTPBtn(_ sender: UIButton) {

        if let number = phoneNumberTextField.text, number.isValidPhoneNumber() {
            phoneNumber = number
            performSegue(withIdentifier: SegueIdentifires.phoneToOTP.rawValue, sender: nil)
        } else {
            print("Invalid")
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == SegueIdentifires.phoneToOTP.rawValue {

            let destinationVC = segue.destination as? OTPVerificationViewController
            destinationVC?.userPhoneNumber = phoneNumber

        }

    }

    func keyboardHideAndShow() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    func phoneTextFieldFunctions() {
        phoneNumberTextField.keyboardType = UIKeyboardType.numberPad
        phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                                       for: UIControl.Event.editingChanged)
    }

}
