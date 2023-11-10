//
//  ImageDownloader.swift
//  testovoye
//
//  Created by Nurjamal Mirbaizaeva on 8/11/23.
//

import Foundation

struct ImageDownloader {
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func donwload() -> Data? {
        guard let data = try? Data(
            contentsOf: URL(string: urlString)!
        ) else {
            return nil
        }
        
        return data
    }
}
