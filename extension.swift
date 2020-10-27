//
//  extension.swift
//  
//
//  Created by mk on 10/9/20.
//

import Foundation
import RxSwift
import RxAlamofire
enum ApiResult<Value, Error>{
    case success(Value)
    case failure(Error)

    init(value: Value){
        self = .success(value)
    }

    init(error: Error){
        self = .failure(error)
    }
}

struct ApiErrorMessage: Codable{
  var  error_message: String
}

extension Observable where Element == (HTTPURLResponse, Data){
     func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<ApiResult<T, ApiErrorMessage>>{
        return self.map{ (httpURLResponse, data) -> ApiResult<T, ApiErrorMessage> in
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                // is status code is successful we can safely decode to our expected type T
                let object = try JSONDecoder().decode(type, from: data)
                return .success(object)
            default:
                // otherwise try
                let apiErrorMessage: ApiErrorMessage
                do{
                    // to decode an expected error
                    apiErrorMessage = try JSONDecoder().decode(ApiErrorMessage.self, from: data)
                } catch _ {
                    // or not. (this occurs if the API failed or doesn't return a handled exception)
                    apiErrorMessage = ApiErrorMessage(error_message: "Server Error.")
                }
                return .failure(apiErrorMessage)
            }
        }
    }
}
