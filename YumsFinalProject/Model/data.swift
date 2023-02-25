//
//  data.swift
//  YumsFinalProject
//
//  Created by Bereket Kibret on 12/1/22.
//

import Foundation

// TURN THIS INTO A CLASS AND ADD A READJSON, AND SAVE JSONFILE SO THAT WOULD MAKE MY API ONLY CALLED ONCE IN THE FUTURE
// Instagram API returns raw data. JSON is wrapped in a single data array.
struct data : Decodable  {
    var data: [foodSpot]
       // data = readJson()
    }
