//
//  ComercialesViewController.swift
//  AXS
//
//  Created by GFurniture on 27/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ComercialesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    
    var items: [PromoItem] = []
    var promociones: NSArray!
    var comerciales: NSArray!
    
    var locked = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filename = Operations.getDocumentsDirectory().stringByAppendingString("/output.json")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filename)
        {
            do
            {
                let jsonData = try NSData(contentsOfFile: filename, options: .DataReadingMappedIfSafe)
                do
                {
                    let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    promociones = jsonResult["promociones"] as! NSArray
                    for item in promociones {
                        let d = item as! NSDictionary
                        let p = PromoItem.getPromoItem(d)
                        items.append(p)
                        items.removeLast()
                    }
                    print(promociones)
                }
                catch(let e){}
            }
            catch(let e) {}
        }
    }

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comerciales.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        //cell.imgView.image = Images[indexPath.row]
        let d = comerciales[indexPath.row] as! NSDictionary
        
        let urlImage = d["imageurl"] as! String
        
        Alamofire.request(.GET, urlImage).responseImage { (response) -> Void in
            if let image = response.result.value {
                cell.imgView!.image = image
            }
        }
        cell.layer.cornerRadius = 5
        cell.layer.shadowOffset = CGSizeMake(7, 7)
        cell.layer.shadowRadius = 8
        cell.layer.shadowOpacity = 0.25
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showPromos", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPromos"
        {
            let indexPaths = self.collectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! NewViewController
            
            //let vc = segue.destinationViewController as! NewViewController
            
            var aux = [PromoItem]()
            let comercial = comerciales[indexPath.row]
            let id = Int(comercial["id"] as! String)
            
            for item in items {
                if(item.comercial == id)
                {
                    aux.append(item)
                }
            }
            
            vc.items = aux
            
            //vc.image = Images[indexPath.row]!
            
        }
        
    }
}
