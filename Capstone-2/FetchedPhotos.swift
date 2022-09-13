//
//  FetchedPhotos.swift
//  Capstone2
//
//  Created by Maan Abdullah on 09/09/2022.
//

import Foundation

// MARK: - ImagesFetched
struct ImagesFetched: Codable {
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

