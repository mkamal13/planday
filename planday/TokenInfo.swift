//
//  TokenInfo.swift
//  rxsample
//
//  Created by mk on 9/25/20.
//  Copyright © 2020 mk. All rights reserved.
//

import Foundation
struct TokenInfo:Codable {
    let id_token:String
    let access_token:String
    let expires_in:Int
    let token_type:String
    let refresh_token:String
    let scope:String
}
