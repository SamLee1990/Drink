//
//  InputTableViewController.swift
//  Drink
//
//  Created by 李世文 on 2020/8/18.
//

import UIKit
import Foundation

class InputTableViewController: UITableViewController {
    
    var menu: Menu!
    
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var sugarButton: UIButton!
    @IBOutlet weak var iceButton: UIButton!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var bubbleSwitch: UISwitch!
    @IBOutlet weak var lodingActivityIndicator: UIActivityIndicatorView!
    
    
    let sugars = ["多糖","正常糖","少糖","半糖","微糖","無糖"]
    let ices = ["多冰","正常冰","少冰","微冰","去冰","完全去冰"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = menu.name
        introductionLabel.text = menu.introduction
        
        if let image = UIImage(named: menu.name) {
            drinkImage.image = image
        }else{
            drinkImage.image = UIImage(named: "可不可")
        }
        
        priceLabel.text = "$" + String(menu.priceMiddle)
        totalPriceLabel.text = "$" + String(menu.priceMiddle)
        
        if menu.name.contains("薑"){
            let controller = UIAlertController(title: "熱飲停售", message: "請等待天氣變涼，謝謝", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                self.navigationController?.popViewController(animated: true)
            }
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func sugarChoice(_ sender: UIButton) {
        let controller = UIAlertController(title: "甜度", message: "選擇想要的甜度", preferredStyle: .actionSheet)
        
        for sugar in sugars {
            let action = UIAlertAction(title: sugar, style: .default) { (action) in
                self.sugarButton.setTitle(action.title, for: .normal)
                self.sugarButton.setTitleColor(UIColor(red: 79/255, green: 101/255, blue: 142/255, alpha: 1), for: .normal)
                self.sugarButton.backgroundColor = UIColor(red: 226/255, green: 236/255, blue: 1, alpha: 1)
            }
            controller.addAction(action)
        }
        present(controller, animated: true, completion: nil)

    }
    
    
    @IBAction func iceChoice(_ sender: UIButton) {
        let controller = UIAlertController(title: "冰塊", message: "選擇想要的冰塊比例", preferredStyle: .actionSheet)
        
        for ice in ices{
            let action = UIAlertAction(title: ice, style: .default) { (action) in
                self.iceButton.setTitle(action.title, for: .normal)
                self.iceButton.setTitleColor(UIColor(red: 79/255, green: 101/255, blue: 142/255, alpha: 1), for: .normal)
                self.iceButton.backgroundColor = UIColor(red: 226/255, green: 236/255, blue: 1, alpha: 1)
            }
            controller.addAction(action)
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func sizeChoice(_ sender: UISegmentedControl) {
        if menu.priceLarge == 0{
            inputCheck(str: "無大杯")
            sender.selectedSegmentIndex = 0
        }
        
        if sender.selectedSegmentIndex == 0{
            priceLabel.text = "$" + menu.priceMiddle.description
            if bubbleSwitch.isOn{
                totalPriceLabel.text = "$" + (menu.priceMiddle + 10).description
            }else{
                totalPriceLabel.text = "$" + menu.priceMiddle.description
            }
        }else{
            priceLabel.text = "$" + menu.priceLarge.description
            if bubbleSwitch.isOn{
                totalPriceLabel.text = "$" + (menu.priceLarge + 10).description
            }else{
                totalPriceLabel.text = "$" + menu.priceLarge.description
            }
        }
    }
    
    
    @IBAction func addBubble(_ sender: UISwitch) {
        let size =  sizeSegment.selectedSegmentIndex
        if sender.isOn {
            if size == 0{
                totalPriceLabel.text = "$" + (menu.priceMiddle + 10).description
            }else{
                totalPriceLabel.text = "$" + (menu.priceLarge + 10).description
            }
        }else{
            if size == 0 {
                totalPriceLabel.text = "$" + menu.priceMiddle.description
            }else{
                totalPriceLabel.text = "$" + menu.priceLarge.description
            }
        }
    }
    
    //送出訂單
    @IBAction func submitOrder(_ sender: Any) {
        
        guard let userName = userNameTextField.text, userName != "" else {
            inputCheck(str: "輸入 訂購人")
            return
        }
        guard let sugar = sugarButton.currentTitle, sugar != "請選擇" else {
            inputCheck(str: "選擇 甜度")
            return
        }
        guard let ice = iceButton.currentTitle, ice != "請選擇" else {
            inputCheck(str: "選擇 冰塊")
            return
        }
        guard sizeSegment.selectedSegmentIndex == 0 else {
            inputCheck(str: "大杯")
            return
        }
        
        let url = URL(string: "https://sheetdb.io/api/v1/mgtr0yu7o3m2n")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let id = UUID().uuidString
        let drinkName = menu.name
        let size = sizeSegment.titleForSegment(at: sizeSegment.selectedSegmentIndex) ?? ""
        let bubble = bubbleSwitch.isOn.description
        var totalPrice = totalPriceLabel.text ?? ""
        totalPrice.removeFirst()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd,HH:mm:ss"
        let dateStr = dateFormatter.string(from: date)
        
        let order = Order(id: id, userName: userName, drinkName: drinkName, sugar: sugar, ice: ice, size: size, bubble: bubble, totalPrice: totalPrice, date: dateStr)
        let orderData = OrderData(data: order)
        let encode = JSONEncoder()
        do {
            let data = try encode.encode(orderData)
            lodingActivityIndicator.startAnimating()
            URLSession.shared.uploadTask(with: request, from: data) { (retData, response, error) in
                let decode = JSONDecoder()
                if let retData = retData{
                    do{
                        let dic = try decode.decode([String:Int].self, from: retData)
                        if dic["created"] == 1{
                            print("上傳成功")
                            DispatchQueue.main.async {
                                self.lodingActivityIndicator.stopAnimating()
                            }
                            self.submitSuccess(order: order)
                        }else{
                            print("上傳失敗", dic)
                            DispatchQueue.main.async {
                                self.lodingActivityIndicator.stopAnimating()
                            }
                        }
                    }catch{
                        print(error)
                    }
                }
            }.resume()
        } catch  {
            print(error)
        }
        
    }
    
    //收鍵盤
    @IBAction func tableTap(_ sender: Any) {
        view.endEditing(true)
    }
    //收鍵盤
    @IBAction func dismissKeyboard(_ sender: Any) {
    }
    
    //送出成功
    func submitSuccess(order: Order) {
        var bubble = ""
        if order.bubble == "true"{
            bubble = " 加珍珠,"
        }
        let controller = UIAlertController(title: "訂購成功", message: "\(order.size) \(order.drinkName),\(bubble) \(order.sugar), \(order.ice)", preferredStyle: .alert)
        let okActon = UIAlertAction(title: "OK", style: .default) { (okAction) in
            //前往訂單
            self.navigationController?.popViewController(animated: true)
            
        }
        controller.addAction(okActon)
        
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //欄位檢核
    func inputCheck(str: String){
        
        var title = "輸入不完全"
        var message = "請\(str)"
        if str == "大杯"{
            title = "大杯停售"
            message = "目前全品項不提供大杯，謝謝"
        }else if str == "無大杯"{
            title = "限中杯"
            message = "此品項無提供大杯"
        }
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
