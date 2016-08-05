//
//  Swipe3ClassViewController.swift
//  AXS
//
//  Created by Maria Flores on 1/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit

class Swipe3ClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDoneTapped(sender: UIButton) {
        //let scndView:InformationClassViewController = InformationClassViewController(nibName: nil, bundle: nil)
        
        //self.presentViewController(scndView, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("InformationViewController") //as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
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
