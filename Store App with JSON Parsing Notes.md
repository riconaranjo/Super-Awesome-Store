------------------------------------
Store App with JSON Parsing Notes
------------------------------------

This is an app I made for the Mobile Developer Intern at Shopify. It takes products stored as JSON objects and displays each product in a table view.

____________________________________
JSON Parsing using Swift 4

Swift 4 introuduced the ability to use JSONDecoder. This is much simpler than using Serializable or third party libraries.

In order to use JSONDecoder from a url you need to first make sure the url is valid, so you can use a let guard statement when creating the URL object.

```swift
guard let url = URL(string: productsUrlString)
	else { return }	// quit if failure
```

In order to retrieve data from a url, you can use a URLSession as shown below. This function call is asynchronous.

```swift
URLSession.shared.dataTask(with: url) { (data, response, err) in 
    
	if err != nil { print("~Error with URL Session\n"); return }

	guard let data = data
		else { print("~Error retrieving data\n"); return }

	// parse json here

 }.resume()
```









