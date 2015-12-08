//
//  MainViewController.swift
//  CameraApp
//
//  Created by Will Wyatt on 12/2/15.
//  Copyright © 2015 Will Wyatt. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var displayImageView: UIImageView!
    
//    Vars
    private var currentZoom:CGFloat = 1.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: "zoomImage:")
        
        gesture.numberOfTapsRequired = 2
        
        self.scrollView.addGestureRecognizer(gesture)
        self.scrollView.delegate = self
    }

    func zoomImage(sender: UIGestureRecognizer) {
        if self.currentZoom == 1.0 {
            self.currentZoom = 2.0
        } else {
            self.currentZoom = 1.0
        }
        UIView.animateWithDuration(0.5) { [unowned self] in
            self.scrollView.minimumZoomScale = self.currentZoom
            self.scrollView.maximumZoomScale = self.currentZoom
            self.scrollView.zoomScale = self.currentZoom
        }
    }
}

// *** Button Actions *** //
extension MainViewController {
    
    @IBAction func cameraButtonTouched(sender: AnyObject) {
        displayImagePicker(.Camera)
    }
    
    @IBAction func libraryButtonTouched(sender: AnyObject) {
        displayImagePicker(.PhotoLibrary)
    }
    
    @IBAction func actionButtonTouched(sender: AnyObject) {
        if let image = self.displayImageView.image {
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityTypeMail]
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
}



// ***  Image Picker Delegate  *** //
extension MainViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
}


// *** Scroll View Delegate *** //
extension MainViewController : UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.displayImageView
    }
}
