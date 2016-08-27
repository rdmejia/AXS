//
//  Operations.swift
//  AXS
//
//  Created by GFurniture on 24/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit
import SystemConfiguration

class Operations: NSObject {
    static var json: NSDictionary!
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    class func writeInternalFile(data: [PromoItem])
    {
        let filename = getDocumentsDirectory().stringByAppendingString("/output.json")
        let fileManager = NSFileManager.defaultManager()
        
        var text = ""
        
        if fileManager.fileExistsAtPath(filename) {
            print("FILE AVAILABLE")
            
            do
            {
                text = try String(contentsOfFile: filename, encoding: NSUTF8StringEncoding)
                text = text.substringToIndex(text.endIndex.predecessor().predecessor())
                text += ","
            }
            catch(let e){}
            
        } else {
            print("FILE NOT AVAILABLE")
            
            text = "{\"promociones\":["
            
        }
        
        for promo in data {
            text = text + "{\"id\": \"" + String(promo.id)
            text += "\",\"comercial\": \""
            text += String(promo.comercial)
            text += "\",\"title\": \""
            text += promo.title
            text += "\", \"desc\": \"" + promo.desc
            text += "\", \"circleimage\": \""
            text += promo.circleImage + "\",\"status\": \""
            text += promo.status + "\",\"saved\": \"" + promo.saved
            text += "\",\"swipecard\": \"" + promo.swipeCard + "\",\"imageurl\": \"" + promo.imageUrl + "\""
            
            text += "},"
        }
        
        text = text.substringToIndex(text.endIndex.predecessor())
        
        text += "]}"
        
        do
        {
            try text.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch(let e) {}
    }
    
    class func getDocumentsDirectory() -> NSString
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
