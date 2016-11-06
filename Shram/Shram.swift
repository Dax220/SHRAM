import Foundation

public let Shram = ShramManager()

open class ShramManager: NSObject
{
    //MARK: - POST Method
    /**
     Sends POST request to server

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
     
     - parameter URL: String value of API method.
     - parameter params: Dictionary where the key is a server parameter and value is the parameter that should be sent.
     - parameter contentType: There are three content types supported:
        * application/json (.JSON)
        * application/x-www-form-urlencoded (.URLENCODED)
        * multipart/form-data (.MULTIPART_FORM_DATA)
     - parameter headers: Dictionary with HTTP Headers.
     - parameter mapTo: Type of object you want to get. This type should implements ShramMappingProtocol.
     - parameter withParseKeys: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
     
            {
                "data" : 
                            {
                                "name": "userName",
                                "age": "userAge"
                            }
            }
     
        for getting needed data and map it to your class you need to set
     
            withParseKeys: ["data"]
     
     - parameter completion: Closure is called when server has responded successfully.
     
     Returns:
        * request: *ShramRequest*
        * data: *Data?*
        * response: *ShramResponse?*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
     Returns:
        * request: *ShramRequest*
        * error: *Error?*
        * response: *ShramResponse?*
     - returns: Instance of URLSessionDataTask.
     */
    @discardableResult
    open func POST
        (_ URL: String,
         params: [String: AnyObject]?,
         contentType: ContentType,
         headers: [String: String]? = nil,
         mapTo: ShramMappingProtocol.Type? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDataTask
    {
        let request = ShramRequest(URL: URL, method: Method.POST, params: params, contentType: contentType, headers: headers, mapTo: mapTo, parseKeys: parseKeys)
        let dataTask = ShramDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
        return dataTask
    }
    
    //MARK: - GET Method
    /**
     Sends GET request to server
     
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
     
     - parameter URL: String value of API method.
     - parameter params: Dictionary where the key is a server parameter and value is the parameter that should be sent.
     - parameter headers: Dictionary with HTTP Headers.
     - parameter mapTo: Type of object you want to get. This type should implements ShramMappingProtocol.
     - parameter withParseKeys: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
     
            {
                "data" :
                            {
                                "name": "userName",
                                "age": "userAge"
                            }
            }
     
       for getting needed data and map it to your class you need to set
     
            withParseKeys: ["data"]
     
     - parameter completion: Closure is called when server has responded successfully.
     
     Returns:
        * request: *ShramRequest*
        * data: *Data?*
        * response: *ShramResponse?*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
     Returns:
        * request: *ShramRequest*
        * error: *Error?*
        * response: *ShramResponse?*
     - returns: Instance of URLSessionDataTask.
     */
    @discardableResult
    open func GET
        (_ URL: String,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         mapTo: ShramMappingProtocol.Type? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDataTask
    {
        let request = ShramRequest(URL: URL, method:  Method.GET, params: params, headers: headers, mapTo: mapTo, parseKeys: parseKeys)
        let dataTask = ShramDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
        return dataTask
    }
    
    //MARK: - PUT Methods
    /**
     Sends PUT request to server
     
            Shram.PUT("http://www.sample.com/api/method",
                      params: params,
                      contentType: .JSON,
                      headers:headers,
                      mapTo: Type,
                      withParseKeys: ["firstKey", "secondKey", ...],
                      completion: { (request, data, response) in
     
                 },
                      failure: { (request, error, response) in
     
                 }
             )

     - parameter URL: String value of API method.
     - parameter params: Dictionary where the key is a server parameter and value is the parameter that should be sent.
     - parameter contentType: There are three content types supported:
        * application/json (.JSON)
        * application/x-www-form-urlencoded (.URLENCODED)
        * multipart/form-data (.MULTIPART_FORM_DATA)
     - parameter headers: Dictionary with HTTP Headers.
     - parameter mapTo: Type of object you want to get. This type should implements ShramMappingProtocol.
     - parameter withParseKeys: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
     
            {
                "data" :
                            {
                                "name": "userName",
                                "age": "userAge"
                            }
            }
     
        for getting needed data and map it to your class you need to set
     
            withParseKeys: ["data"]
     
     - parameter completion: Closure is called when server has responded successfully.
     
     Returns:
        * request: *ShramRequest*
        * data: *Data?*
        * response: *ShramResponse?*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
     Returns:
        * request: *ShramRequest*
        * error: *Error?*
        * response: *ShramResponse?*
     - returns: Instance of URLSessionDataTask.
     */
    @discardableResult
    open func PUT
        (_ URL: String,
         params: [String: AnyObject]?,
         contentType: ContentType,
         headers: [String: String]? = nil,
         mapTo: ShramMappingProtocol.Type? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDataTask
    {
        let request = ShramRequest(URL: URL, method: Method.PUT, params: params, contentType: contentType, headers: headers, mapTo: mapTo, parseKeys: parseKeys)
        let dataTask = ShramDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
        return dataTask
    }
    
    //MARK: - DELETE Method
    /**
     Sends DELETE request to server
     
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
     
     - parameter URL: String value of API method.
     - parameter params: Dictionary where the key is a server parameter and value is the parameter that should be sent.
     - parameter headers: Dictionary with HTTP Headers.
     - parameter mapTo: Type of object you want to get. This type should implements ShramMappingProtocol.
     - parameter withParseKeys: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
     
            {
                "data" :
                            {
                                "name": "userName",
                                "age": "userAge"
                            }
            }
     
        for getting needed data and map it to your class you need to set
     
            withParseKeys: ["data"]
     
     - parameter completion: Closure is called when server has responded successfully.
     
     Returns:
        * request: *ShramRequest*
        * data: *Data?*
        * response: *ShramResponse?*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
     Returns:
        * request: *ShramRequest*
        * error: *Error?*
        * response: *ShramResponse?*
     - returns: Instance of URLSessionDataTask.
     */
    @discardableResult
    open func DELETE
        (_ URL: String,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         mapTo: ShramMappingProtocol.Type? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDataTask
    {        
        let request = ShramRequest(URL: URL, method:  Method.DELETE, params: params, headers: headers, mapTo: mapTo, parseKeys: parseKeys)
        let dataTask = ShramDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
        return dataTask
    }
    
    //MARK: - Upload File
    /**
     Uploads file to server.
     
            Shram.uploadWithProgress("http://www.sample.com/api/method",
                                     params: params,
                                     headers: headers,
                                     completion: {
     
                 }
                                     progress: { (bytesSent, totalBytesSent, totalBytesExpectedToSend, response) in
     
     
                 },
                                     failure: { (request, error, response) in
     
                 }
             )
     
     - parameter URL: String value of API method.
     - parameter params: Dictionary where the key is a server parameter and value is the parameter that should be sent.
     - parameter headers: Dictionary with HTTP Headers.
     - parameter completion: Closure is called when data was successfully uploaded.
     
        Returns:
        * request: *ShramRequest*
        * data: *Data?*
        * response: *ShramResponse?*
     - parameter progress: Closure is called each time data sends to server.
     
        Returns:
        * bytesSent: *Int64*
        * totalBytesSent: *Int64*
        * totalBytesExpectedToSend: *Int64*
        * response: *ShramResponse*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
        Returns:
        * request: *ShramRequest*
        * error: *Error?*
        * response: *ShramResponse?*
     - returns: Instance of URLSessionUploadTask.
     */
    @discardableResult
    open func uploadWithProgress
        (_ URL: String,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         completion: @escaping UploadCompletion,
         progress: @escaping ProgressCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionUploadTask
    {
        let request = ShramRequest(URL: URL, method: Method.POST, params: params, contentType: .multipart_form_data, headers: headers)
        let uploadTask = ShramDataTaskManager.createUploadTaskWithRequest(request: request, completion: completion, progress: progress, failure: failure)
        uploadTask.resume()
        return uploadTask
    }
    
    //MARK: - Download File
    /**
     Downloads file from server.
     
            Shram.downloadWithProgress("http://www.sample.com/api/method",
                                       params: params,
                                       headers: headers,
                                       completion: { (didFinishDownloadingToURL) in
     
                 },
                                       progress: { (bytesSent, totalBytesSent, totalBytesExpectedToSend, response) in
     
                 },
                                       failure: { (request, error, response) in
    
                 }
            )
     
     - parameter URL: String value of API method.
     - parameter params: Dictionary where the key is a server parameter and value is the parameter that should be sent.
     - parameter headers: Dictionary with HTTP Headers.
     - parameter completion: Closure is called when data was downloaded.
     
        Returns:
        * request: *ShramRequest*
        * data: *Data?*
        * response: *ShramResponse?*
     - parameter progress: Closure is called each time data comes from server.
     
        Returns:
        * bytesSent: *Int64*
        * totalBytesSent: *Int64*
        * totalBytesExpectedToSend: *Int64*
        * response: *ShramResponse*
     - parameter failure: Closure is called when request is failed or server has responded with an error.

        Returns:
        * request: *ShramRequest*
        * error: *Error?*
        * response: *ShramResponse?*
     - returns: Instance of URLSessionDownloadTask.
     */
    @discardableResult
    open func downloadWithProgress
        (_ URL: String,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         completion: @escaping DownloadCompletion,
         progress: @escaping ProgressCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDownloadTask
    {
        let request = ShramRequest(URL: URL, method: Method.GET, params: params, contentType: .multipart_form_data, headers: headers)
        let downloadTask = ShramDataTaskManager.createDownloadTaskWithRequest(request: request, completion: completion, progress: progress, failure: failure)
        downloadTask.resume()
        return downloadTask
    }
}

