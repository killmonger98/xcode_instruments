//
//  OTPVerificationViewController.swift
//  Qsafe
//
//  Created by Qburst on 09/02/21.
//

import UIKit

class OTPVerificationViewController: UIViewController {

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet var firstOtpTextField: UITextField!
    @IBOutlet var secondOtpTextField: UITextField!
    @IBOutlet var thirdOtpTextField: UITextField!
    @IBOutlet var fourthOtpTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var forgetOtpStack: UIStackView!
    @IBOutlet var countDownTimer: UILabel!

    let storyboardInstance = UIStoryboard(name: "QRCodeStoryboard", bundle: nil)

    var userExists = false
    var finalOtpString = ""
    var countDownTimerTime = countDownTimerTimeConst
    var timer: Timer?
    var userPhoneNumber: String?

    override func viewDidLoad() {

        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:
                                #selector(updateCounter), userInfo: nil, repeats: true)

        setupHideKeyboardOnTap()
        disableSubmitButton()
        createTextFieldResponders()
        keyBoardNotificationObservers()

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(true)
        phoneNumberLabel.text = userPhoneNumber
        forgetOtpStack.isHidden = true

    }

    func createTextFieldResponders() {

        firstOtpTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                                    for: UIControl.Event.editingChanged)
        secondOtpTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                                     for: UIControl.Event.editingChanged)
        thirdOtpTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                                    for: UIControl.Event.editingChanged)
        fourthOtpTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                                     for: UIControl.Event.editingChanged)
    }

    func keyBoardNotificationObservers() {

        NotificationCenter.default.addObserver(self,
               selector: #selector(keyboardNotification(notification:)), name:
                UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:
                UIResponder.keyboardWillHideNotification, object: nil)

    }

    // Submit Button Tapped
    @IBAction func submitButtonTapped() {

        if userExists {
            // go directly to qr code screen

//            let window = self.getWindow()
//            window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.qRCodeNavigationController.rawValue)

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
                return
            }
            sceneDelegate.changeRootViewController(viewControllerIdentifier:
                                                    ViewControllerIDs.qRCodeNavigationController.rawValue)
        } else {
            // go to register screen
            performSegue(withIdentifier: SegueIdentifires.oTPToReg.rawValue, sender: nil)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == SegueIdentifires.oTPToReg.rawValue {
            let destinationVC = segue.destination as? RegistrationViewController
            destinationVC?.userPhoneNumber = userPhoneNumber
        }

    }

    @objc func textFieldDidChange(textField: UITextField) {

        if let text = textField.text {
            if text.count > 1 {
                textField.text = ""
            } else {

                switch textField {
                case firstOtpTextField:
                    if text.count == 1 {
                        enableSubmitButton()
                        secondOtpTextField.becomeFirstResponder()
                    } else {
                        disableSubmitButton()
                        firstOtpTextField.becomeFirstResponder()
                    }
                case secondOtpTextField:
                    if text.count == 1 {
                        enableSubmitButton()
                        thirdOtpTextField.becomeFirstResponder()
                    } else {
                        disableSubmitButton()
                        firstOtpTextField.becomeFirstResponder()
                    }
                case thirdOtpTextField:
                    if text.count == 1 {
                        enableSubmitButton()
                        fourthOtpTextField.becomeFirstResponder()
                    } else {
                        disableSubmitButton()
                        secondOtpTextField.becomeFirstResponder()
                    }
                case fourthOtpTextField:
                    if text.count == 1 {
                        enableSubmitButton()
                        fourthOtpTextField.resignFirstResponder()
                    } else {
                        disableSubmitButton()
                        thirdOtpTextField.becomeFirstResponder()
                    }
                default:
                    break
                }
            }
        }

    }

    // MARK: Disable submit button

    func disableSubmitButton() {

        submitButton.isEnabled = false
        submitButton.backgroundColor = buttonDisabledColor

    }

    // MARK: Enable submit button

    func enableSubmitButton() {

        guard let firstTextFieldText = firstOtpTextField.text, let secondTextFieldText = secondOtpTextField.text,
              let thirdTextFieldText = thirdOtpTextField.text, let fourthTextFieldText = fourthOtpTextField.text
        else { return }

        finalOtpString = firstTextFieldText + secondTextFieldText +
            thirdTextFieldText + fourthTextFieldText
        if firstTextFieldText != "" && secondTextFieldText != "" &&
            thirdTextFieldText != "" && fourthTextFieldText != "" {
            submitButton.isEnabled = true
            submitButton.backgroundColor = primaryColor
        }
    }

    // MARK: Keyboard Notifications

    @objc func keyboardNotification(notification: NSNotification) {

        var keyBoardHeight: CGFloat?
        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyBoardHeight = keyboardRectangle.height
        }
        if let keyBoardheight = keyBoardHeight {
            view.frame.origin.y = 0 - keyBoardheight
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {

      view.frame.origin.y = 0
    }

    @objc func updateCounter() {

        if countDownTimerTime > 0 {
            countDownTimer.text = String(format: "00 : %02d", countDownTimerTime)
            countDownTimerTime -= 1
        } else if countDownTimerTime == 0 {
            countDownTimer.text = "01 : 00 "
            countDownTimerTime = 59
            timer?.invalidate()
            forgetOtpStack.isHidden = false
            countDownTimer.isHidden = true
        }

    }

    @IBAction func forgetOtpTapped() {

        forgetOtpStack.isHidden = true
        countDownTimer.isHidden = false
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:
                                #selector(updateCounter), userInfo: nil, repeats: true)

    }
}
