//
//  BarCodeViewController.swift
//  AXS
//
//  Created by Maria Flores on 4/08/16.
//  Copyright © 2016 KoffeeTime. All rights reserved.
//

import AVFoundation
import Alamofire
import UIKit


class BarCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView?
    
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var btnHeart: UIButton!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var btnAXS: UIButton!
    
    var json : NSDictionary!
    var items: [PromoItem] = []
    var promociones: NSArray!
    var comerciales: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://www.axs.gt/promociones/comerciales.txt").responseJSON{ (response) -> Void in // 1
            if let JSON = response.result.value {
                self.comerciales = JSON["content"] as! NSMutableArray
            }
        }
        
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
        
        view.bringSubviewToFront(btnAXS)
        view.bringSubviewToFront(btnHelp)
        view.bringSubviewToFront(btnHeart)
        view.bringSubviewToFront(btnFlash)
        
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.orangeColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
        
        self.navigationController?.navigationBar.hidden = true
        
        //self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
        
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueJson") {
            let svc = segue.destinationViewController as! LikeOrDislikeClassViewController
            
            svc.json = self.json
            
        }
        else if segue.identifier == "passMalls"
        {
            let aux: NSMutableArray = NSMutableArray()
            
            for comercial in comerciales {
                if(hasSale(comercial as! NSDictionary))
                {
                    aux.addObject(comercial)
                }
            }
            
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.topViewController as! ComercialesViewController
            
            //let vc = segue.destinationViewController as! ComercialesViewController
            
            vc.items = self.items
            vc.promociones = self.promociones
            vc.comerciales = aux
        }
    }
    
    func hasSale(comercial: NSDictionary) -> Bool
    {
        let id = Int(comercial["id"] as! String)
        for item in items {
            if(id == item.comercial)
            {
                return true
            }
        }
        
        return false
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            qrCodeFrameView?.frame = readableObject.bounds
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        print(code)
            
        captureSession.stopRunning()
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        if(code.hasPrefix("http://www.axs.gt/"))
        {
            if(Operations.isConnectedToNetwork())
            {
                downloadAXS(code)
            }
            else
            {
                makeToast("No estás conectado a Internet")
            }
        }
        else
        {
            makeToast("No es un AXS code")
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    @IBAction func btnFlashTapped(sender: UIButton) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    device.torchMode = AVCaptureTorchMode.Off
                } else {
                    do {
                        try device.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print(error)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func btnHelpTapped(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PageViewController") //as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTapped(sender: UIButton) {
        if(Operations.isConnectedToNetwork())
        {
            downloadAXS("http://www.axs.gt/promociones/package0001.txt")
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("LikeOrDislikeViewController") as! LikeOrDislikeClassViewController
            //vc.json = self.json
            self.navigationController?.pushViewController(vc, animated: true)
            //self.presentViewController(vc, animated: true, completion: nil)
            //self.shouldPerformSegueWithIdentifier("LikeOrDislikeViewController", sender: self)
        }
        else
        {
            makeToast("No estás conectado a Internet")
        }
    }
    
    @IBAction func btnHeartTapped(sender: UIButton) {
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ComercialesView") //as! MyCollectionViewController
        self.presentViewController(vc, animated: true, completion: nil)*/
        
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
                    items.removeAll()
                    for item in promociones {
                        let d = item as! NSDictionary
                        let p = PromoItem.getPromoItem(d)
                        items.append(p)
                    }
                    
                    self.performSegueWithIdentifier("passMalls", sender: self)
                }
                catch(let e){}
            }
            catch(let e) {}
        }
    }
    
    func makeToast(message: String)
    {
        let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height-100, 300, 35))
        toastLabel.backgroundColor = UIColor.blackColor()
        toastLabel.textColor = UIColor.whiteColor()
        toastLabel.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animateWithDuration(4.0, delay: 0.1, options: .CurveEaseOut, animations: {
            
            toastLabel.alpha = 0.0
            
            }, completion: nil)
    }
    
    func downloadAXS(code: String)
    {
        Alamofire.request(.GET, code).responseJSON{ (response) -> Void in // 1
            if let JSON = response.result.value {
                Operations.json = JSON as! NSDictionary
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("LikeOrDislikeViewController") as! LikeOrDislikeClassViewController
                vc.json = JSON as! NSDictionary
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }

    }
}
