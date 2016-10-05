//
//  InformationClassViewController.swift
//  AXS
//
//  Created by Maria Flores on 1/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import UIKit

class InformationClassViewController: UIViewController {

    @IBOutlet weak var btnMen: UIButton!
    @IBOutlet weak var btnWmn: UIButton!
    @IBOutlet weak var txtAge: UITextField!
    
    var genre = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.genre = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnMenTapped(sender: UIButton) {
        let men2 = UIImage(named: "hombre2")
        btnMen.setImage(men2, forState:.Normal)
        
        if(genre == 2)
        {
            let wmn2 = UIImage(named: "mujer1")
            btnWmn.setImage(wmn2, forState:.Normal)
        }
        
        genre = 1
    }
    
    
    @IBAction func btnWmnTapped(sender: UIButton) {
        let wmn2 = UIImage(named: "mujer2")
        btnWmn.setImage(wmn2, forState:.Normal)
        
        if(genre == 1)
        {
            let men2 = UIImage(named: "hombre1")
            btnMen.setImage(men2, forState:.Normal)
        }
        
        genre = 2
    }
    
    @IBAction func txtAgeDidChanged(sender: UITextField) {
        if(txtAge.text?.characters.count > 2)
        {
            txtAge.text = txtAge.text?.substringToIndex(txtAge.text!.startIndex.advancedBy(2))
        }
    }
    
    @IBAction func btnIngresarTapped(sender: UIButton) {
        if(genre == 0)
        {
            let alert = UIAlertController(title: "Verifique", message: "Por favor, seleccione su género", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if(txtAge.text == "")
        {
            let alert = UIAlertController(title: "Verifique", message: "Por favor, ingrese su edad", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            //defaults.setObject("BarCodeView", forKey: "LaunchView")
            defaults.setBool(true, forKey: "NotFirstTime")
            defaults.setBool(false, forKey: "SkippedInformation")
            let age:Int? = Int(txtAge.text!)
            defaults.setInteger((age)!, forKey: "Age")
            defaults.setInteger(genre, forKey: "Genre")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("BarCodeView") //as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSkipTapped(sender: UIButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        //defaults.setObject("BarCodeView", forKey: "LaunchView")
        defaults.setBool(true, forKey: "NotFirstTime")
        let alert = UIAlertController(title: "¿Estás seguro?", message: "Es importante que ingreses los datos solicitados", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            let defaults = NSUserDefaults.standardUserDefaults()
            //defaults.setObject("BarCodeView", forKey: "LaunchView")
            defaults.setBool(true, forKey: "SkippedInformation")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("BarCodeView") //as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
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
