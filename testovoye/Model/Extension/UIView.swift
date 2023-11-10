//
//  UIView.swift
//  testovoye
//
//  Created by Nurjamal Mirbaizaeva on 8/11/23.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
    
    func addEdgesConstraints(constant: CGFloat, superView: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant/2),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -constant),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -constant/2)
        ])
    }
}
