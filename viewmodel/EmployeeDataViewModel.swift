//
//  EmployeeDataViewModel.swift
//  planday
//
//  Created by mk on 10/26/20.
//

import Foundation
import RxSwift

class EmployeeDataViewModel {
     
    var employeeInfoService:EmployeeInfoServiceProtocol
    init(employeeInfoService:EmployeeInfoServiceProtocol) {
        self.employeeInfoService=employeeInfoService
        
    }
    
    func fetchEmployeeData(id:Int, firstField:UITextField,lastField:UITextField,genderField:UITextField)
     {
         employeeInfoService.FetchEmployeeInfo(Id: id).asObservable()
            .map{ value in
                firstField.text=value.data.firstName
                lastField.text=value.data.lastName
                genderField.text=value.data.gender
 
                return (Any).self
            }.subscribe(onNext:{print($0)
                
            })
     }
}
