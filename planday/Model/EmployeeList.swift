import Foundation

// MARK: - Welcome
struct EmployeeList:  Decodable{
    let paging: Paging
    var data: [EmployeeModel]
}

// MARK: - Datum
struct EmployeeModel: Codable {
    let id: Int
    let dateTimeCreated: String
    let dateTimeModified: String?
    let employeeTypeID: Int
    let salaryIdentifier, firstName, lastName, userName: String
    let cellPhone: CellPhone
    let street1, street2, zip, phone: String
    let city, email: String
    let departments, employeeGroups: [Int]
    var departmentsname: [String]?

    enum CodingKeys: String, CodingKey {
        case id, dateTimeCreated, dateTimeModified
        case employeeTypeID = "employeeTypeId"
        case salaryIdentifier, firstName, lastName, userName, cellPhone, street1, street2, zip, phone, city, email, departments, employeeGroups,departmentsname
    }
}

enum CellPhone: String, Codable {
    case empty = ""
    case the45 = "+45"
}

// MARK: - Paging
struct Paging: Codable {
    let limit, total: Int
}
