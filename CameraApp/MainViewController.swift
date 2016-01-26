//
//  MainViewController.swift
//  CameraApp
//
//  Created by Will Wyatt on 12/2/15.
//  Copyright © 2015 Will Wyatt. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class MainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var previewCollectionView: UICollectionView!
    
//    Vars
    private var currentZoom:CGFloat = 1.0
    private var imageStore:[UIImage]!
    private let locationManager:LocationManager = LocationManager()
    private let fbManager = FacebookManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton:FBSDKLoginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: "zoomImage:")
        
        gesture.numberOfTapsRequired = 2
        
        self.scrollView.addGestureRecognizer(gesture)
        self.scrollView.delegate = self
        
        self.imageStore = [UIImage]()
        
        if self.imageStore.isEmpty {
            self.previewCollectionView.alpha = 0.0
        }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FilterSegue" {
            if let vc:FilterViewController = segue.destinationViewController as? FilterViewController {
                vc.sourceImage = self.displayImageView.image
            }
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
//            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//            activityVC.excludedActivityTypes = [UIActivityTypeMail]
//            self.presentViewController(activityVC, animated: true, completion: nil)
            
            // FACEBOOK CODE TO SHARE IMAGE
            
            let sharePhoto = FBSDKSharePhoto(image: image, userGenerated: true)
            
            let content = FBSDKSharePhotoContent()
            content.photos = [sharePhoto]
            
            if let currentLocation = self.locationManager.getCurrentLoction() {
                self.fbManager.getPlaceId(lattitude: currentLocation.lat, longitude: currentLocation.long, complete: { [weak self](placeId, error) -> Void in
                        if placeId != nil {
                            content.placeID = placeId
                        } else if error != nil {
                            print("Failed to retreive a placeID:\(error)")
                        }
                    
                    FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
                    })
            } else {
                    FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
            }
            
        }
        
    }
    @IBAction func didSelectFilter(segue: UIStoryboardSegue) {
        if segue.identifier == "FilterSelectedSegue" {
            if let source = segue.sourceViewController as? FilterViewController, let image = source.filteredImage {
                self.displayImageView.image = image
            }
        }
    }
}



// ***  Image Picker Delegate  *** //
extension MainViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.displayImageView.image = image
        
        self.imageStore.insert(image, atIndex: 0)
        self.previewCollectionView.alpha = 1.0
        self.previewCollectionView.reloadData()
        
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

// Collection View Data Source
extension MainViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let image = imageStore[indexPath.item]
        if let item = collectionView.dequeueReusableCellWithReuseIdentifier("PreviewCellReuseID", forIndexPath: indexPath) as? PreviewCollectionViewCell {
            item.previewImageView.image = image
            return item
        }
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageStore.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let image = self.imageStore[indexPath.item]
        self.displayImageView.image = image
    }
}

// FACEBOOK Sharing Delegate 
extension MainViewController : FBSDKSharingDelegate {
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
    }
}
