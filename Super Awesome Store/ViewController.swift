//
//  ViewController.swift
//  Super Awesome Store
//
//  Created by Federico Naranjo Bellina on 25/12/17.
//  Copyright © 2017 Federico Naranjo Bellina. All rights reserved.
//

import UIKit

struct Products: Decodable {
    var products: [Product]
}

struct Product: Decodable {
    let id: Int?
    let title: String?
    let body_html: String?
    let vendor: String?
    let product_type: String?
    let created_at: String?
    let handle: String?
    let updated_at: String?
    let published_at: String?
    let template_suffix: String?
    let published_scope: String?
    let tags: String?
    let variants: [Variant]?
    let options: [Options]?
    let images: [Image]?
    let image: Image?
}

struct Variant: Decodable {
    let id: Int?
    let product_id: Int?
    let title: String?
    let price: String? // convert to double?
    let sku: String?
    let position: Int?
    let inventory_policy: String?
    let compare_at_price: Int?
    let fulfillment_service: String?
    let inventory_management: String?
    let optional1: String?
    let optional2: String?
    let optional3: String?
    let created_at: String?
    let updated_at: String?
    let taxable: Bool?
    let barcode: String?
    let grams: Int?
    let image_id: String?
    let inventory_quality: Int?
    let weight: Double?
    let weight_unit: String?
    let inventory_item_id: Int?
    let old_inventory_quantity: Int?
    let requires_shipping: Bool?
}

struct Options: Decodable {
    let id: Int?
    let product_id: Int?
    let name: String?
    let position: Int?
    let values: [String]?
}

struct Image: Decodable {
    let id: Int?
    let product_id: Int?
    let position: Int?
    let created_at: String?
    let updated_at: String?
    let width: Int?
    let height: Int?
    let src: String?
    let variant_ids: [String]?
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var data: Products?
    let list = ["first", "second", "third"]
    @IBOutlet weak var TableView: UITableView!
    
    // how many rows
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = data?.products != nil ? (data?.products.count)! : 0
        return count
    }
    
    // what is in each cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = data?.products[indexPath.row].title
        
        return cell
    }
    
    // when cell is pressed
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate produts array
        data?.products.removeAll()
        // url for products as json objects
        let productsUrlString = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        
        // if not a valid url, quit
        guard let url = URL(string: productsUrlString)
            else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if err != nil { print("~Error with URL Session\n"); return }
            
            guard let data = data
                else { print("~Error retrieving data\n"); return }
            
            do {
                // retrieve json data from url
                let data = try JSONDecoder().decode(Products.self, from: data)
                self.data = data
            }
            catch let jsonErr {
                print("~Error decoding json with message:\n", jsonErr)
            }
            
            // reload table view
            DispatchQueue.main.async{
                self.TableView.reloadData()
            }
            
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

