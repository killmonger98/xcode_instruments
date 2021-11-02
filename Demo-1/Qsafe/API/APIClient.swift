//
//  APIClient.swift
//  Qsafe
//
//  Created by Abhiram on 11/02/21.
//

import Foundation
import Alamofire

// MARK: - API CLIENT CLASS
class APIClient {

    /// to fetch API response form endpoint
    class func callRequest(url: String,
                           parameters: [String: String],
                           method: HTTPMethod, encodeing: JSONEncoding,
                           completionHandler: @escaping (DataRequest?, Error?) -> Void) {

//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                print(response)
//            }

        let request = AF.request(url, method: method, parameters: parameters).validate(statusCode: 200..<300)
        switch request.response?.statusCode {
        case 200: print("OK")
        case (200..<299)?: print("Success")
        case (300..<399)?: print("Redirection")
        case 400: print("Bad Request")
        case 404: print("Not Found")
        case 500: print("Server Error")
        default: break
        }
        if request.error == nil {
            completionHandler(request, nil)
        } else {
            completionHandler(nil, request.error)
        }

    }

}
