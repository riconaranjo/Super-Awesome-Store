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
    let price: String?
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
    var productImages: [Int: UIImage] = [:]
    @IBOutlet weak var tableView: UITableView!
    
    // how many rows
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = data?.products != nil ? (data?.products.count)! : 0
        return count
    }
    
    // what is in each cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create cell
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        // change colours
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.36, green:0.42, blue:0.42, alpha:1.0)
        cell.selectedBackgroundView = backgroundView
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor(red:0.50, green:0.69, blue:0.57, alpha:1.0)
        cell.backgroundColor = UIColor(red:0.30, green:0.30, blue:0.37, alpha:1.0)
        cell.imageView?.image = UIImage(named: "Icons//placeholder_image")
        cell.textLabel?.text = data?.products[indexPath.row].title
        
        cell.detailTextLabel?.text = vendorText(index: indexPath.row)
        
        // quit if image has already been downloaded
        if let image = productImages[indexPath.row] {
            cell.imageView?.image = image
            return cell
        }

        // else download image
        if let url = URL(string: (data?.products[indexPath.row].image?.src)!) {

            URLSession.shared.dataTask(with: url) { (data, response, err) in

                if err != nil { print("~Error with URL Session\n"); return }

                guard let data = data
                    else { print("~Error retrieving data\n"); return }

                // save image in dictionary, and display in cell
                DispatchQueue.main.async() {
                    let img = UIImage(data: data)
                    cell.imageView?.image = img
                    self.productImages[indexPath.row] = img
                }
                
            }.resume()
        }
        
        return cell
    }
    
    /// Builds detail text label for tableview cells
    public func vendorText(index: Int) -> String{
        let vendor = data?.products[index].vendor != "" ? "Sold by " + (data?.products[index].vendor)! : ""
        let numVariants = data?.products[index].variants?.count
        let vendorText = "\(vendor) – \(numVariants ?? 1) variants"
        
        return vendorText
    }

    // when cell is pressed
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data?.products.removeAll()       // populate products array
        productImages = [Int: UIImage]() // index and images
        parseJSON()
        
    }
    
    public func parseJSON() {
        
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
                self.tableView.reloadData()
            }
            
        }.resume()
    }
}
