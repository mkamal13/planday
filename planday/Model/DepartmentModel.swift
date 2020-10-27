//
//  DepartmentModel.swift
//  planday
//
//  Created by mk on 10/16/20.
//


import Foundation

// MARK: - Welcome
struct DepartmentModel: Codable {
    let paging: Paging
    let data: [DeptStruct]
}

// MARK: - Datum
struct DeptStruct: Codable {
    let id: Int
    let name, number: String
}

// MARK: - Paging
 
