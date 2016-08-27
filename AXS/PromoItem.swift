//
//  PromoItem.swift
//  AXS
//
//  Created by GFurniture on 27/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit

class PromoItem: NSObject {
    var id: Int
    var comercial: Int
    var title: String
    var desc: String
    var circleImage: String
    var status: String
    var saved: String
    var swipeCard: String
    var imageUrl: String
    
    init(id: Int, comercial: Int, title: String, desc: String, circleImage: String, status: String, saved: String, swipeCard: String, imageUrl: String)
    {
        self.id = id
        self.comercial = comercial
        self.title = title
        self.desc = desc
        self.circleImage = circleImage
        self.status = status
        self.saved = saved
        self.swipeCard = swipeCard
        self.imageUrl = imageUrl
    }
    
    class func getPromoItem(dictionary: NSDictionary!) -> PromoItem
    {
        let promo: PromoItem = PromoItem(id: 0, comercial: 0, title: "", desc: "", circleImage: "", status: "", saved: "", swipeCard: "", imageUrl: "")
        
        promo.id = Int(dictionary["id"] as! String)!
        promo.comercial = Int(dictionary["comercial"] as! String)!
        promo.title = dictionary["title"] as! String
        promo.desc = dictionary["desc"] as! String
        promo.circleImage = dictionary["circleimage"] as! String
        promo.status = dictionary["status"] as! String
        promo.saved = dictionary["saved"] as! String
        promo.swipeCard = dictionary["swipecard"] as! String
        promo.imageUrl = dictionary["imageurl"] as! String

        return promo
    }
}
