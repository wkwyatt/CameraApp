//
//  ImageFilterManager.swift
//  CameraApp
//
//  Created by Will Wyatt on 1/18/16.
//  Copyright © 2016 Will Wyatt. All rights reserved.
//

import Foundation
import UIKit

enum ImageFilter:String {
    case Sepia = "CISepiaTone"
    case ColorInvert = "CIColorInvert"
    case PhotoNoir = "CIPhotoEffectNoir"
    case PhotoProcess = "CIPhotoEffectProcess"
    case ColorPosterize = "CIColorPosterize"
    case FalseColor = "CiFalseColor"
    case Edges = "CIEdges"
    case Original = "Original"
    
    static let allValues = [Original, Sepia, ColorInvert, PhotoNoir, PhotoProcess, ColorPosterize, FalseColor]
}

class ImageFilterManager {
    
    
    
    typealias CI_Image = CIImage
    
    func filePathForImageFilter(filter:ImageFilter, prefix:String) -> String {
        let pathUrls = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let pathUrl = pathUrls[0]
        let path = (pathUrl as NSString).stringByAppendingPathComponent("\(prefix)-\(filter.rawValue).jpg")
        return path
    }
    
    func cacheFilteredImage(image:UIImage, filePath path:String) {
        if let imageData: NSData = UIImageJPEGRepresentation(image, 0.50) {
            do {
                try imageData.writeToFile(path, options: .AtomicWrite)
            } catch {
                print("Failed to write \(path) to disk:\(error)")
            }
        }
    }
    
    func createFiltersForImage(image:UIImage, filePrefix:String, complete:(filters:[(filterName:String, path:String)]) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [weak self]() -> Void in
            var filters = [(filterName:String, path:String)]()
            
            for filter in ImageFilter.allValues {
                if filter == .Original {
                    if let path = self?.filePathForImageFilter(filter, prefix: filePrefix) {
                        self?.cacheFilteredImage(image, filePath: path)
                        filters.append((filterName: "\(filter)", path:path))
                        continue
                    }
                }
                if let i = self?.basicEffect(effectName: filter.rawValue, image: image) {
                    if let path = self?.filePathForImageFilter(filter, prefix: filePrefix) {
                        self?.cacheFilteredImage(i, filePath: path)
                        filters.append((filterName: "\(filter)", path:path))
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                complete(filters: filters)
            }
        }
    }
    
    func basicEffect(effectName effectName:String, image:UIImage) -> UIImage? {
        
        guard let inputImage = CI_Image(image: image),
            let filter = CIFilter(name: effectName) else {
                
                return nil
        }
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else {
            
            return nil
        }
        
        let imageRef : CGImageRef = CIContext().createCGImage(outputImage, fromRect: outputImage.extent)
        
        let image:UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
}
