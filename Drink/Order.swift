//
//  Order.swift
//  Drink
//
//  Created by 李世文 on 2020/8/20.
//

import Foundation

struct Order: Codable {
    var id: String
    var userName: String
    var drinkName: String
    var sugar: String
    var ice: String
    var size: String
    var bubble: String
    var totalPrice: String
    var date: String

    
    //DELETE https://sheetdb.io/api/v1/mgtr0yu7o3m2n/{column}/{value}
    static func deleteToDB(id:String){
        guard let url = URL(string: "https://sheetdb.io/api/v1/mgtr0yu7o3m2n/id/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (retData, response, error) in
            if let retData = retData{
                do{
                    let dic = try JSONDecoder().decode([String: Int].self, from: retData)
                    print("deleted = ",dic["deleted"] ?? "找不到“deleted“")
                }catch{
                    print(error)
                }
            }
        }.resume()

    }
    
}

struct OrderData: Codable {
    var data: Order
}

