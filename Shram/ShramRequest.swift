import Foundation

//MARK: - Request HTTP Methods Struct
public struct Method
{
    static let GET = "GET"
    static let PUT = "PUT"
    static let POST = "POST"
    static let DELETE = "DELETE"
}

//MARK: - Request content type enum
public enum ContentType: Int
{
    case json
    case urlencoded
    case multipart_form_data
}

//MARK: - Supported content types
private struct AvailableContentTypes
{
    static let JSON = "application/json"
    static let URLENCODED = "application/x-www-form-urlencoded"
    static let MULTIPART_FORM_DATA = "multipart/form-data;"
}

fileprivate protocol ShramRequestConfigure {
    
    var requestURL: String! {get set}
    
    var method: String! {get set}
    
    var parameters: [String : AnyObject]? {get set}
    
    var contentType: ContentType? {get set}
    
    var headers: [String : String]? {get set}
    
    var mapTo: ShramMappingProtocol.Type? {get set}
    
    var parseKeys: [String]? {get set}
    
    var timeOut: TimeInterval {get set}
}

fileprivate protocol ShramOriginalRequest {
    
    var originalRequest: URLRequest! {get}
    
}

public struct ShramRequest: ShramRequestConfigure, ShramOriginalRequest
{
    public var requestURL: String! {
        get {
            return _URL
        }
        set {
            _URL = newValue
        }
    }
    
    public var method: String! {
        get {
            return _method
        }
        set {
            _method = newValue
        }
    }
    
    public var parameters: [String : AnyObject]? {
        get {
            return _params
        }
        set {
            _params = newValue
        }
    }
    
    public var contentType: ContentType? {
        get {
            return _contentType
        }
        set {
            _contentType = newValue
        }
    }
    
    public var headers: [String : String]? {
        get {
            return _headers
        }
        set {
            _headers = newValue
        }
    }
    
    public var mapTo: ShramMappingProtocol.Type? {
        get {
            return _mapTo
        }
        set {
            _mapTo = newValue
        }
    }
    
    public var parseKeys: [String]? {
        get {
            return _parseKeys
        }
        set {
            _parseKeys = newValue
        }
    }
    
    public var timeOut: TimeInterval {
        get {
            return _timeOut
        }
        set {
            _timeOut = newValue
        }
    }
    
    public var originalRequest: URLRequest! {
        get {
            return _originalRequest
        }
    }
    
    fileprivate var _URL: String!
    
    fileprivate var _method: String!
    
    fileprivate var _params: [String : AnyObject]?
    
    fileprivate var _contentType: ContentType?
    
    fileprivate var _headers: [String : String]?
    
    fileprivate var _mapTo: ShramMappingProtocol.Type?

    fileprivate var _parseKeys: [String]?
    
    fileprivate var _timeOut: TimeInterval = 30.0
    
    fileprivate var _originalRequest: URLRequest?
    
    fileprivate var boundary: String {
        get {
            return "unique-consistent-string" //TODO: - genarate boundary
        }
    }
    
    //MARK: - Initialization
    
    public init(URL: String, method: String) {
        _URL = URL
        _method = method
        if (method == Method.POST || method == Method.PUT) {
            _contentType = ContentType.multipart_form_data
        }
    }
    
    internal init(URL: String,
                  method: String,
                  params: [String: AnyObject]?,
                  headers: [String: String]?,
                  mapTo: ShramMappingProtocol.Type? = nil,
                  parseKeys: [String]? = nil) {
        
        var finalURL = URL
        
        if (method == Method.GET || method == Method.DELETE) && params != nil {
            finalURL += params!.stringFromHttpParameters()
        }
        
        _URL = finalURL
        _method = method
        _params = params
        _headers = headers
        _mapTo = mapTo
        _parseKeys = parseKeys
        _originalRequest = URLRequest(url: Foundation.URL(string: _URL)!, cachePolicy: .useProtocolCachePolicy)
        _originalRequest!.httpMethod = _method
        
        setHTTPHeaders()
    }
    
    internal init(URL: String,
                  method: String,
                  params: [String: AnyObject]?,
                  contentType: ContentType,
                  headers: [String : String]?,
                  mapTo: ShramMappingProtocol.Type? = nil,
                  parseKeys: [String]? = nil) {
        
        _URL = URL
        _method = method
        _params = params
        _contentType = contentType
        _headers = headers
        _mapTo = mapTo
        _parseKeys = parseKeys
        _originalRequest = URLRequest(url: Foundation.URL(string: _URL)!, cachePolicy: .useProtocolCachePolicy)
        _originalRequest!.httpMethod = _method
        
        setParametersWithContentType()
        setHTTPHeaders()
    }
    
