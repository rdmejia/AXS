//
//  NewViewController.swift
//  AXS
//
//  Created by GFurniture on 27/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionViewController: UICollectionView!
    
    var items: [PromoItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newcell", forIndexPath: indexPath) as! NewCollectionViewCell
        
        let promo: PromoItem = items[indexPath.row]
        let urlImage: String = promo.circleImage
        Alamofire.request(.GET, urlImage).responseImage { (response) -> Void in
            if let image = response.result.value {
                cell.imgView.image = image
            }
            cell.lblBig.text = promo.title
            cell.lblTiny.text = promo.desc
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage"
        {
            let indexPaths = self.collectionViewController.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! BigImageViewController
            
            vc.urlImage = items[indexPath.row].imageUrl
        }
    }
}
