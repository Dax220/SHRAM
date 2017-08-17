# **Shram** #
## Simple Http Requests ##

Shram - is easy to use but powerful framework for communication with RESTful web services via HTTP requests. Shram will help you send a request to a server in just a few lines of code. The main advantage of this framework is clarity and easy of use.

## **Supported platforms** ##
- IOS

## **How to install** ##
Using cocoapods you need to write ``` pod ’Shram’, '0.1.1’ ``` in you podfile

## **How it works** ##
As mentioned above Shram is very simple to use. Let's sort it out.

You can create object of ShramRequest
```
var request = ShramRequest(URL: "http://www.sample.com/api/method", method: "GET")
```
Then you can set the following parameters:

* **parameters**: [String : AnyObject]?
* **headers**: [String : String]?
* **parseKeys**: [String]?
* **contentType**: ContentType?
* **timeOut**: TimeInterval //default value is 30.0

For sending request you can use method:

```send(completion, failure)``` for general requests

```download(completion, progress, failure)``` for downloading requests with progress

```upload(completion, progress, failure)``` for uploading requests with progress

For example:

```
let params = [
        "someKey" : "someValue"
    ]

var request = ShramRequest(URL: "http://www.sample.com/api/method", method: "GET")
request.parameters = params as [String : AnyObject]?
req.send(completion: { (req, data, resp) in
            
}) { (req, err, resp) in
            
}

```


#Another way#

###**Method GET**###

**To send simple GET request you need to write the following:**
```
Shram.GET("http://www.sample.com/api/method",
          completion: { (request, data, response) in
            
     },
          failure: { (request, error, response) in
     }
)
```

Really easy. But what if we want to pass some parameters or headers? Since Swift allows to set default values for the function parameters you don't need to looking for other methods for it. The full version of GET method looks as follows:
```
Shram.GET("http://www.sample.com/api/method",
          params: params,
          headers: headers,
          withParseKeys: ["firstKey", "secondKey", ...],
          completion: { (request, data, response) in
     
     },
          failure: { (request, error, response) in
     
     }
)
```

Let's look at the parameters:

* **URL**: String value of API method.
* **params**: Dictionary where the key is a server parameter and value is the parameter that should be sent. 
* **headers**: Dictionary with HTTP Headers.
* **withParseKeys**: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
```
{
    "data" : {
        "name": "userName",
        "age": "userAge"
    }
}
```
for getting needed data from response you need to set ```withParseKeys: ["data"]``` as parameter to GET function.

* **completion**: Closure is called when server has responded successfully. Returns:
    * request: ShramRequest
    * data: Data?
    * response: ShramResponse?

* **failure**: Closure is called when request is failed or server has responded with an error. Returns:
    * request: ShramRequest
    * error: Error?
    * response: ShramResponse?

As you can see "params", "headers", "withParseKeys" are optional and you don't need to pass it to function without the need.

###**Method POST**###

Method POST is similar. There are short and full versions:

```
Shram.POST("http://www.sample.com/api/method",
           contentType: contentType,
           completion: { (request, data, response) in
                    
     },
           failure: { (request, error, response) in
            
     }
)

Shram.POST("http://www.sample.com/api/method",
           params: params,
           contentType: contentType,
           headers: headers,
           withParseKeys: ["firstKey", "secondKey", ...],
           completion: { (request, data, response) in
     
     },
           failure: { (request, error, response) in
     
     }
)
```

In this method you can see new parameter:

* **contentType**: There are three content types supported:
    * application/json (.JSON)
    * application/x-www-form-urlencoded (.URLENCODED)
    * multipart/form-data (.MULTIPART_FORM_DATA)

###**Method PUT**###

```
Shram.PUT(http://www.sample.com/api/method,
          params: params,
          contentType: contentType,
          completion: { (request, data, response) in
                    
     },
          failure: { (request, error, response) in
     }
)

Shram.PUT(http://www.sample.com/api/method,
          params: params,
          contentType: contentType,
          headers: headers,
          withParseKeys: ["firstKey", "secondKey", ...],
          completion: { (request, data, response) in
                    
    },
         failure: {(request, error, response) in
    }
)
```

###**Method DELETE**###
```
Shram.DELETE("http://www.sample.com/api/method",
             completion: { (request, data, response) in
                        
     },
             failure: { (request, error, response) in
     }
)

Shram.DELETE("http://www.sample.com/api/method",
             params: params,
             headers: headers,
             withParseKeys: ["firstKey", "secondKey", ...],
             completion: { (request, data, response) in
                        
     },
             failure: { (request, error, response) in
     }
)
```
