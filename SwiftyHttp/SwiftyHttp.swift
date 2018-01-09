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
        (URL: String,
         params: [String: AnyObject]?,
         contentType: ContentType,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: SuccessHTTPCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionDataTask {
            
        let request = SHRequest(URL: URL, method: .post, params: params, contentType: contentType, headers: headers, parseKeys: parseKeys)
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
        (URL: String,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: SuccessHTTPCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionDataTask {
            
        let request = SHRequest(URL: URL, method: .get, params: params, headers: headers, parseKeys: parseKeys)
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
        (URL: String,
         params: [String: AnyObject]?,
         contentType: ContentType,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: SuccessHTTPCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionDataTask {
            
        let request = SHRequest(URL: URL, method: .put, params: params, contentType: contentType, headers: headers, parseKeys: parseKeys)
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
        (URL: String,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: SuccessHTTPCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionDataTask {
            
        let request = SHRequest(URL: URL, method: .delete, params: params, headers: headers, parseKeys: parseKeys)
        let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
        dataTask.resume()
        
        return dataTask
    }
    
    //MARK: - PATCH Method
    @discardableResult
    open func PATCH
        (URL: String,
         params: [String: AnyObject]?,
         contentType: ContentType,
         headers: [String: String]? = nil,
         withParseKeys parseKeys: [String]? = nil,
         completion: SuccessHTTPCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionDataTask {
            
            let request = SHRequest(URL: URL, method: .patch, params: params, contentType: contentType, headers: headers, parseKeys: parseKeys)
            let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: request, completion: completion, failure: failure)
            dataTask.resume()
            
            return dataTask
    }
    
    //MARK: - Sending SHDataRequest
    @discardableResult
    open func send
        (dataRequest: SHDataRequest,
         completion: SuccessHTTPCallBack? = nil,
         failure: FailureHTTPCallBack? = nil) -> URLSessionDataTask {
        
        dataRequest.configureRequest()
        let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: dataRequest, completion: completion, failure: failure)
        dataTask.resume()
        
        return dataTask
    }
    
   //MARK: - Upload process
    @discardableResult
    open func upload
        (request: SHUploadRequest,
         succeess: UploadCompletion? = nil,
         progress: ProgressCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionUploadTask {
        
            var successCallback = request.success
            var progressCallback = request.progress
            var failureCallback = request.failure
            
            if let succeess = succeess {
                successCallback = succeess
            }
            
            if let progress = progress {
                progressCallback = progress
            }
            
            if let failure = failure {
                failureCallback = failure
            }
            
            let uploadTask = SHDataTaskManager.createUploadTaskWithRequest(request: request,
                                                                           completion: successCallback,
                                                                           progress: progressCallback,
                                                                           failure: failureCallback)
            uploadTask.resume()
            
            return uploadTask
    }
    
    @discardableResult
    open func upload
        (URL: String,
         method: SHMethod,
         contentType: ContentType = .multipart_form_data,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         completion: UploadCompletion? = nil,
         progress: ProgressCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionUploadTask {

        let request = SHRequest(URL: URL, method: method, params: params, contentType: contentType, headers: headers)
        let uploadTask = SHDataTaskManager.createUploadTaskWithRequest(request: request, completion: completion, progress: progress, failure: failure)
        uploadTask.resume()

        return uploadTask
    }
    
    //MARK: - Download process
    @discardableResult
    open func download
        (request: SHDownloadRequest,
         succeess: DownloadCompletion? = nil,
         progress: ProgressCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionDownloadTask {
        
        var successCallback = request.success
        var progressCallback = request.progress
        var failureCallback = request.failure
        
        if let succeess = succeess {
            successCallback = succeess
        }
        
        if let progress = progress {
            progressCallback = progress
        }
        
        if let failure = failure {
            failureCallback = failure
        }
        
        let downloadTask = SHDataTaskManager.createDownloadTaskWithRequest(request: request,
                                                                           completion: successCallback,
                                                                           progress: progressCallback,
                                                                           failure: failureCallback)
        downloadTask.resume()
        
        return downloadTask
    }
    
    @discardableResult
    open func download
        (URL: String,
         method: SHMethod,
         contentType: ContentType = .multipart_form_data,
         params: [String: AnyObject]? = nil,
         headers: [String: String]? = nil,
         completion: DownloadCompletion? = nil,
         progress: ProgressCallBack? = nil,
         failure: FailureHTTPCallBack? = nil)
        -> URLSessionDownloadTask {
            
        let request = SHRequest(URL: URL, method: method, params: params, contentType: contentType, headers: headers)
        let downloadTask = SHDataTaskManager.createDownloadTaskWithRequest(request: request, completion: completion, progress: progress, failure: failure)
        downloadTask.resume()
            
        return downloadTask
    }
}
