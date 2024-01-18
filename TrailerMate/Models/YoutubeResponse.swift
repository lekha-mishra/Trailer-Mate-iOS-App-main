//
//  YoutubeResponse.swift
//  TrailerMate
//
//  Created by IPH Technologies Pvt. Ltd.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
