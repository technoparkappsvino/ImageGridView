//
//  ImageModel.swift
//  ImageGrid
//
//  Created by Vinoth Kumar GIRI on 15/04/24.
//

import Foundation

struct ImageModel:Codable {
    let id: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
         case id
         case url
      }
}

struct ImageData: Codable {
    let id: String
    let title: String
    let language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt: String
    let publishedBy: String
    let backupDetails: BackupDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case language
        case thumbnail
        case mediaType
        case coverageURL
        case publishedAt
        case publishedBy
        case backupDetails
      }
}

struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case version
        case domain
        case basePath
        case key
        case qualities
        case aspectRatio
      }
}

struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
    
    enum CodingKeys: String, CodingKey {
         case pdfLink
         case screenshotURL
      }
}
