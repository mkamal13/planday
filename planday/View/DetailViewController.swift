//
//  DetailViewController.swift
//  planday
//
//  Created by mk on 10/23/20.
//
import Alamofire
import UIKit
import RxAlamofire
import RxSwift
class DetailViewController: UIViewController,UIAdaptivePresentationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate {
    @IBOutlet weak var FirstNameField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var GenderField: UITextField!
    
    var Id:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationController?.delegate = self
//        self.isModalInPresentation=true
        // Do any additional setup after loading the view.
    }
    func getEmployee(Id:Int)
    {
        let employeeDataViewModel=EmployeeDataViewModel(employeeInfoService: EmployeeInfoService())
        employeeDataViewModel.fetchEmployeeData(id: Id, firstField: FirstNameField,lastField: LastNameField,genderField: GenderField)
        self.Id=Id
        GenderField.delegate=self
  
    }
    
 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch GenderField.text{
        case "Male":
            GenderField.text="Female"
            break
        case "Female":
            GenderField.text="Male"
            break
        default:
            print("unexpicted string at gender label")
        }
        return false
    }
    
     func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool
    {
        let alertController = UIAlertController(title: "you did not save changes", message: "would you like to save changes?",preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            self.saveFields()
            self.dismiss(animated:true, completion: nil)
            var parentController = self.presentingViewController as! ViewController
             parentController.getEmployeesList()
            }
            
        let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
            self.dismiss(animated:true, completion: nil)
           var parentController = self.presentingViewController as! ViewController
            parentController.getEmployeesList()
            }
            
           // Add Actions
           alertController.addAction(yesAction)
           alertController.addAction(noAction)
            
           // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
           return false
    }
    func jsonEncodeFields()->Data?  {
        let dic = ["firstName": FirstNameField.text, "lastName": LastNameField.text, "gender": GenderField.text]
        var jsonData:Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data

            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data

            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                // use dictFromJSON
                return jsonData

            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func saveFields() {
        var request = URLRequest(url: URL(string: "https://openapi.planday.com/hr/v1/employees/"+String(Id))!)
            //Following code to pass post json
            request.httpBody = jsonEncodeFields()
            request.httpMethod = "PUT"
            let defaults=UserDefaults.standard
            let headers: HTTPHeaders = [
                "Authorization": "Bearer "+defaults.string(forKey: "access_token")!,
                "X-ClientId": conf.clientId
            ]
            request.headers=headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        RxAlamofire.request(request as URLRequestConvertible).responseJSON().asObservable().subscribe(onNext: {
           debugPrint ($0.data)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
