//
//  DotPaymentsModel.swift
//  tinder_messages_screen
//
//  Created by Animesh Mohanty on 05/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

import Foundation
import UIKit

struct DotPaymentsModel: Codable {
    let amount: String
    let cgstPercentage, convenienceFee, discountPercentage, grossTotal: Int
    let igstPercentage, payerID: Int
    let payerType, paymentDate: String
    let paymentID, receiverID: Int
    let receiverType: String
    let sgstPercentage: Int
    let status, transanctionID: String

    enum CodingKeys: String, CodingKey {
        case amount
        case cgstPercentage = "cgst_percentage"
        case convenienceFee = "convenience_fee"
        case discountPercentage = "discount_percentage"
        case grossTotal = "gross_total"
        case igstPercentage = "igst_percentage"
        case payerID = "payer_id"
        case payerType = "payer_type"
        case paymentDate = "payment_date"
        case paymentID = "payment_id"
        case receiverID = "receiver_id"
        case receiverType = "receiver_type"
        case sgstPercentage = "sgst_percentage"
        case status
        case transanctionID = "transanction_id"
    }
}
