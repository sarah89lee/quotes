//
//  QuotesHTTP.swift
//  Quotes
//
//  Created by Sarah Lee on 4/14/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class QuotesHTTP: NSObject {

    public static func makeApiRequest(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        autoLogout: Bool = true,
        completion: @escaping (_ dataResponse: DataResponse<JSON>) -> ()) {
        
        let newHeaders = headers != nil ? headers! : HTTPHeaders()
        
        fireCompletion(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: newHeaders,
            autoLogout: autoLogout,
            completion: completion
        )
    }

    public static func printDataResponse(dataResponse: DataResponse<JSON>) {
        print(dataResponse.request)
        print(dataResponse.response)
        print(dataResponse.error)
        print(dataResponse.value)
    }
    
    // MARK: - Private Methods
    
    private static func fireCompletion( _ url: URLConvertible,
                                        method: HTTPMethod = .get,
                                        parameters: Parameters? = nil,
                                        encoding: ParameterEncoding = URLEncoding.default,
                                        headers: HTTPHeaders? = nil,
                                        autoLogout: Bool = true,
                                        completion: @escaping (_ dataResponse: DataResponse<JSON>) -> ()) {
        let newHeaders = headers != nil ? headers! : HTTPHeaders()
        
        let response = Alamofire.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: newHeaders
        )
        
        response.responseSwiftyJSON(completionHandler: { dataResponse in
            completion(dataResponse)
        })
    }
}
