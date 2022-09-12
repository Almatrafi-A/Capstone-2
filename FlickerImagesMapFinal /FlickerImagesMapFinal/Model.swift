//
//  Model.swift
//  FlickerImagesMapFinal
//
//  Created by Raneem Alkahtani on 11/09/2022.
//

import Foundation
struct Flickr : Codable {
    let photos : Photos
}

struct Photos : Codable {
    let photo : [Photo]
}

struct Photo : Codable {
    let id: String?
    let secret: String?
    let server : String?
}
