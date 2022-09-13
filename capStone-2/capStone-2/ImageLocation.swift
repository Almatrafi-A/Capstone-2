//
//  ImageLocation.swift
//  capStone-2
//
//  Created by Hessa on 15/02/1444 AH.
//
import Foundation

 //MARK: - ImagesLatLong
struct ImagesLatLong: Codable {
    let photo: PhotoDetail
    let stat: String
}

// MARK: - Photo
struct PhotoDetail: Codable {
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
