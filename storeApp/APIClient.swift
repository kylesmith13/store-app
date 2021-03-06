//
//  APIClient.swift
//  Clarks
//
//  Created by Kyle Smith on 8/30/16.
//  Copyright © 2016 Codesmiths. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess
import SwiftyJSON


class APIClient {
    static let sharedInstance = APIClient()
    
    let keychain = Keychain(service: "com.codesmiths.storeapp")
    let APITokenKey      = "authToken"
    //let baseAPIURL = "http://127.0.0.1:3000/api"
    //let loginVerifyBase  = "http://127.0.0.1:3000"
    let loginVerifyBase = "http://138.197.104.234"
    let baseAPIURL = "http://138.197.104.234/api"
    
    // MARK: - Internal Functions
    func getAccessToken() -> String? {
        return try! keychain.getString(APITokenKey)
    }
    
    func setAccessToken(token: String) {
        do {
            try keychain.set(token, key: APITokenKey)
        }
        catch let error {
            debugPrint(error)
        }
    }
    
    func setupGETHeaders() -> NSDictionary {
        var token:String
        
        if getAccessToken() != nil {
            token = "Bearer " + getAccessToken()!
        } else {
            token = ""
        }
        
        let verifyHeaders:NSDictionary = [
            "Authorization": token,
            "Content-Type" : "application/json",
            "Accept"       : "application/json" ]
        
        return verifyHeaders
    }
    
    func setupPUTHeaders() -> NSDictionary {
        var token:String
        
        if getAccessToken() != nil {
            token = "Bearer " + getAccessToken()!
        } else {
            token = ""
        }
        
        let verifyHeaders:NSDictionary = [
            "Authorization": token,
            "Accept"       : "application/json" ]
        
        return verifyHeaders
    }
    
    // MARK: - REST API Functions
    
