//
//  File.swift
//  CameraApp
//
//  Created by Will Wyatt on 1/25/16.
//  Copyright © 2016 Will Wyatt. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class FacebookManager {
    private var accessToken:String?
    
    func retrieveAccessToken() {
        let session = NSURLSession.sharedSession()
        
        let appID = "YOUR_APP_ID"
        let appSecret = "YOUR_APP_SECRET"
        
        let urlString = "https://graph.facebook.com/oauth/access_token?client_id=\(appID)&client_secret=\(appSecret)&grant_type=client_credentials"
        
        let url = NSURL(string: urlString)
        
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            if let d = data, tokenPhrase = NSString(data: d, encoding: NSUTF8StringEncoding) {
                let tokenArray = tokenPhrase.componentsSeparatedByString("=")
            
                    if tokenArray.count > 1 {
                        self.accessToken = tokenArray[1]
                    }
            }
        }
        task.resume()
    }
    
    func getPlaceId(lattitude lattitude:String, longitude:String, complete:(placeId:String?, error:NSError?)->Void) {
        guard let token = self.accessToken else {
            return
        }
        
        let request = FBSDKGraphRequest(graphPath: "/search", parameters: ["center": "\(lattitude),\(longitude)", "type": "place", "distance": "1000", "access_token": token, "fields": "id"], HTTPMethod: "GET")
        
        request.startWithCompletionHandler {
            (connection, result, error) -> Void in
            if error != nil {
                complete(placeId: nil, error: error)
            } else {
                if let locations = result as? [String: AnyObject], data = locations["data"] as? [[String: AnyObject]]
                    where
                    data.count > 0 {
                    if let placeId = data[0]["id"] as? String {
                        complete(placeId: placeId, error: nil)
                        return
                    }
                }
            complete(placeId: nil, error: nil)
            }
        }
    }
    
    
}