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
    var cicleImage: String
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
        self.cicleImage = circleImage
        self.status = status
        self.saved = saved
        self.swipeCard = swipeCard
        self.imageUrl = imageUrl
    }
}
