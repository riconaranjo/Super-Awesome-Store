------------------------------------
# Store App with JSON Parsing Notes
------------------------------------

## Table of Contents

**[JSON Parsing using Swift 4](#json-parsing-using-swift-4)**<br>
**[Downloading and Displaying Images](#downloading-and-displaying-images)**<br>
**[Changing Cell Style](#changing-cell-style)**<br>
**[Dark Status Bar](#dark-status-bar)**<br>


![AppIcon](/Super%20Awesome%20Store/Icons/Icon-60%403x.png)

This is an app I made for the Mobile Developer Intern at Shopify. It takes products stored as JSON objects and displays each product in a table view.

![ScreenShot](/SuperDuperAwesomeStore.png)
____________________________________
## JSON Parsing using Swift 4

Swift 4 introuduced the ability to use *JSONDecoder*. This is much simpler than using Serializable or third party libraries.


### URLSession

In order to use *JSONDecoder* from a url you need to first make sure the url is valid, so you can use a let guard statement when creating the URL object.

```swift
guard let url = URL(string: productsUrlString)
    else { return } // quit if failure
```

In order to retrieve data from a url, you can use a *URLSession* as shown below. This function call is asynchronous.

```swift
URLSession.shared.dataTask(with: url) { (data, response, err) in 
    
    if err != nil { print("~Error with URL Session\n"); return }

    guard let data = data
        else { print("~Error retrieving data\n"); return }

    // parse json here

 }.resume() // this is important
```

The _guard let_ statements are used to catch any issues with retrieving the data.

Once the json data is parsed, the *TableView* needs to be updated with the new data. Since the *URLSession* is asynchronous, the reloadData command needs to be given with *DispathQueue.main.asynch* in order to run it on the main thread.

```swift
// reload table view
DispatchQueue.main.async{
    self.tableView.reloadData()
}

```

### JSONDecoder

With swift 4 came the introduction of *JSONDecoder*, which allows for native json parsing without the need of third-party libraries, or implementing much code.

In order to use *JSONDecoder*, the json structure of the data can to be implemented using stucts. A list [square brackets] in json is an array of swift structs, and a key-value pair [curly brackets] in json is a swift *struct*.

For example since there are many _Products_ they are represented by a list of type Product:

```swift
struct Products: Decodable {
    var products: [Product]
}
```

Each Product has its own attributes, such as _ID_, _Title_, and _Vendor_; each of these attributes is represented by a primative data-type such as *Int*, *Double*, or *String*, *Bool*, etc..

```swift

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
```

Each attribute has a question mark in order to mark it as an _optional_; this means that if no value is found for this attribute, it will just give it a value of _nil_.

These structs should be implemented with the exact same names and data types as the json data, with one root struct, like the *Products* struct shown above.

Calling the decoder is very simple simply done with one line, within a do-catch block:

```swift
do {
    // retrieve json data from url
    let data = try JSONDecoder().decode(Products.self, from: data)
    self.data = data    // store the data
}
catch let jsonErr {
    print("~Error decoding json with message:\n", jsonErr)
}

```

____________________________________
## Downloading and Displaying Images

Each product has an a main image, and an array of images; for the table view, the main image is displayed at the right of each cell.

![Cell](/cell.png)

Each image needs to be downloaded and stored so it is not downloaded everytime the view is refreshed. This is done using a *Dictionary* of *UIImages* with the product index.

```swift
productImages = [Int: UIImage]() // index and images
```

In the json structure, each image has a source url where the image can be downloaded from. In order to download these, a *URLSession* is used in the same way as for retrieving the json data. Here a session is started for each image at the same time as the cell is populated with the Product title, vendor, and number of variants.

When the image is retrieved, it is both loaded onto the table view cell and stored in the _productImages_ dictionary along with the index of the cell.

```swift
if let url = URL(string: (data?.products[indexPath.row].image?.src)!) {

    URLSession.shared.dataTask(with: url) { (data, response, err) in

        if err != nil { print("~Error with URL Session\n"); return }

        guard let data = data
            else { print("~Error retrieving data\n"); return }

        // save image in dictionary, and display in cell
        DispatchQueue.main.async() {
            let img = UIImage(data: data)
            cell.imageView?.image = img                 // load image onto cell
            self.productImages[indexPath.row] = img     // store image
        }
        
    }.resume()
}
```
Now each time the table view is refreshed, the image will be retrieved from the dictionary and amounts to significant increase in performance.

Additionally, a placeholder image can be used to render the *ImageView* in the cell, also increases the loading time of the images in the application.

```swift
cell.imageView?.image = UIImage(named: "Icons//placeholder_image")
```

____________________________________
## Changing Cell Style

In order to change the cell style [without creating a custom *UITableViewCellStyle*], you must change the attributes for the cell on creation. This is done in the _cellForRowAt_ function shown below:

```swift
public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // create cell
    let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")

    // modify cell here

    return cell
}
```

Each attribute of the *UITableViewCell* can be modified through here, such as the main text (*textLabel*) subtitle (*detaileTextLabel*), background colour (*backgroundColor*), etc.

These are all straightforward, except for the selected background colour; A *UIView* needs to be created, and have its b*ackgroundColour* modified to the desired selected background colour. An ezxample of this is shown below:

```swift
let backgroundView = UIView()
backgroundView.backgroundColor = UIColor(red:0.36, green:0.42, blue:0.42, alpha:1.0)
cell.selectedBackgroundView = backgroundView
```

____________________________________
## Dark Status Bar

### AppDelegate.swift

Since for this app I chose a dark colour scheme, the status bar has to be modified from the default black on white. This is done in the _AppDelegate_ file, by adding the following line in the _didFinishLaunchingWithOptions_ function, shown below:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // since dark theme status bar
    UIApplication.shared.statusBarStyle = .lightContent
    
    return true
}
```

### Info.plist

In addition, a boolean roperty needs to be added to the _Info.plist_ file. This allows for the status bar to be modified for the entire application, not just per view controller [even though this application only has the one view].

```
View controller-based status bar appearance, Boolean, NO
```