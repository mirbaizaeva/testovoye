//
//  Delegate.swift
//  testovoye
//
//  Created by Nurjamal Mirbaizaeva on 8/11/23.
//

import Foundation

protocol Delegate: AnyObject {
    func didReceive(_ id: Int)
    func remove(_ id: Int)
}
