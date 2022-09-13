//
//  PhotoLatLong.swift
//  Capstone2
//
//  Created by Maan Abdullah on 09/09/2022.
//

import Foundation

 //MARK: - ImagesLatLong
struct ImagesLatLong: Codable {
    let photo: Photo2
    let stat: String
}

// MARK: - Photo
struct Photo2: Codable {
    let id: String
    let location: Location
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude, accuracy, context: String
    let locality, neighbourhood, region, country: Country
}

// MARK: - Country
struct Country: Codable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
