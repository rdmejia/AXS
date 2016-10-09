//
//  LikeOrDislikeClassViewController.swift
//  AXS
//
//  Created by Maria Flores on 12/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class LikeOrDislikeClassViewController: UIViewController {

    @IBOutlet weak var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblDislike: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var imgNope: UIImageView!
    
    var originalLocation : CGPoint?
    
    internal var json : NSDictionary!
    
    var likedItems: [PromoItem] = []
    
    var promociones: NSArray!
    var currentPromo: NSDictionary!
    var currentIndex = 0
    
    var didChoose = false
    var locked = true
    var selection = 0 //0: nothing, 1: right, 2: left
    
    let photoCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgView.layer.cornerRadius = 8
        imgView.layer.shadowOffset = CGSizeMake(7, 7)
        imgView.layer.shadowRadius = 5
        imgView.layer.shadowOpacity = 0.5
        
        lblLike.hidden = true
        lblDislike.hidden = true
        
        imgLike.hidden = true
        imgNope.hidden = true
        
        //promociones = json["promociones"] as! NSArray
        //updateImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print(self.json)
        promociones = self.json["promociones"] as! NSArray
        var i = 0
        for promo in promociones
        {
            let urlImage: String = promo["swipecard"] as! String
            Alamofire.request(.GET, urlImage).responseImage { (response) -> Void in
                if let image = response.result.value {
                    self.photoCache.addImage(image, withIdentifier: "img" + String(i))
                    if(i == 0)
                    {
                        self.currentIndex = 0
                        self.updateImage()
                    }
                    self.locked = false
                    i = i + 1
                }
            }
        }
        updateImage()
    }
    
    @IBAction func btnBackTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func swiped(sender: UIPanGestureRecognizer) {
        let origen = imgView.center
        if(!locked)
        {
            switch sender.state
            {
            case .Began:
                originalLocation = imgView.center
                break
            case .Changed:
                let translation : CGPoint = sender.translationInView(imgView)
                
                let txy : CGAffineTransform = CGAffineTransformMakeTranslation(translation.x, -abs(translation.x) / 15)
                let rot : CGAffineTransform = CGAffineTransformMakeRotation(-translation.x / 1500)
                let t : CGAffineTransform = CGAffineTransformConcat(rot, txy)
                imgView.transform = t
                
                if(translation.x > 100)
                {
                    swipedRight()
                    didChoose = true
                }
                else
                {
                    if(translation.x < -100)
                    {
                        swipedLeft()
                        didChoose = true
                    }
                    else
                    {
                        selection = 0
                        imgLike.hidden = true
                        imgNope.hidden = true
                        lblLike.hidden = true
                        lblDislike.hidden = true
                        didChoose = false
                    }
                }
                break
            case .Ended:
                sender.view!.transform = CGAffineTransformMakeTranslation(origen.x, origen.y)
                imgView.center = originalLocation!
                imgView.transform = CGAffineTransformMakeRotation(0)
                sender.view!.transform = CGAffineTransformMakeRotation(0)
                lblLike.hidden = true
                imgLike.hidden = true
                imgNope.hidden = true
                lblDislike.hidden = true
                if(didChoose)
                {
                    if(selection == 1)
                    {
                        
                        let promo: PromoItem = PromoItem.getPromoItem(promociones[currentIndex] as! NSDictionary)
                        likedItems.append(promo)
                        selection = 0
                    }
                    imgView.image = nil
                    locked = true
                    if(currentIndex == promociones.count - 1)
                    {
                        Operations.writeInternalFile(likedItems)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else
                    {
                        currentIndex = currentIndex + 1
                        updateImage()
                    }
                    
                }
                break
            default:
                break
            }
        }
    }
    
    func updateImage()
    {
        /*currentPromo = promociones[currentIndex] as! NSDictionary
        currentIndex = currentIndex + 1
        let urlImage: String = currentPromo["swipecard"] as! String
        Alamofire.request(.GET, urlImage).responseImage { (response) -> Void in
            if let image = response.result.value {
                self.imgView.image = image
                self.locked = false
            }
        }*/
        self.imgView.image = photoCache.imageWithIdentifier("img" + String(currentIndex))
        //currentIndex = currentIndex + 1
        locked = false
    }
    
    func swipedLeft()
    {
        lblDislike.hidden = false
        imgNope.hidden = false
        lblLike.hidden = true
        imgLike.hidden = true
        selection = 2
    }
    
    func swipedRight()
    {
        lblLike.hidden = false
        imgLike.hidden = false
        lblDislike.hidden = true
        imgNope.hidden = true
        selection = 1
    }

}
