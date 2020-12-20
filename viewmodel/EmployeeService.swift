//
//  EmployeeService.swift
//  planday
//
//  Created by mk on 10/18/20.
//

import Foundation
import Alamofire
import RxSwift

protocol EmployeeServiceProtocol {
    func fetchEmployees(Authorization:String ,ClientId:String, departments:[DeptStruct])-> Observable<[EmployeeModel]>
    
}
class EmployeeService:EmployeeServiceProtocol{
    
func fetchEmployees(Authorization:String ,ClientId:String, departments:[DeptStruct])-> Observable<[EmployeeModel]> {
   

    return Observable.create{ observer->Disposable in
    let headers: HTTPHeaders = [
        "Authorization": "Bearer "+Authorization,
        "X-ClientId": ClientId
    ]
    AF.request("https://openapi.planday.com/hr/v1/employees", headers: headers).responseData  { response in
            do{
               var Employees = try JSONDecoder().decode(EmployeeList.self, from: response.value!)
                var r=departments
                
                Employees.data = Employees.data.map{ value -> EmployeeModel in
                    var cop=value
                    for department in cop.departments
                    {
                        for deptcode in departments
                        {
                           if( department==deptcode.id)
                           {
                            if(cop.departmentsname != nil)
                            {
                                cop.departmentsname?.append(deptcode.name)
                            }
                            else
                            {
                                cop.departmentsname=[deptcode.name]
                            }
                           }
                         }
                        
                    }
                        
//                    cop.departmentsname=["pop"]
                    return cop
                }
                observer.onNext(Employees.data)
               }
            catch
            let error as NSError {
                debugPrint("Error: \(error.description)")
                observer.onError(error)
                }
            }
        return Disposables.create {
            
        }
    }
   
   }
}
