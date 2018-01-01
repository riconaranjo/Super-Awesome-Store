------------------------------------
Store App with JSON Parsing Notes
------------------------------------

This is an app I made for the Mobile Developer Intern at Shopify. It takes products stored as JSON objects and displays each product in a table view.

____________________________________
JSON Parsing using Swift 4

Swift 4 introuduced the ability to use *JSONDecoder*. This is much simpler than using Serializable or third party libraries.


###URLSession

In order to use *JSONDecoder* from a url you need to first make sure the url is valid, so you can use a let guard statement when creating the URL object.

```swift
guard let url = URL(string: productsUrlString)
	else { return }	// quit if failure
```

In order to retrieve data from a url, you can use a *URLSession* as shown below. This function call is asynchronous.

```swift
URLSession.shared.dataTask(with: url) { (data, response, err) in 
    
	if err != nil { print("~Error with URL Session\n"); return }

	guard let data = data
		else { print("~Error retrieving data\n"); return }

	// parse json here

 }.resume()	// this is important
```

Once the json data is parsed, the *TableView* needs to be updated with the new data. Since the *URLSession* is asynchronous, the reloadData command needs to be given with *DispathQueue.main.asynch* in order to run it on the main thread.

```swift
// reload table view
DispatchQueue.main.async{
    self.tableView.reloadData()
}

```

###JSONDecoder

With swift 4 came the introduction of *JSONDecoder*, which allows for native json parsing without the need of third-party libraries, or implementing much code.

In order to use *JSONDecoder*, the json structure of the data can to be implemented using stucts. A list [square brackets] in json is an array of swift structs, and a key-value pair [curly brackets] in json is a swift *struct*.

For example since there are many _Products_ they are represented by a list of type Product:

```swift
struct Products: Decodable {
    var products: [Product]
}
```

Each Product has its own attributes, such as _ID_, _Title_, and _Vendor_; each of these attributes is represented by a simple data type such as *Int*, *Double*, or *String*.

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

These structs should be implemented with the exact same names and data types as the json data, with one root struct, like the Products struct shown above.

Calling the decoder is very simple simply done with one line, withing a do-catch block:

```swift
do {
    // retrieve json data from url
    let data = try JSONDecoder().decode(Products.self, from: data)
    self.data = data 	// store the data
}
catch let jsonErr {
    print("~Error decoding json with message:\n", jsonErr)
}

```






