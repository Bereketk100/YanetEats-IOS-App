//
//  InstagramAPIModel.swift
//  YumsFinalProject
//
//  Created by Bereket Kibret on 12/1/22.
//

import Foundation

// Model to call Instagram API and store data in a singleton variable
class InstagramAPIModel {
    // singleton that holds all the food spots
    static var shared = InstagramAPIModel()
    public var foodSpots: [foodSpot] = []

    
    // API call to retrieve data from @yaneteats
    // Instanly then is decoded into a data object which contains an array of foodSpot objects
    func instagramAPICall(){
        guard let url = URL(string: "https://graph.instagram.com/me/media?fields=caption,media_url,permalink&access_token=IGQVJVNEt0UXlvTE8wcS1HcjE1dmJMeHh4TVoyNU5tbmk3STdDMUNzSDRCZAXF5YkY2ZAFFZAWi12UndqTG9UUnU4eUUtVjhoUFhzWkx6a0NSbmNoaFJyaVRPcVBvWnRqc0FsODJfeDhLMUpxRElXM1VhcwZDZD")
        else { 
            return 
        }
        let task = URLSession.shared.dataTask(with: url){
            data1, response, error in
            
            let decoder = JSONDecoder()

            if let data1 = data1{
                do{
                    // decode JSON
                    let dataFoodSpots = try decoder.decode(data.self, from: data1)
                    // instantiate food spots
                    self.foodSpots = dataFoodSpots.data

                   
                }catch{
                    print(error)
                }
            }
        }
        task.resume()
        

    }

}