    //MARK: - Send configured request
    @discardableResult
    public mutating func send(completion: SuccessHTTPCallBack? = nil,
                              failure: FailureHTTPCallBack? = nil) -> URLSessionDataTask {
        
        configureRequest()
        
        let dataTask = ShramDataTaskManager.createDataTaskWithRequest(request: self, completion: completion, failure: failure)
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    public mutating func download(completion: DownloadCompletion? = nil,
                                  progress: ProgressCallBack? = nil,
                                  failure: FailureHTTPCallBack?  = nil) -> URLSessionDownloadTask {
        
        configureRequest()
        
        let downloadTask = ShramDataTaskManager.createDownloadTaskWithRequest(request: self,
                                                                             completion: completion,
                                                                             progress: progress,
                                                                             failure: failure)
        downloadTask.resume()
        return downloadTask
    }
    
    @discardableResult
    public mutating func upload(completion: UploadCompletion? = nil,
                                progress: ProgressCallBack? = nil,
                                failure: FailureHTTPCallBack? = nil) -> URLSessionUploadTask {
        
        configureRequest()
        
        let uploadTask = ShramDataTaskManager.createUploadTaskWithRequest(request: self,
                                                                         completion: completion,
                                                                         progress: progress,
                                                                         failure: failure)
        uploadTask.resume()
        return uploadTask
    }
    
    fileprivate mutating func configureRequest() {
        
        if (_method == Method.GET || _method == Method.DELETE) {
            if (_params != nil) {
                var finalURL: String = _URL
                finalURL += _params!.stringFromHttpParameters()
                _URL = finalURL
            }
        }
        
        _originalRequest = URLRequest(url: Foundation.URL(string: _URL)!, cachePolicy: .useProtocolCachePolicy)
        _originalRequest?.httpMethod = _method
        _originalRequest?.timeoutInterval = _timeOut
        
        if (_method == Method.POST || _method == Method.PUT) {
            setParametersWithContentType()
        }
        
        setHTTPHeaders()
    }
    
    
    //MARK: - Setting request parameters
    fileprivate mutating func setParametersWithContentType() {
    
        guard let cType = _contentType, _params != nil else {
            return
        }
        
        switch cType {
            
        case .json:
            
            setJsonData()
            _originalRequest!.setValue(AvailableContentTypes.JSON, forHTTPHeaderField: "Content-type")
            
        case .urlencoded:
            
            setUrlencodedData()
            _originalRequest!.setValue(AvailableContentTypes.URLENCODED, forHTTPHeaderField: "Content-type")
            
        case .multipart_form_data:
            
            setMultipartData()
            _originalRequest!.setValue(AvailableContentTypes.MULTIPART_FORM_DATA + " boundary=\(boundary)", forHTTPHeaderField: "Content-type")
        }
    }
    
    //MARK: - Setting Headers
    fileprivate mutating func setHTTPHeaders() {
        
        guard let headers = _headers else {
            return
        }
        
        for (key, value) in headers {
            _originalRequest!.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    //MARK: - Setting urlencoded Data
    fileprivate mutating func setUrlencodedData() {
        
        guard _params != nil && (_params?.count)! > 0 else {
            return
        }
        
        _params = ShramJSON.createJSONObject(fromObject: _params as AnyObject)
        
        var postString = ""
        fillPostString(&postString)
        postString = (postString as NSString).substring(to: (postString as NSString).length - 1)
        _originalRequest!.httpBody = postString.data(using: String.Encoding.utf8) //TODO: handle IOS version since 8.0
    }
    
    fileprivate func fillPostString(_ postString: inout String) {
        
        for (key, value) in _params! {
            postString += String(key) + "=" + String(describing: value) + "&"
        }
    }
    
    //MARK: - Setting JSON
    fileprivate mutating func setJsonData() {
        
        if let object = _params {
            _originalRequest!.httpBody = ShramJSON.createJSONData(fromObject: object as AnyObject) as Data?
        } else {
            //TODO: Handle error and add to Shram Error
        }
    }
    
    //MARK: - Setting Multipart Data
    fileprivate mutating func setMultipartData() {
        
        guard _params != nil && (_params?.count)! > 0 else { return }
        
        let body = NSMutableData()
        fillPOSTData(body)
        _originalRequest!.httpBody = body as Data
    }
    
    fileprivate func fillPOSTData(_ body: NSMutableData) {
        
        for (key, value) in _params! {
            setBoundary(toBody: body)
            if let filePath = ShramFileManager.checkPathForResource(value) {
                appendMultipartBodyWithFile(body: body, name: key, pathForResource: filePath)
            } else {
                appendMultipartBody(body: body, name: key, value: value)
            }
        }
        setBoundary(toBody: body)
    }
    
    fileprivate func appendMultipartBodyWithFile(body: NSMutableData, name: String, pathForResource: String) {
        
        guard
            let fileData = try? Data(contentsOf: Foundation.URL(fileURLWithPath: pathForResource)),
            let URL = URL(string: pathForResource)
            else { NSLog("appendMultipartBody err"); return /*TODO: handle error*/ }
        
        let mimeType = ShramMIMETypesService.sharedInstance().mimeTypeForURL(URL)
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(URL.lastPathComponent)\"\r\n".data(using: String.Encoding.utf8)!)//TODO: handle IOS version since 8.0
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)//TODO: handle IOS version since 8.0
        body.append(fileData)
        body.append("\r\n\r\n".data(using: String.Encoding.utf8)!)//TODO: handle IOS version since 8.0
    }
    
    fileprivate func appendMultipartBody(body: NSMutableData, name: String, value: AnyObject) {
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: String.Encoding.utf8)!)//TODO: handle IOS version since 8.0
        body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)//TODO: handle IOS version since 8.0
    }
    
    fileprivate func setBoundary(toBody body: NSMutableData) {
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)//TODO: handle IOS version since 8.0
    }
}
