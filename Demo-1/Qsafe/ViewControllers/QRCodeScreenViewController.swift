//
//  QRCodeScreenViewController.swift
//  Qsafe
//
//  Created by Abhiram on 09/02/21.
//

import UIKit

class QRCodeScreenViewController: UIViewController {

    enum QRCodeKeys: String {

        case cIQRCodeGenerator = "CIQRCodeGenerator"
        case inputMessage = "inputMessage"

    }

    @IBOutlet weak var qRCodeImageView: UIImageView!

    override func viewDidLoad() {

        super.viewDidLoad()
        let testInput = "Abhiram"
        let image = generateQRCode(from: testInput)
        qRCodeImageView.image = image

    }

    func generateQRCode(from string: String) -> UIImage? {

        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: QRCodeKeys.cIQRCodeGenerator.rawValue) {
            filter.setValue(data, forKey: QRCodeKeys.inputMessage.rawValue)
            let transform = CGAffineTransform(scaleX: 50, y: 50)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil

    }

}
