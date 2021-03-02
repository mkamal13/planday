//  EmployeeListViewModel.swift
//  planday
//  Created by mk on 10/18/20.
 
import Foundation
import RxSwift
import UIKit
import  Alamofire
import RxAlamofire
class EmployeeListViewModel {
    let  disposeBag = DisposeBag()

    let employeeService:EmployeeServiceProtocol
     init(employeeService:EmployeeService = EmployeeService()
      ) {
        self.employeeService=employeeService
    }
    
    func fetchEmployeesViewModel(Authorization:String ,ClientId:String, departments:[DeptStruct]) -> Observable<[EmployeeModel]> {
        return  employeeService.fetchEmployees(Authorization: Authorization, ClientId: ClientId, departments:departments)
     }
    
    func getEmployeesList(tableView:UITableView ,viewController:UIViewController)  {
        tableView.dataSource=nil
        let parameterDictionary = ["client_id" :  conf.clientId, "grant_type" :  conf.grantType,"refresh_token":conf.refreshToken]
        AF.request("https://id.planday.com/connect/token" ,method: HTTPMethod.post, parameters: parameterDictionary).responseData  { response in
            do{
                let tokenInfo = try JSONDecoder().decode(TokenInfo.self, from: response.value!)
                let observable=Observable.of(tokenInfo)
                observable.subscribe(onNext: { apiResult in
                        let defaults = UserDefaults.standard
                        defaults.set(apiResult.access_token, forKey: "access_token")
                        DepartmentsService().FetchDepartments(Authorization: apiResult.access_token, ClientId: conf.clientId)
                            .asObservable().map{
                                value in
                                self.fetchEmployeesViewModel(Authorization: apiResult.access_token , ClientId: conf.clientId,departments:value.data).bind(to: tableView.rx.items(cellIdentifier: "employee")) { row, model, cell in
                                   cell.textLabel?.text = "\(model.firstName), \(model.lastName)"
                                    cell.detailTextLabel?.text=""
                                    var t=model.departmentsname!
                                    for str in t
                                    {
                                        cell.detailTextLabel?.text=(cell.detailTextLabel?.text)! + " "+str
                                    }
                               }
                              }.subscribe(onNext:{
                                print($0)
                            }).disposed(by:self.disposeBag)
                        
                             
                     
                },onError:{ err in
                    // handle client originating error
                }).disposed(by:self.disposeBag)
             }
            catch
            {
                debugPrint("Error: \(error.localizedDescription)")
             }
        }
 
      }
}
