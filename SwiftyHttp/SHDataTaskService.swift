import Foundation

public typealias BytesSent = Int64
public typealias TotalBytesSent = Int64
public typealias TotalBytesExpectedToSend = Int64

public typealias SuccessHTTPCallBack = (_ request: SHRequest, _ data: Data?, _ response: SHResponse?) -> Void
public typealias FailureHTTPCallBack = (_ request: SHRequest, _ error: Error?, _ response: SHResponse?) -> Void
public typealias ProgressCallBack = (_ bytesSent: BytesSent, _ totalBytesSent: TotalBytesSent, _ totalBytesExpectedToSend: TotalBytesExpectedToSend, _ response: SHResponse) -> Void
public typealias DownloadCompletion = (_ didFinishDownloadingToURL: URL, _ response: SHResponse) -> Void
public typealias UploadCompletion = (_ response: SHResponse) -> Void

let SHDataTaskManager = SHDataTaskService()

class SHDataTaskService: NSObject, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var urlSession: Foundation.URLSession!
    
    override init() {
        super.init()
        urlSession = Foundation.URLSession(configuration:URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
    }
    
    //MARK: - NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if let request = downloadTask.callBackHandler?.request {
            
            let shResponse = SHResponse(response: downloadTask.response, parseKeys: request.parseKeys)
            
            guard let response = downloadTask.response as? HTTPURLResponse else {
                downloadTask.callBackHandler?.error?(request, nil, shResponse)
                return
            }
            
            switch response.statusCode {
            case 200..<400:
                downloadTask.callBackHandler?.progress?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite, shResponse)
            case 400...500:
                downloadTask.callBackHandler?.error?(request, nil, shResponse)
            default:
                break
            }
        }
    }
    
    //MARK: - NSURLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        if let request = task.callBackHandler?.request {
            
            let shResponse = SHResponse(response: task.response, parseKeys: request.parseKeys)
            task.callBackHandler?.progress?(bytesSent, totalBytesSent, totalBytesExpectedToSend, shResponse)
        }
    }
    
    func createDataTaskWithRequest(request: SHRequest,
                                   completion: SuccessHTTPCallBack?,
                                   failure: FailureHTTPCallBack?) -> URLSessionDataTask {
        
        return urlSession.dataTask(with: request.originalRequest) { (data, resp, err) in
            
            let shResponse = SHResponse(data: data, response: resp, parseKeys: request.parseKeys)
            
            guard err == nil else {
                failure?(request, err, shResponse)
                return
            }
            
            guard let response = resp as? HTTPURLResponse else {
                failure?(request, nil, shResponse)
                return
            }
            
            switch response.statusCode {
            case 200..<400:
                completion?(request, data, shResponse)
            case 400...500:
                failure?(request, err, shResponse)
            default:
                break
            }
        }
    }
    
    //MARK: - Upload file task
    func createUploadTaskWithRequest(request: SHRequest,
                                     completion: UploadCompletion?,
                                     progress: ProgressCallBack?,
                                     failure: FailureHTTPCallBack?) -> URLSessionUploadTask {
        
        var callBackHandler: CallBackHandler?
        
        let uploadTask = urlSession.uploadTask(with: request.originalRequest, from: nil) { (data, resp, error) in
            
            guard let response = resp as? HTTPURLResponse else {
                callBackHandler?.error?(request, error, nil)
                return
            }
            
            let shResponse = SHResponse(data: data, response: response, parseKeys: request.parseKeys)
            
            if error == nil {
                
                switch response.statusCode {
                case 200..<400:
                    callBackHandler?.uploadCompletion?(shResponse)
                case 400...500:
                    callBackHandler?.error?(request, error, shResponse)
                default:
                    break
                }
                
            } else {
                callBackHandler?.error?(request, error, shResponse)
            }
        }
        
        uploadTask.callBackHandler = CallBackHandler(request: request, progressHandler: progress, uploadCompletionHandler: completion, errorHandler: failure)
        callBackHandler = uploadTask.callBackHandler
        
        return uploadTask
    }
    
    //MARK: - Download file task
    func createDownloadTaskWithRequest(request: SHRequest,
                                       completion: DownloadCompletion?,
                                       progress: ProgressCallBack?,
                                       failure: FailureHTTPCallBack?) -> URLSessionDownloadTask {
        
        
        var callBackHandler: CallBackHandler?
        
        let downloadTask = urlSession.downloadTask(with: request.originalRequest) { (url, resp, err) in
            
            let shResponse = SHResponse(response: resp, parseKeys: request.parseKeys)
            
            if err != nil {
                callBackHandler?.error?(request, err, shResponse)
                return
            }
            
            guard let response = resp as? HTTPURLResponse, let location = url else {
                callBackHandler?.error?(request, nil, shResponse)
                return
            }
            
            switch response.statusCode {
            case 200..<400:
                callBackHandler?.downloadCompletion?(location, shResponse)
            case 400...500:
                callBackHandler?.error?(request, nil, shResponse)
            default:
                break
            }
        }
        
        downloadTask.callBackHandler = CallBackHandler(request: request, progressHandler: progress, downloadCompletionHandler: completion, errorHandler: failure)
        callBackHandler = downloadTask.callBackHandler
        
        return downloadTask
    }
}

internal class CallBackHandler: NSObject {
    
    var progress: ProgressCallBack?
    var downloadCompletion: DownloadCompletion?
    var error: FailureHTTPCallBack?
    var uploadCompletion: UploadCompletion?
    var request: SHRequest
    
    init(request: SHRequest,
         progressHandler progress: ProgressCallBack? = nil,
         downloadCompletionHandler downloadCompletion: DownloadCompletion? = nil,
         uploadCompletionHandler uploadCompletion: UploadCompletion? = nil,
         errorHandler error: FailureHTTPCallBack? = nil) {
        
        self.request = request
        self.progress = progress
        self.downloadCompletion = downloadCompletion
        self.uploadCompletion = uploadCompletion
        self.error = error
        super.init()
    }
}

