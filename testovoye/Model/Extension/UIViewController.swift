//
//  UIViewController.swift
//  testovoye
//
//  Created by Nurjamal Mirbaizaeva on 8/11/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(with title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .cancel))
        self.present(alert, animated: true)
    }
}