    func GET(urlString: URLConvertible,
             headers: NSDictionary,
             success: @escaping (JSON) -> Void,
             failure: @escaping (NSError) -> Void) {
        
        Alamofire
            .request(urlString, method: .get, headers: headers as? HTTPHeaders)
            .responseJSON { (responseObject) -> Void in
                
                if responseObject.result.isSuccess {
                    let resJSON = JSON(responseObject.result.value!)
                    success(resJSON)
                }
                
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error as NSError)
                }
        }
    }
    
    func getWithParams(urlString: URLConvertible,
                       parameters: NSDictionary,
                       headers: NSDictionary,
                       success: @escaping (JSON) -> Void,
                       failure: @escaping (NSError) -> Void) {
        
        Alamofire
            .request(urlString, method: .get, parameters: parameters as? Parameters, headers: headers as? HTTPHeaders)
            .responseJSON { (responseObject) -> Void in
                
                if responseObject.result.isSuccess {
                    let resJSON = JSON(responseObject.result.value!)
                    success(resJSON)
                }
                
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error as NSError)
                }
        }
    }
    
    func POST(urlString:URLConvertible,
              parameters:NSDictionary,
              headers:NSDictionary,
              success: @escaping (JSON) -> Void,
              failure: @escaping (NSError) -> Void) {
        
            Alamofire
                .request(urlString, method: .post, parameters: parameters as? Parameters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
                .responseJSON { (responseObject) -> Void in
                    if responseObject.result.isSuccess {
                        let resJSON = JSON(responseObject.result.value!)
                        success(resJSON)
                    }
                    
                    if responseObject.result.isFailure {
                        let error : Error = responseObject.result.error!
                        failure(error as NSError)
                    }
            }
    }
    
    func PUT(urlString:URLConvertible,
              parameters:NSDictionary,
              headers:NSDictionary,
              success: @escaping (JSON) -> Void,
              failure: @escaping (NSError) -> Void) {
        
        Alamofire
            .request(urlString, method: .put, parameters: parameters as? Parameters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders)
            .responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    let resJSON = JSON(responseObject.result.value!)
                    success(resJSON)
                }
                
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error as NSError)
                }
        }
    }
    
    // MARK: - External Functions
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    func isAuthenticated(success: @escaping (JSON) -> Void,
                         failure: @escaping (NSError) -> Void){
        
        let verifyHeaders:NSDictionary = setupGETHeaders()
        let verifyURL:URLConvertible = loginVerifyBase + "/verify"
        
        GET(urlString: verifyURL,
            headers: verifyHeaders,
            success: {(responseObject) -> Void in
                success(responseObject)
                if(responseObject["status"] == 200) {
                    UserDefaults.standard.setIsLoggedIn(value: true)
                } else {
                    UserDefaults.standard.setIsLoggedIn(value: false)
                }
            },
            failure:{(error) -> Void in
                failure(error)
                UserDefaults.standard.setIsLoggedIn(value: false)
        })
    }
    
    func login(params: NSDictionary,
               success: @escaping (JSON) -> Void,
               failure: @escaping (NSError) -> Void) {
        
        let loginURL:URLConvertible = loginVerifyBase + "/login"
        let loginHeaders:NSDictionary = ["Accept" : "application/json"]
        
        return POST(urlString: loginURL,
                    parameters: params,
                    headers: loginHeaders,
                    success: {(responseObject) -> Void in
                        self.setAccessToken(token: responseObject["authtoken"].stringValue)
                        UserDefaults.standard.setIsLoggedIn(value: true)
                        success(responseObject)
                    },
                    failure: failure)
    }
    
    func logout(success: @escaping (JSON) -> Void,
                failure: @escaping (NSError) -> Void) {
        
        let logoutURL:URLConvertible = loginVerifyBase + "/logout"
        let logoutHeaders = setupGETHeaders()
        
        return GET(urlString: logoutURL,
                   headers: logoutHeaders,
                   success: {(responseObject) -> Void in
                        UserDefaults.standard.setIsLoggedIn(value: false)
                        success(responseObject)
                        try! self.keychain.remove(self.APITokenKey)
                   },
                   failure: failure)
    }
    
    func loadSettings(success: @escaping (JSON) -> Void,
                    failure: @escaping (NSError) -> Void) {
        
        let storesURL:URLConvertible = baseAPIURL + "/settings"
        let loadStoresHeaders = setupGETHeaders()
        
        return GET(urlString: storesURL,
                   headers: loadStoresHeaders,
                   success: {(responseObject) -> Void in
                    success(responseObject)
            },
                   failure: failure)
    }
    
    func loadStores(success: @escaping (JSON) -> Void,
                    failure: @escaping (NSError) -> Void) {
        
        let storesURL:URLConvertible = baseAPIURL + "/stores"
        let loadStoresHeaders = setupGETHeaders()
        
        return GET(urlString: storesURL,
                   headers: loadStoresHeaders,
                   success: {(responseObject) -> Void in
                    success(responseObject)
                   },
                   failure: failure)
    }
    
    func loadCoupons(params: NSDictionary,
                     success: @escaping (JSON) -> Void,
                     failure: @escaping (NSError) -> Void) {
        
        let couponsURL:URLConvertible = baseAPIURL + "/coupons"
        let loadCouponsHeaders = setupGETHeaders()
        
        return getWithParams(urlString: couponsURL,
                             parameters: params,
                             headers: loadCouponsHeaders,
                             success: {(responseObject) -> Void in
                                success(responseObject)
                            },
                             failure: failure)
    }
    
    func createUser(params: NSDictionary,
                    success: @escaping (JSON) -> Void,
                    failure: @escaping (NSError) -> Void) {
        
        let createUserURL:URLConvertible = baseAPIURL + "/users"
        let createUserHeaders:NSDictionary = ["Accept" : "application/json"]
        
        return POST(urlString: createUserURL,
                    parameters: params,
                    headers: createUserHeaders,
                    success: {(responseObject) -> Void in
                        success(responseObject)
        },
                    failure: failure)
    }
    
    func updateUser(id: String,
                    params: NSDictionary,
                    success: @escaping (JSON) -> Void,
                    failure: @escaping (NSError) -> Void){
        
        let updateUserURL:URLConvertible = loginVerifyBase + "/users/" + id + "/profile"
        let updateUsersHeaders = setupPUTHeaders()
        
        return PUT(urlString: updateUserURL,
                   parameters: params,
                   headers: updateUsersHeaders,
                   success: {(responseObject) -> Void in
                        success(responseObject)},
                   failure: failure)
    }
}
