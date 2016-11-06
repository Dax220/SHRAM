# **Shram** #
## Simple Http Requests And Mapping ##

Shram - is easy to use but powerful framework for communication with RESTful web services via HTTP requests. Shram will help you to send a request to a server in just a few lines of code. The main advantage of this framework is clarity and easy of use. But this is not all the features of Shram. Shram supports mapping objects from the server response. Thus, you can easily query the server for any data and use it now as ready-made objects. But you don't need to build them by hand. Shram will do it for you. More information about it you will find below.

## **Supported platforms** ##
- IOS
## **How to install** ##

## **How it works** ##
As mentioned above Shram is very simple to use. Let's sort it out.

You can create object of ShramRequest
```
var request = ShramRequest(URL: "http://www.sample.com/api/method", method: "GET")
```
Then you can set the following parameters:

* **parameters**: [String : AnyObject]?
* **headers**: [String : String]?
* **mapTo**: ShramMappingProtocol.Type?
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
          mapTo: Type,
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
* **mapTo**: Type of object you want to get. This type should implements ShramMappingProtocol.
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

As you can see "params", "headers", "mapTo", "withParseKeys" are optional and you don't need to pass it to function without the need.

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
           mapTo: Type,
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
          mapTo: Type,
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
             mapTo: Type,
             withParseKeys: ["firstKey", "secondKey", ...],
             completion: { (request, data, response) in
                        
     },
             failure: { (request, error, response) in
     }
)
```

## **Mapping** ##

Shram doesn't only get a response from the server, but also creates model instances. To achieve it you need pass type of your model in 'mapTo' parameter. You model should implements ShramMappingProtocol protocol.

Let's try to get users from server and map response to Person model.

##Response:##
```
{
    data: [
        {
            name: "John",
            last_name: "Doe",
            age: "30",
            gender: "male"
        },
        {
            name: "sarah",
            last_name: "Doe",
            age: "25",
            gender: "female"
         }
    ]
}
```

##Our model:##
```
class Person: NSObject, ShramMappingProtocol
{
    var name: String?
    var lastName: String?
    var age: NSNumber?
    var gender: String?
    
    required override init() {
        super.init()
        setAssociation(serverKey: "name", propertyName: "name")
        setAssociation(serverKey: "last_name", propertyName: "lastName")
        setAssociation(serverKey: "age", propertyName: "age")
        setAssociation(serverKey: "gender", propertyName: "gender")
    }
}
```
##Method GET:##
```
Shram.GET("http://www.sample.com/api/method",
          mapTo: Person.self,
          withParseKeys: ["data"],
          completion: { (request, data, response) in
             let users = response?.mapings
     },
          failure: { (request, error, response) in
            
     }
)
```

As you can see our model implements ShramMappingProtocol and now it has `setAssociation` function. This function establishes a link between model property and key in response. Created model objects are available in response property `mapings`.
Also it supports nested objects. For this purpose you need use 
```
setRelatedAssociation(serverKey: "server_key", 
                      propertyName: "modelPropertyName", 
                      relatedClass: Type)
``` 
relatedClass should implements ShramMappingProtocol and `init` should be overridden similar Person model above.

##Restrictions for nested objects:##
Your model structure should be same object in response. 
This issue will be resolved soon.