//  EmployeeListViewModel.swift
//  planday
//  Created by mk on 10/18/20.
 
import Foundation
import RxSwift
class EmployeeListViewModel {
    let employeeService:EmployeeServiceProtocol
     init(employeeService:EmployeeService = EmployeeService()
 
    ) {
        self.employeeService=employeeService
 
    }
    
    func fetchEmployeesViewModel(Authorization:String ,ClientId:String, departments:[DeptStruct]) -> Observable<[EmployeeModel]> {
 
        return  employeeService.fetchEmployees(Authorization: Authorization, ClientId: ClientId, departments:departments)
     }
}
