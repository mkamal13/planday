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
    let defaults=UserDefaults.standard
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        enableSelection()
        getEmployeesList(tableView: tableView,viewController: self)
    }
    
    func getEmployeesList(tableView:UITableView ,viewController:UIViewController)  {
        viewModel.getEmployeesList(tableView: tableView, viewController: viewController)
    }

}
