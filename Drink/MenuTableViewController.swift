//
//  MenuTableViewController.swift
//  Drink
//
//  Created by 李世文 on 2020/8/18.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menu = [Menu]()
    var hotDrinks = [Menu]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取的 plist 資料
        let url = Bundle.main.url(forResource: "Menu", withExtension: "plist")!
        
        if let data = try? Data(contentsOf: url),
           let menu = try? PropertyListDecoder().decode([Menu].self, from: data){
            self.menu = menu
        }
        //取得熱飲資料（可不可專用！）
        for drink in menu {
            if drink.name.contains("薑"){
                hotDrinks.append(drink)
            }
        }

    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return menu.count - hotDrinks.count
        }else{
            return hotDrinks.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell

        cell.update(with: menu[indexPath.row])
        if indexPath.section == 0 {
            cell.update(with: menu[indexPath.row])
        }else{
            cell.update(with: hotDrinks[indexPath.row])
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "冷飲"
        }else{
            return "熱飲"
        }
    }
    
    @IBSegueAction func showInput(_ coder: NSCoder) -> InputTableViewController? {
        
        let controller = InputTableViewController(coder: coder)
        let row = tableView.indexPathForSelectedRow?.row
        let section = tableView.indexPathForSelectedRow?.section
        if let section = section,
           let row = row{
            if section == 0{
                controller?.menu = menu[row]
            }else{
                controller?.menu = hotDrinks[row]
            }
        }
        return controller
    }
    

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
