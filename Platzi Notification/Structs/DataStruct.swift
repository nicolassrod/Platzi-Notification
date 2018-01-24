//
//  JsonResiveStruct.swift
//  Platzi Notification
//
//  Created by Nicolás Rodríguez on 2/01/18.
//  Copyright © 2018 Nicolás Rodríguez. All rights reserved.
//
//   let dataAgenda = DataAgenda(json)!

import Foundation

typealias DataAgenda = [DataAgendum]

struct DataAgendum: Codable {
    let id: Int
    let course: Int
    let startTime: String
    let endTime: String
    let agendaItemType: String
    let liveSlug: String
    let details: Details
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case course = "course"
        case startTime = "start_time"
        case endTime = "end_time"
        case agendaItemType = "agenda_item_type"
        case liveSlug = "live_slug"
        case details = "details"
    }
}

struct Details: Codable {
    let id: Int
    let title: String
    let slug: String
    let free: Bool
    let order: Int
    let description: String
    let image: String
    let color: String
    let badge: String
    let coverURL: String
    let coverVerticalURL: String
    let socialImageURL: String
    let socialDescription: String
    let lang: String
    let video: String
    let url: String
    let liveURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case slug = "slug"
        case free = "free"
        case order = "order"
        case description = "description"
        case image = "image"
        case color = "color"
        case badge = "badge"
        case coverURL = "cover_url"
        case coverVerticalURL = "cover_vertical_url"
        case socialImageURL = "social_image_url"
        case socialDescription = "social_description"
        case lang = "lang"
        case video = "video"
        case url = "url"
        case liveURL = "live_url"
    }

}
