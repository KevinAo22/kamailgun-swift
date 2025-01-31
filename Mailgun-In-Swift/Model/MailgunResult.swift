//
//  MailgunAPI.swift
//  Mailgun-In-Swift
//
//  Created by Ao Zhang on 21/11/2017.
//  Copyright © 2017 KevinAo. All rights reserved.
//
// EDITED TO WORK WITH ALAMOFIRE 5/6 by https://github.com/Noy
//

import Foundation
import ObjectMapper


import ObjectMapper

open class MailgunResult: Mappable, Decodable {
    open var success: Bool? // Make this optional
    open var message: String?
    open var id: String?

    open var hasError: Bool {
        return success == nil || !success!
    }

    public init() {}

    public convenience init(success: Bool?, message: String, id: String?) {
        self.init()
        self.success = success
        self.message = message
        self.id = id
    }

    public required init?(map: Map) {}

    open func mapping(map: Map) {
        message <- map["message"]
        id      <- map["id"]
        success <- map["success"] // Map the success key here, but it's optional now
    }

    // MARK: - Decodable Conformance
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case id
    }

    // Custom init for Decoding
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }
}
