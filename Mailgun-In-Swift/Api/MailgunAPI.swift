//
//  MailgunAPI.swift
//  Mailgun-In-Swift
//
//  Created by Ao Zhang on 21/11/2017.
//  Copyright © 2017 KevinAo. All rights reserved.
//
// EDITED TO WORK WITH ALAMOFIRE 5/6 by https://github.com/Noy
//

import Alamofire
import ObjectMapper
import Foundation

/// Mailgun API Class to be use to send emails
open class MailgunAPI {
    
    fileprivate let apiKey : String
    fileprivate let domain : String
    fileprivate let regionEurope : Bool
    
    
    //ApiRouter enum that will take care of the routing of the urls and paths of the API
    fileprivate enum ApiRouter {
        
        
        case sendEmail(String)
        
        var path: String {
            switch self{
            case .sendEmail(let domain):
                return "\(domain)/messages";
                
            }
        }
        
        fileprivate func urlStringWithApiKey(_ apiKey : String, regionEurope: Bool) -> URLConvertible {
            
            //Builds the url with the API key
            let urlWithKey: String
            if regionEurope {
                urlWithKey = "https://api:\(apiKey)@\(Constants.mailgunApiURLEU)"
            } else {
                urlWithKey = "https://api:\(apiKey)@\(Constants.mailgunApiURL)"
            }
            //Build API URL
            var url = URL(string: urlWithKey)!
            url = url.appendingPathComponent(path)
            
            let urlRequest = NSMutableURLRequest(url: url)
            
            return urlRequest.url!;
            
        }
        
    }
    
    /**
     Inits the API with the ApiKey and client domain
     
     - parameter apiKey:       Api key to use the API
     - parameter clientDomain: Client domain authorized to send your emails
     - parameter regionEurope: Client region, default is not europe
     
     - returns: MailGun API Object
     */
    public init(apiKey:String, clientDomain:String, regionEurope:Bool = false){
        self.apiKey = apiKey
        self.domain = clientDomain
        self.regionEurope = regionEurope
    }
    
    
    /**
     Sends an email with the provided parameters
     
     - parameter to:                email to
     - parameter from:              email from
     - parameter subject:           subject of the email
     - parameter bodyHTML:          html body of the email, can be also plain text
     - parameter completionHandler: the completion handler
     */
    open func sendEmail(to:String, from:String, subject:String, bodyHTML:String, completionHandler:@escaping (MailgunResult)-> Void) -> Void {
        
        let email = MailgunEmail(to: to, from: from, subject: subject, html: bodyHTML)
        
        self.sendEmail(email, completionHandler: completionHandler)
        
    }
    
    /**
     Send the email with the email object
     
     - parameter email:             email object
     - parameter completionHandler: completion handler
     */
    
    open func sendEmail(_ email: MailgunEmail, completionHandler: @escaping (MailgunResult) -> Void) -> Void {
        // Serialize the object to a dictionary [String: Any]
        let params = Mapper().toJSON(email)

        // The Mailgun API expects multipart params
        // Set up the multipart request
        
        let headers: HTTPHeaders = [
            .authorization(username: "api", password: self.apiKey)
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                if let stringValue = value as? String {
                    if let data = stringValue.data(using: .utf8, allowLossyConversion: false) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
        }, to: ApiRouter.sendEmail(self.domain).urlStringWithApiKey(self.apiKey, regionEurope: self.regionEurope), headers: headers)
        .validate()
        .responseDecodable(of: MailgunResult.self) { response in
            switch response.result {
            case .success(let result):
                // Check if the response contains a success message
                if let message = result.message?.lowercased(), message.contains("queued") {
                    // Treat it as success if the message contains 'Queued' (which mailgun does)
                    print("Email successfully queued: \(message)")
                    completionHandler(result)
                } else {
                    // Handle unexpected responses or success in another format
                    let failureResult = MailgunResult(success: false, message: "Unexpected response format: \(result.message ?? "No message")", id: result.id)
                    completionHandler(failureResult)
                }

            case .failure(let error):
                // In case of failure, handle the error response
                print("Error calling Mailgun API: \(error.localizedDescription)")

                // Return failure with error details
                let failureResult = MailgunResult(success: false, message: error.localizedDescription, id: nil)
                completionHandler(failureResult)
            }
        }
    }

    // Helper function to decode JSON into a MailgunResult
    private func decodeJson(_ json: [String: Any]) -> MailgunResult? {
        // Convert the dictionary to Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }
        
        // Decode the JSON into a MailgunResult
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(MailgunResult.self, from: jsonData)
            return result
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
            return nil
        }
    }

}
