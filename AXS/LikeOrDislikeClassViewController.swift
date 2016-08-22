//
//  LikeOrDislikeClassViewController.swift
//  AXS
//
//  Created by Maria Flores on 12/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit

class LikeOrDislikeClassViewController: UIViewController {

    @IBOutlet weak var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblDislike: UILabel!
    
    var originalLocation : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblLike.hidden = true
        lblDislike.hidden = true

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
    
    
    @IBAction func swiped(sender: UIPanGestureRecognizer) {
        let origen = imgView.center
        
        if(sender.state == UIGestureRecognizerState.Began)
        {
            originalLocation = imgView.center
        }
        
        let translation : CGPoint = sender.translationInView(imgView)
        
        let txy : CGAffineTransform = CGAffineTransformMakeTranslation(translation.x, -abs(translation.x) / 15)
        let rot : CGAffineTransform = CGAffineTransformMakeRotation(-translation.x / 1500)
        let t : CGAffineTransform = CGAffineTransformConcat(rot, txy)
        imgView.transform = t
        
        if(translation.x > 100)
        {
            lblLike.hidden = false
            lblDislike.hidden = true
        }
        else
        {
            if(translation.x < 100)
            {
                lblDislike.hidden = false
                lblLike.hidden = true
            }
            else
            {
                lblLike.hidden = true
                lblDislike.hidden = true
            }
        }
        
        
        if sender.state == UIGestureRecognizerState.Ended
        {
            sender.view!.transform = CGAffineTransformMakeTranslation(origen.x, origen.y)
            imgView.center = originalLocation!
            imgView.transform = CGAffineTransformMakeRotation(0)
            sender.view!.transform = CGAffineTransformMakeRotation(0)
            lblLike.hidden = true
            lblDislike.hidden = true
        }
    }

}
