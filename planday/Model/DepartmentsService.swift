//
//  DepartmentsService.swift
//  
//
//  Created by mk on 10/17/20.
//

import Foundation
import RxSwift
import Alamofire
protocol DepartmentsServiceProtocol {
    func FetchDepartments(Authorization:String ,ClientId:String)->Observable<[DeptStruct]>
 }


class DepartmentsService{
    
   
    
    func   FetchDepartments(Authorization:String ,ClientId:String)->Observable<DepartmentModel>
   {
        return Observable.create {
            observer -> Disposable in
        let headers: HTTPHeaders = [
            "Authorization": "Bearer "+Authorization,
            "X-ClientId": ClientId
        ]
            AF.request("https://openapi.planday.com/hr/v1/departments/",headers: headers  ).responseData  { response in
                                  do{
                                    let departments = try JSONDecoder().decode(DepartmentModel.self, from: response.value!)
                                   
                                    observer.onNext(departments)
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
