//
//  Router.swift
//
//  Created by Aadesh Maheshwari on 25/03/17.
//  Copyright © 2017 Aadesh Maheshwari. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

/**
 *  Base router which has list of all the router that will be used to make network call
 *  throughout the app.
 */
enum Router: URLRequestConvertible {
    
    // Custom variable defined in build.
    static let baseURLString = Helper.apiBaseUrl
    
    case userRouterManager(LoginRouter)
    case registerRouterManager(RegisterRouter)
    case otpRouterManager(SPOTPRouter)
    case countryStateRouterManager(SPCountryStateRouter)
    case modulesRouterManager(SPModuleRouter)
    case userInterestManager(SPUserInterestRouter)
    case userProfileManager(SPUserProfileRouter)
    case venueRouterManager(VenueRouter)
    case venueBookingRouterManager(SPBookingRouter)
    case venueDetailsRouterManager(VenueDetailRouter)
    case venueReviewRouterManager(VenueReviewRouter)
    case searchRouterManager(SPSearchRouter)
    case aboutUsRouterManager(SPAboutUsRouter)
    case yourBookingsRouterManager(SPYourBookingsRouter)
    case checkoutRouterManager(SPCheckoutRouter)
    case notificationsRouterManager(SPNotificationsRouter)
    case yourFavouritesRouterManager(SPYourFavouritesRouter)
    case yourReviewsRouterManager(SPYourReviewsRouter)
    case businessListRouterManager(BusinessListRouter)
    case suggestServiceRouterManager(SuggestServiceRouter)
    case spMatchRouterManager(SPMatchRouter)
    case spYourBuddiesRouterManager(SPYourBuddiesRouter)
    case yourGameRouterManager(YourGameRouter)
    case yourRecentlyViewedRouterManager(SPYourRecentlyViewedRouter)
    case settingsRouterManager(SPSettingsRouter)
    case spPackagesRouterManager(SPPackagesRouter)
    
    var URLRequest: NSMutableURLRequest {
        switch self {
            case .UserRouterManager(let requset):
                let urlRequest = configureRequest(requset)
                return urlRequest
                
            case .RegisterRouterManager(let requset):
                let urlRequest = configureRequest(requset)
                return urlRequest
                
            case .OTPRouterManager(let requset):
                let urlRequest = configureRequest(requset)
                return urlRequest
                
            case .CountryStateRouterManager(let requset):
                let urlRequest = configureRequest(requset)
                return urlRequest
                
            case .ModulesRouterManager(let requset):
                let urlRequest = configureRequest(requset)
                return urlRequest
                
            case .UserInterestManager(let requset):
                let urlRequest = configureRequest(requset)
                return urlRequest
                
            case .UserProfileManager(let requset):
                let urlRequest = configureRequest(requset)
                return urlRequest
                
            case .VenueRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
                
            case .VenueBookingRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
                
            case .VenueDetailsRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
                
            case .VenueReviewRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
            
            case .SearchRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
                
            case .AboutUsRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
                
            case .YourBookingsRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
            
            case .CheckoutRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
            
            case .NotificationsRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
                
            case .YourFavouritesRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
            
            case .YourReviewsRouterManager(let request):
                let urlRequest = configureRequest(request)
                return urlRequest
            
            case .BusinessListRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
            
            case .SuggestServiceRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
            
            case .SPMatchRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
            
            case .SPYourBuddiesRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
            
            case .YourGameRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
            
            case .YourRecentlyViewedRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
            
            case .SettingsRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
            
            case .SPPackagesRouterManager(let request):
                let urlRequest = configureCustomRequest(request)
                return urlRequest
        }
    }
    
    /**
     Configure app level request object.
     - Set request path
     - Set request method
     - Set Headers [Authorization, Accept, Content-Type]
     - Set request body
     - set request parameters
     
     - parameter requestObj: Router of type RouterProtocol
     
     - returns: NSMutableURLRequest object
     */
    func configureRequest(_ requestObj: RouterProtocol) -> NSMutableURLRequest {
        
        print(Router.baseURLString)
        
        let url = URL(string: Router.baseURLString)!
        
        let mutableURLRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(requestObj.path)!) // Set request path
        mutableURLRequest.HTTPMethod = requestObj.method.rawValue // Set request method
        
        setAuthorizationHeaderField(mutableURLRequest)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField:"Accept")
        mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        mutableURLRequest.setValue("IPhone", forHTTPHeaderField:"User-Agent")
        
        if requestObj.method == Alamofire.Method.POST || requestObj.method == Alamofire.Method.DELETE {
            // Request type is post/put -> check for request body
            if let body: RequestBody = requestObj.body {
                do {
                    mutableURLRequest.HTTPBody = try JSONSerialization.dataWithJSONObject(Mapper().toJSON(body), options: JSONSerialization.WritingOptions())
                } catch {
                    // No-op
                }
            }
        }
        
        // Check if request has parameters defined
        if let parameters: RequestBody = requestObj.parameters {
            print("\(Mapper().toJSON(parameters))")
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: Mapper().toJSON(parameters)).0
            
        } else {
            return mutableURLRequest
        }
    }
    
    func configureCustomRequest(_ requestObj: RouterProtocolAPI) -> NSMutableURLRequest {
        
        print(Router.baseURLString)
        
        let url = URL(string: Router.baseURLString)!
        
        let mutableURLRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(requestObj.path)!) // Set request path
        mutableURLRequest.HTTPMethod = requestObj.method.rawValue // Set request method
        
        setAuthorizationHeaderField(mutableURLRequest)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField:"Accept")
        mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        mutableURLRequest.setValue("IPhone", forHTTPHeaderField:"User-Agent")
        
        if requestObj.method == Alamofire.Method.POST || requestObj.method == Alamofire.Method.DELETE {
            // Request type is post/put -> check for request body
            if let body: APIRequestBody = requestObj.body {
                do {
                    mutableURLRequest.HTTPBody = try JSONSerialization.dataWithJSONObject(Mapper().toJSON(body), options: JSONSerialization.WritingOptions())
                } catch {
                    // No-op
                }
            }
        }
        
        // Check if request has parameters defined
        if let parameters: APIRequestBody = requestObj.parameters {
            print("\(Mapper().toJSON(parameters))")
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: Mapper().toJSON(parameters)).0
            
        } else {
            return mutableURLRequest
        }
    }

    
    /**
     
     Checks for the auth token stored in the persitent storage and assign to the headers of the NSURLRequest
     
     - parameter mutableURLRequest: NSMutableRequest for which authorization needs to be set
     */
    func setAuthorizationHeaderField(_ mutableURLRequest : NSMutableURLRequest) {
        mutableURLRequest.setValue(Helper.apiToken, forHTTPHeaderField: "X-Auth-Token")
        if let user = SPUser.getUser() {
            if let accessToken = user.accessToken {
                mutableURLRequest.setValue(accessToken, forHTTPHeaderField: "X-Auth-User-Token")
            }
        }
    }
}

// MARK: - Alamofire request extension
//  - Add debugLog method which logs request
extension Request {
    public func debugLog() -> Self {
        
        print("===============")
        print(self)
        print("Headers ---> ")
        print(self.request!.allHTTPHeaderFields)
        print("Body ---> ")
        if let requestBody = self.request!.HTTPBody {
            print(NSString(data: requestBody, encoding: NSUTF8StringEncoding))
        }
        print("===============")
        
        return self
    }
}
