//
//  ViewController.swift
//  ThoughtWorks
//
//  Created by Rohit Kumar on 29/06/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addtocartView: UIView!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var activityIndiator: UIActivityIndicatorView!
    var count : Int = 1
    var beers = [BeerDescription]()
    var filteredBeers = [BeerDescription]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredBeers.count
        }else{
            return beers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BeerCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BeerCell
        let beer: BeerDescription
        if indexPath.row%2 == 0 {
            cell.contentView.backgroundColor = UIColor(red:0.67, green:0.97, blue:0.80, alpha:CGFloat(1))
        }else{
            cell.contentView.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:CGFloat(1))
        }
        
        if isFiltering(){
            beer = filteredBeers[indexPath.row]
        }else{
            beer = beers[indexPath.row]
        }
        cell.name?.text = beer.name
        cell.des1?.text = String(format: "Alcohol Content: %@", beer.abv)
        cell.des2?.text = beer.style
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let buy = UITableViewRowAction(style: .normal, title: "Buy") { (action, indexPath) in
            self.addBeer(index: indexPath.row)
        }
        return [buy]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSeacrhText(searchController.searchBar.text!)
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterContentForSeacrhText(_ searchText : String, scope: String = "All") {
        filteredBeers = beers.filter({( beer : BeerDescription) -> Bool in
            return beer.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Beer"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
        activityIndiator.startAnimating()
        Service.sharedInstance.fetchingData { (data) in
//            print("****Here comes completion block ------->  ", data)
            self.beers = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndiator.stopAnimating()
            }
        }
    }
    var selectedBeerId = 0
    func addBeer(index: Int){
        count = 1
        countLbl.text = "\(count)"
        view.bringSubview(toFront: addtocartView)
        selectedBeerId = beers[index].id
    }
    
    @IBAction func addToCart(){
        view.sendSubview(toBack: addtocartView)
        let obj = Cart(beerId: beers[selectedBeerId].id, qty: count)
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "cart") == nil){
            defaults.setValue([], forKey: "cart")
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(obj) {
            var arr = defaults.object(forKey: "cart") as! Array<Any>
            arr.append(encoded)
            defaults.setValue(arr, forKey: "cart")
        }
        
    }
    
    @IBAction func closeCart(){
        view.sendSubview(toBack: addtocartView)
    }
    
    @IBAction func increaseCount(){
        count=count+1
        countLbl.text = "\(count)"
    }
    
    @IBAction func decreaseCount(){
        if(count>0){
            count=count-1
        }
        countLbl.text = "\(count)"
    }
    
    @IBAction func gotoCart(){
        let cartVC = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        cartVC.beers = beers
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class BeerCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var des1: UILabel!
    @IBOutlet var des2 : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
}
