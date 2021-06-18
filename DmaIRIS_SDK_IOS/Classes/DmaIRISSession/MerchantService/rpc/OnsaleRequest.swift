//
//  OnsaleRequest.swift
//  Alamofire
//
//  Created by StarryMedia on 2021/3/5.
//

import Foundation

struct OnsaleRequest: Encodable {
    var owner: String?
    var denom: String?
    var labels: [Labels]?
    var signatures: String?
    var callBack: String?
    var memo: String?
    var hash: String?
    var deduction: Deduction?
    var transfers: [TransferEntity]?
}


struct Labels: Encodable {
    var tokenId: String?
    var price: Int?
}

struct Deduction: Encodable {
    var denom: String?
    var amount: String?
    var way: Way? //指定金额
}

enum Way: Int, Encodable {
    case QUOTA = 1
}
