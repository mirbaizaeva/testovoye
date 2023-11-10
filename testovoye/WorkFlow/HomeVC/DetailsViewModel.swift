//
//  DetailsViewModel.swift
//  testovoye
//
//  Created by Nurjamal Mirbaizaeva on 8/11/23.
//

import Foundation

class DetailsViewModel {
    
    func liked(_ id: String) -> String {
        var isLiked = UserdefaultStorage.shared.get(forKey: "\(id)") ?? false
        var imageName = ""
        
        imageName = isLiked ? "heart" : "heart.fill"
        isLiked ? UserdefaultStorage.shared.remove(forKey: id) : UserdefaultStorage.shared.save(!isLiked,forKey: id)
        
        isLiked.toggle()
        return imageName
    }
    
    func fetchEpisodes(url: String, complition: @escaping (Episodes) -> ()) {
        NetworkService.shared.requestEpisodes(url: url) { ep in
            complition(ep)
        }
    }
}
