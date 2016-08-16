//
//  LikeOrDislikeClassViewController.swift
//  AXS
//
//  Created by Maria Flores on 12/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit

class LikeOrDislikeClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackTapped(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("BarCodeView") //as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        //navigationController?.popViewControllerAnimated(true)
        //navigationController?.popToRootViewControllerAnimated(true)
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
