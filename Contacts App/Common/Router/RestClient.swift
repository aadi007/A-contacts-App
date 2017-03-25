//
//  RestClient.swift
//
//  Created by Aadesh Maheshwari on 25/03/17.
//  Copyright © 2017 Aadesh Maheshwari. All rights reserved.
//

import Foundation
import Alamofire

class RestClient {

    static var currentRequest : Request?

    class func getAPIResponse(_ router : URLRequestConvertible, successCompletionHandler : (_ res : Alamofire.Response<AnyObject, NSError>) -> Void, errorCompletionHandler : @escaping () -> Void ) {
        
        currentRequest = Alamofire.request(router)
            .debugLog()
            .validate()
            .responseJSON {
                (response) in
                if response.result.isFailure {
                    handleError(response,
                        successHandler:{
                            res in
                            successCompletionHandler(res: res)
                        },
                        errorhandler:{
                            errorCompletionHandler()
                        })
                } else {
                    successCompletionHandler(res: response)
                }
            }
    }
    
//    class func uplodImage(_ imageDataModel: UploadImageModel, apiEndpoint: String, postParameters: [String: AnyObject]?, successCompletionHandler : (_ res : Alamofire.Response<AnyObject, NSError>) -> Void, errorCompletionHandler : @escaping () -> Void ) {
//        let apiURL = SportoBuddyHelper.apiBaseUrl + apiEndpoint
//        print("API URL \(apiURL)")
//        var accessToken = ""
//        if let user = SPUser.getUser() {
//            if let token = user.accessToken {
//                accessToken = token
//            }
//        }
//        let headers = [
//            "X-Auth-Token": SportoBuddyHelper.apiToken,
//            "X-Auth-User-Token": accessToken
//        ]
//        
//        Alamofire.upload(
//            .POST, apiURL, headers: headers
//            ,
//            multipartFormData: { multipartFormData in
//                if let imageData = imageDataModel.imageData {
//                    multipartFormData.appendBodyPart(data: imageData, name: imageDataModel.imageName!, fileName: imageDataModel.imageName! + ".jpg", mimeType: "image/jpeg")
//                } else {
//                    multipartFormData.appendBodyPart(data: NSData(), name: imageDataModel.imageName!, fileName: imageDataModel.imageName! + ".jpg", mimeType: "image/jpeg")
//                }
//                if let params = postParameters {
//                    for key in params.keys {
//                        multipartFormData.appendBodyPart(data: params[key]!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :key)
//                    }
//                }
//            },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    print(upload.request!.allHTTPHeaderFields)
//                    upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
////                        print("Uploading Avatar \(totalBytesWritten) / \(totalBytesExpectedToWrite)")
//                        dispatch_async(dispatch_get_main_queue(),{
//                            /**
//                             *  Update UI Thread about the progress
//                             */
//                        })
//                    }
//                    upload.responseJSON { (JSON) in
//                        dispatch_async(dispatch_get_main_queue(),{
//                            if JSON.result.isSuccess {
//                                print("success: \(JSON.debugDescription)")
//                            } else {
//                                print("failure \(JSON.result.debugDescription)")
//                            }
//                            successCompletionHandler(res: JSON)
//                        })
//                    }
//                    
//                case .Failure(let encodingError):
//                    //Show Alert in UI
//                    print("failure \(encodingError)");
//                    errorCompletionHandler()
//                }
//            }
//        )
//    }

    class func handleError(_ response : Alamofire.Response<AnyObject, NSError>,successHandler:(_ res : Alamofire.Response<AnyObject, NSError>) -> Void,errorhandler:() -> Void) {
        if response.response?.statusCode == 400 || response.response?.statusCode == 401{
            if let data = response.data {
                do {
                    let errorObject = try JSONSerialization.JSONObjectWithData(data, options: JSONSerialization.ReadingOptions.AllowFragments)
                    if let errors = errorObject.valueForKey("errors") as? NSArray{
                        for err in errors {
                            print(err)
                            if let errorMsg = err.valueForKey("message") as? String, let type = err.valueForKey("type") as? String {
                                if response.response?.statusCode == 401 {
                                    SportoBuddyUtils.displayAlert("Error", message: "Status: 401: \(errorMsg) \(type)")
                                } else {
                                    errorhandler()
                                    SportoBuddyUtils.displayAlert("Error", message: (errorMsg))
                                }
                            }
                            else{
                                if let type = err.valueForKey("type"){
                                    errorhandler()
                                    SportoBuddyUtils.displayAlert("Error", message: type as! String)
                                }
                            }
                        }
                    }
                } catch let error as NSError { print(error)}
            }
        } else {
            if let res = response.response{
                print(response.result.value)
                if (200...211).contains(res.statusCode){
                    print(response.result.value)
                    successHandler(res: response)
                }
                else{
                    errorhandler()
                    handleNoInternetConnection(response)
                }
            }
            else{
                errorhandler()
                handleNoInternetConnection(response)
            }
        }
    }
    
    class func handleNoInternetConnection(_ response : Alamofire.Response<AnyObject, NSError>) {
        if let error = response.result.error {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let viewController = delegate.window?.rootViewController
            if let _ = viewController?.presentedViewController as? UIAlertController{
                
            } else {
                print(error.description)
//                SportoBuddyUtils.displayAlert("Error", message: (error.localizedDescription))
            }
        }
    }
}

//MARK: UploadImage model
class UploadImageModel : NSObject {
    var imageData: Data?
    var imageName: String?
    
    enum RequestKey : String {
        case imageData     = "image",
        imageName          = "name"
    }
    
    convenience init(params : [String : AnyObject?]) {
        self.init()
        self.imageName           = params[RequestKey.imageName.rawValue] as? String
        self.imageData           = params[RequestKey.imageData.rawValue] as? Data
    }
    
}
