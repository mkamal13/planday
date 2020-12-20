import Foundation

// MARK: - EmployeeData
struct EmployeeData: Codable {
    let data: EmployeeDataClass
}

// MARK: - DataClass
struct EmployeeDataClass: Codable {
    let id: Int
    let salaryIdentifier, gender: String
    let employeeTypeID: Int
    let dateTimeCreated, firstName, lastName, userName: String
    let street1, street2, zip, phone: String
    let phoneCountryCode, city, email: String
    let departments, employeeGroups: [Int]

    enum CodingKeys: String, CodingKey {
        case id, salaryIdentifier, gender
        case employeeTypeID = "employeeTypeId"
        case dateTimeCreated, firstName, lastName, userName, street1, street2, zip, phone, phoneCountryCode, city, email, departments, employeeGroups
    }
}

