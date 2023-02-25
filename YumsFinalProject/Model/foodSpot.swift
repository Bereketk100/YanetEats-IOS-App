//
//  foodSpot.swift
//  YumsFinalProject
//
//  Created by Bereket Kibret on 11/29/22.
//

import Foundation

// Instagram API returns raw data. Data is then decoded into foodSpot objects
class foodSpot : Decodable {
    let caption: String?
    let media_url: String?
    let id: String?
    let permalink: String?
    
    public var favorite: Bool?
    
    public var distanceFromCurrent: Double?

    enum CodingKeys: String, CodingKey {
        case caption = "caption"
        case media_url = "media_url"
        case id = "id"
        case permalink = "permalink"
        case distanceFromCurrent = "distance"
    }
    // sets Distance for food spot 
    func setDistance(distance : Double){
        distanceFromCurrent = distance
    }
    
    // sets fav  food spot
    func setFav(fav : Bool){
        favorite = fav
    }

}
