//
//  Menu.swift
//  Drink
//
//  Created by 李世文 on 2020/8/18.
//

import Foundation

struct Menu: Decodable {
    let name: String
    let introduction: String
    let priceMiddle: Int
    let priceLarge: Int
}

