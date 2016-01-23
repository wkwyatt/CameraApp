# Camera App
Apply filters to images on your phone or taken with your camera and share them on Facebook.

## Screenshots

![](https://cloud.githubusercontent.com/assets/13364964/12527823/227b3448-c151-11e5-99e2-0ef048b43570.png)

## Features
* Filter images selected from device memory or taken with the camera
* Share image with filter on Facebook

## How to build
Clone App
```linux
$ git clone https://github.com/wkwyatt/CameraApp.git
$ cd CameraApp
```
Install Pods
```linux
$ pod install
```
Open Workspace
```linux
$ open "CameraApp.xcworkspace"
```

## Code
Filter images using enums created to interact with CIImage
```swift
func createFiltersForImage(image:UIImage, filePrefix:String, complete:(filters:[(filterName:String, path:String)]) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [weak self]() -> Void in
            var filters = [(filterName:String, path:String)]()
            
            for filter in ImageFilter.allValues {
                if filter == .Original {
                    if let path = self?.filePathForImageFilter(filter, prefix: filePrefix) {
                        // cache the image and save the file path
                    }
                }
                if let i = self?.basicEffect(effectName: filter.rawValue, image: image) {
                    if let path = self?.filePathForImageFilter(filter, prefix: filePrefix) {
                        // cache the image and save the file path
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                complete(filters: filters)
            }
        }
    }
```

Setup Facebook SDK
* Follow instructions at [https://developers.facebook.com/docs/ios/getting-started](https://developers.facebook.com/docs/ios/getting-started)

