//
//  BigImageViewController.swift
//  AXS
//
//  Created by GFurniture on 27/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BigImageViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var urlImage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(.GET, urlImage).responseImage { (response) -> Void in
            if let image = response.result.value {
                self.imgView.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
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

}
