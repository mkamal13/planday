//
//  EmployeeInfoService.swift
//  planday
//
//  Created by mk on 10/25/20.
//

import Foundation
import RxSwift
import Alamofire

protocol EmployeeInfoServiceProtocol {
    func FetchEmployeeInfo(  Id:Int) -> Observable<EmployeeData>
}

class EmployeeInfoService: EmployeeInfoServiceProtocol {
    
    func FetchEmployeeInfo(  Id:Int) -> Observable<EmployeeData>{
        return Observable.create{ observer->Disposable in
            let defaults=UserDefaults.standard
            let headers: HTTPHeaders = [
                "Authorization": "Bearer "+defaults.string(forKey: "access_token")!,
                "X-ClientId": conf.clientId
            ]
            AF.request("https://openapi.planday.com/hr/v1/employees/"+String(Id), headers: headers).responseData  { response in
                do{
                    let Employee = try JSONDecoder().decode(EmployeeData.self, from: response.value!)
                    
                    observer.onNext(Employee)
                }
                catch
                {
                    debugPrint("Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            return Disposables.create { }
            
        }
    }
}
