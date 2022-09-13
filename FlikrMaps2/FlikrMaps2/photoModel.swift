//
//  photoModel.swift
//  FlikrMaps2
//
//  Created by Rashed Shrahili on 15/02/1444 AH.
//

import UIKit

//MARK: - Json Model

// MARK: - Welcome
struct Welcome: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

//MARK: - Images
struct Image {
    
    let id: String
    let server:String
    let secret: String
    let location: String
}
