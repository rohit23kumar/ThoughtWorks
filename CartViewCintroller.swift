//
//  CartViewCintroller.swift
//  ThoughtWorks
//
//  Created by Rohit Kumar on 01/07/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import UIKit

struct Cart: Codable {
    let beerId: Int
    let qty: Int
}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var cartArr = [Cart]()
    var beers = [BeerDescription]()
    var selectedBeers = [BeerDescription]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartCell
        cell.beerName.text = selectedBeers[indexPath.row].name
        cell.quantity.text = "Quantity: \(cartArr[indexPath.row].qty)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let buy = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            self.deleteBeer(index: indexPath.row)
        }
        return [buy]
    }
    
    func deleteBeer(index: Int) {
        print(index)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let dataArr = defaults.object(forKey: "cart") as? [Data] {
            let decoder = JSONDecoder()
            for obj in dataArr{
                if let cart = try? decoder.decode(Cart.self, from: obj) {
                    cartArr.append(cart)
                }
            }
        }
        for obj in beers{
            for obj2 in cartArr{
                if (obj2.beerId == obj.id){
                    selectedBeers.append(obj)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class CartCell: UITableViewCell {
    @IBOutlet var beerName : UILabel!
    @IBOutlet var quantity : UILabel!
    
    
}


