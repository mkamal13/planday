//
//  ViewController.swift
//  planday
//
//  Created by mk on 10/2/20.
//
import UIKit
import RxSwift
import RxCocoa
import Foundation
import Alamofire
import RxAlamofire

class EmployeesViewController: UIViewController  {
 
    func enableSelection()  {
        tableView.rx.modelSelected(EmployeeModel.self)
            .map{ $0.id }
           .subscribe(onNext: { [weak self] id in
            let id:Int = id
            let detaialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            self?.present(detaialViewController, animated: true)
            detaialViewController.getEmployee(Id: id)

        }).disposed(by: disposeBag)
    }
    private var viewModel:EmployeeListViewModel=EmployeeListViewModel()
    let disposeBag = DisposeBag()
    var EmployeesDataSource: BehaviorRelay<[EmployeeModel]>=BehaviorRelay.init(value: [])
    let defaults=UserDefaults.standard
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        enableSelection()
        getEmployeesList()
    }
 
        
 
    func getEmployeesList()  {
        tableView.dataSource=nil
         let parameterDictionary = ["client_id" :  conf.clientId, "grant_type" :  conf.grantType,"refresh_token":conf.refreshToken]
 
        _=RxAlamofire.request(.post, "https://id.planday.com/connect/token", parameters: parameterDictionary)
            .responseData()
            .expectingObject(ofType: TokenInfo.self)
            .subscribe(onNext: { apiResult in
                    switch apiResult{
                    case let .success(loginResponse):
                        // handling the successful response
//                        print(loginResponse.access_token)
                        let defaults = UserDefaults.standard
                         defaults.set(loginResponse.access_token, forKey: "access_token")
                        DepartmentsService().FetchDepartments(Authorization: loginResponse.access_token, ClientId: conf.clientId)
                            .asObservable().map{
                                value in
                                
                                self.viewModel.fetchEmployeesViewModel(Authorization: loginResponse.access_token , ClientId: conf.clientId,departments:value.data).bind(to: self.tableView.rx.items(cellIdentifier: "employee")) { row, model, cell in
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
                            })
                        
                             
                     case let .failure(apiErrorMessage):
                        // handling the erroneous response
                        let alertController = UIAlertController(title: "error conecting to server", message: "kindly recheck your connection",preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)

                        print("Failed to fetch"+apiErrorMessage.error_message)
                    }
                },onError:{ err in
                    // handle client originating error
                })
      }
}
