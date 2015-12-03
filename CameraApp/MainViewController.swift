//
//  MainViewController.swift
//  CameraApp
//
//  Created by Will Wyatt on 12/2/15.
//  Copyright © 2015 Will Wyatt. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var displayImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cameraButtonTouched(sender: AnyObject) {
        displayImagePicker(.Camera)
    }
    
    @IBAction func libraryButtonTouched(sender: AnyObject) {
        displayImagePicker(.PhotoLibrary)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.displayImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayImagePicker(sType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sType
        
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
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
