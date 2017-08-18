import Foundation

public let SwiftyHttp = SwiftyHttpManager()

open class SwiftyHttpManager: NSObject
{
    //MARK: - POST Method
    /**
     Sends POST request to server

            SwiftyHttp.POST("http://www.sample.com/api/method",
                       params: params,
                       contentType: contentType,
                       headers: headers,
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
     - parameter withParseKeys: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
     
            {
                "data" : 
                            {
                                "name": "userName",
                                "age": "userAge"
                            }
            }
     
        for getting needed data you need to set
     
            withParseKeys: ["data"]
     
     - parameter completion: Closure is called when server has responded successfully.
     
     Returns:
        * request: *SHRequest*
        * data: *Data?*
        * response: *SHResponse?*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
     Returns:
        * request: *SHRequest*
        * error: *Error?*
        * response: *SHResponse?*
     - returns: Instance of URLSessionDataTask.
     */
    @discardableResult
    open func POST
        (_ URL: String,
         params: [String: AnyObject]?,
         contentType: ContentType,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDataTask {
            
        let request = SHRequest(URL: URL, method: Method.POST, params: params, contentType: contentType, headers: headers, parseKeys: parseKeys)
        let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
            
        return dataTask
    }
    
    //MARK: - GET Method
    /**
     Sends GET request to server
     
            SwiftyHttp.GET("http://www.sample.com/api/method",
                      params: params,
                      headers: headers,
                      withParseKeys: ["firstKey", "secondKey", ...],
                      completion: { (request, data, response) in
     
                 },
                      failure: { (request, error, response) in
     
                 }
             )
     
     - parameter URL: String value of API method.
     - parameter params: Dictionary where the key is a server parameter and value is the parameter that should be sent.
     - parameter headers: Dictionary with HTTP Headers.
     - parameter withParseKeys: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
     
            {
                "data" :
                            {
                                "name": "userName",
                                "age": "userAge"
                            }
            }
     
       for getting needed data you need to set
     
            withParseKeys: ["data"]
     
     - parameter completion: Closure is called when server has responded successfully.
     
     Returns:
        * request: *SHRequest*
        * data: *Data?*
        * response: *SHResponse?*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
     Returns:
        * request: *SHRequest*
        * error: *Error?*
        * response: *SHResponse?*
     - returns: Instance of URLSessionDataTask.
     */
    @discardableResult
    open func GET
        (_ URL: String,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDataTask {
            
        let request = SHRequest(URL: URL, method:  Method.GET, params: params, headers: headers, parseKeys: parseKeys)
        let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
            
        return dataTask
    }
    
    //MARK: - PUT Methods
    /**
     Sends PUT request to server
     
            SwiftyHttp.PUT("http://www.sample.com/api/method",
                      params: params,
                      contentType: .JSON,
                      headers:headers,
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
     - parameter withParseKeys: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
     
            {
                "data" :
                            {
                                "name": "userName",
                                "age": "userAge"
                            }
            }
     
        for getting needed data you need to set
     
            withParseKeys: ["data"]
     
     - parameter completion: Closure is called when server has responded successfully.
     
     Returns:
        * request: *SHRequest*
        * data: *Data?*
        * response: *SHResponse?*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
     Returns:
        * request: *SHRequest*
        * error: *Error?*
        * response: *SHResponse?*
     - returns: Instance of URLSessionDataTask.
     */
    @discardableResult
    open func PUT
        (_ URL: String,
         params: [String: AnyObject]?,
         contentType: ContentType,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDataTask {
            
        let request = SHRequest(URL: URL, method: Method.PUT, params: params, contentType: contentType, headers: headers, parseKeys: parseKeys)
        let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
            
        return dataTask
    }
    
    //MARK: - DELETE Method
    /**
     Sends DELETE request to server
     
            SwiftyHttp.DELETE("http://www.sample.com/api/method",
                         params: params,
                         headers: headers,
                         withParseKeys: ["firstKey", "secondKey", ...],
                         completion: { (request, data, response) in
     
                 },
                         failure: { (request, error, response) in
     
                 }
            )
     
     - parameter URL: String value of API method.
     - parameter params: Dictionary where the key is a server parameter and value is the parameter that should be sent.
     - parameter headers: Dictionary with HTTP Headers.
     - parameter withParseKeys: String array of keys to parse server response with nested objects. For example server returns data in object with key "data":
     
            {
                "data" :
                            {
                                "name": "userName",
                                "age": "userAge"
                            }
            }
     
        for getting needed data you need to set
     
            withParseKeys: ["data"]
     
     - parameter completion: Closure is called when server has responded successfully.
     
     Returns:
        * request: *SHRequest*
        * data: *Data?*
        * response: *SHResponse?*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
     Returns:
        * request: *SHRequest*
        * error: *Error?*
        * response: *SHResponse?*
     - returns: Instance of URLSessionDataTask.
     */
    @discardableResult
    open func DELETE
        (_ URL: String,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack)
        -> URLSessionDataTask {
            
        let request = SHRequest(URL: URL, method:  Method.DELETE, params: params, headers: headers, parseKeys: parseKeys)
        let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
        
        return dataTask
    }
    
    //MARK: - Upload File
    /**
     Uploads file to server.
     
            SwiftyHttp.uploadWithProgress("http://www.sample.com/api/method",
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
        * request: *SHRequest*
        * data: *Data?*
        * response: *SHResponse?*
     - parameter progress: Closure is called each time data sends to server.
     
        Returns:
        * bytesSent: *Int64*
        * totalBytesSent: *Int64*
        * totalBytesExpectedToSend: *Int64*
        * response: *SHResponse*
     - parameter failure: Closure is called when request is failed or server has responded with an error.
     
        Returns:
        * request: *SHRequest*
        * error: *Error?*
        * response: *SHResponse?*
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
        -> URLSessionUploadTask {
            
        let request = SHRequest(URL: URL, method: Method.POST, params: params, contentType: .multipart_form_data, headers: headers)
        let uploadTask = SHDataTaskManager.createUploadTaskWithRequest(request: request, completion: completion, progress: progress, failure: failure)
        uploadTask.resume()
            
        return uploadTask
    }
    
    //MARK: - Download File
    /**
     Downloads file from server.
     
            SwiftyHttp.downloadWithProgress("http://www.sample.com/api/method",
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
        * request: *SHRequest*
        * data: *Data?*
        * response: *SHResponse?*
     - parameter progress: Closure is called each time data comes from server.
     
        Returns:
        * bytesSent: *Int64*
        * totalBytesSent: *Int64*
        * totalBytesExpectedToSend: *Int64*
        * response: *SHResponse*
     - parameter failure: Closure is called when request is failed or server has responded with an error.

        Returns:
        * request: *SHRequest*
        * error: *Error?*
        * response: *SHResponse?*
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
        -> URLSessionDownloadTask {
            
        let request = SHRequest(URL: URL, method: Method.GET, params: params, contentType: .multipart_form_data, headers: headers)
        let downloadTask = SHDataTaskManager.createDownloadTaskWithRequest(request: request, completion: completion, progress: progress, failure: failure)
        downloadTask.resume()
            
        return downloadTask
    }
    
    @discardableResult
    open func send
        (dataRequest: SHDataRequest,
         completion: @escaping SuccessHTTPCallBack,
         failure: @escaping FailureHTTPCallBack) -> URLSessionDataTask {
        
        dataRequest.configureRequest()
        let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: dataRequest, completion: completion, failure: failure)
        dataTask.resume()
        
        return dataTask
    }
}

