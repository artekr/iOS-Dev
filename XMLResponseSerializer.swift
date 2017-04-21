//
//  XMLResponseSerializer.swift
//  Test
//
//  Created by Heng Wang on 2016-09-29.
//  Copyright © 2016 Heng Wang. All rights reserved.
//

import Foundation
import Alamofire
import Ono

class XMLResponseSerializer {
  
}

public enum ErrorCode: Int {
  case XMLSerializationFailed         = -1001
  case JSONSerializationFailed        = -1002
}

extension Request {
  public static func XMLResponseSerializer() -> ResponseSerializer<ONOXMLDocument, NSError> {
    return ResponseSerializer { request, response, data, error in
      guard error == nil else { return .Failure(error!) }
      
      guard let validData = data else {
        let failureReason = "Data could not be serialized. Input data was nil."
        let error = NSError(domain: "com.Playster", code: ErrorCode.XMLSerializationFailed.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey:failureReason])
        return .Failure(error)
      }
      
      do {
        let XML = try ONOXMLDocument(data: validData)
        return .Success(XML)
      } catch {
        return .Failure(error as NSError)
      }
    }
  }
  
  public func responseXMLDocument(completionHandler: Response<ONOXMLDocument, NSError> -> Void) -> Self {
    return response(responseSerializer: Request.XMLResponseSerializer(), completionHandler: completionHandler)
  }
}
