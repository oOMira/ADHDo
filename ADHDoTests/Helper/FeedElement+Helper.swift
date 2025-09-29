//
//  FeedElement+Helper.swift
//  ADHDo
//
//  Created by Mira Kim Risse on 28.11.25.
//

@testable import ADHDo

extension FeedElement {
    var isAdvert: Bool {
        guard case .advert = self else { return false }
        return true
    }
    
    var isContent: Bool {
        guard case .content = self else { return false }
        return true
    }
    
    var isInvisible: Bool {
        guard case .invisibleContent = self else { return false }
        return true
    }
}
