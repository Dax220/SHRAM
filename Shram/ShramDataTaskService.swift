import Foundation

public typealias BytesSent = Int64
public typealias TotalBytesSent = Int64
public typealias TotalBytesExpectedToSend = Int64

public typealias SuccessHTTPCallBack = (_ request: ShramRequest, _ data: Data?, _ response: ShramResponse?) -> Void
public typealias FailureHTTPCallBack = (_ request: ShramRequest, _ error: Error?, _ response: ShramResponse?) -> Void
public typealias ProgressCallBack = (_ bytesSent: BytesSent, _ totalBytesSent: TotalBytesSent, _ totalBytesExpectedToSend: TotalBytesExpectedToSend, _ response: ShramResponse) -> Void
public typealias DownloadCompletion = (_ didFinishDownloadingToURL: URL, _ response: ShramResponse) -> Void
public typealias UploadCompletion = (_ response: ShramResponse) -> Void

let ShramDataTaskManager = ShramDataTaskService()

class ShramDataTaskService: NSObject, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var urlSession: Foundation.URLSession!
    
    override init() {
        super.init()
        urlSession = Foundation.URLSession(configuration:URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
    }
    
    //MARK: - NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let request = downloadTask.callBackHandler?.request {
            
            let dzenResponse = ShramResponse(response: downloadTask.response, parseKeys: request.parseKeys)
            
            guard let response = downloadTask.response as? HTTPURLResponse else {
                downloadTask.callBackHandler?.error?(request, nil, dzenResponse)
                return
            }
            
            switch response.statusCode {
            case 200..<400:
                downloadTask.callBackHandler?.downloadCompletion?(location, dzenResponse)
            case 400...500:
                downloadTask.callBackHandler?.error?(request, nil, dzenResponse) //TODO: handle error and add to Shram Errors
            default:
                break
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if let request = downloadTask.callBackHandler?.request {
            
            let dzenResponse = ShramResponse(response: downloadTask.response, parseKeys: request.parseKeys)
            
            guard let response = downloadTask.response as? HTTPURLResponse else {
                downloadTask.callBackHandler?.error?(request, nil, dzenResponse)
                return
            }
            
            switch response.statusCode {
            case 200..<400:
                downloadTask.callBackHandler?.progress?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite, dzenResponse)
            case 400...500:
                downloadTask.callBackHandler?.error?(request, nil, dzenResponse) //TODO: handle error and add to Shram Errors
            default:
                break
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let request = task.callBackHandler?.request {
            
            let dzenResponse = ShramResponse(response: task.response, parseKeys: request.parseKeys)
            
            if task is URLSessionUploadTask {
                
                if (error == nil) {
                    task.callBackHandler?.uploadCompletion?(dzenResponse)
                } else {
                    task.callBackHandler?.error?((task.callBackHandler?.request)!, error as NSError?, dzenResponse)
                }
                
            } else if task is URLSessionDownloadTask, let error = error {
                task.callBackHandler?.error?((task.callBackHandler?.request)!, error as NSError?, dzenResponse)
            }
        }
    }
    
    //MARK: - NSURLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        if let request = task.callBackHandler?.request {
         
            let dzenResponse = ShramResponse(response: task.response, parseKeys: request.parseKeys)
            
            task.callBackHandler?.progress?(bytesSent, totalBytesSent, totalBytesExpectedToSend, dzenResponse)
        
        }
    }
    
    func createDataTaskWithRequest(request: ShramRequest,
                                   completion: SuccessHTTPCallBack?,
                                   failure: FailureHTTPCallBack?) -> URLSessionDataTask {
        
        return urlSession.dataTask(with: request.originalRequest) { (data, resp, err) in
            
            let dzenResponse = ShramResponse(data: data, response: resp, parseKeys: request.parseKeys)
            
            guard err == nil else {
                failure?(request, err, dzenResponse)
                return
            }
            
            guard let response = resp as? HTTPURLResponse else {
                failure?(request, nil, dzenResponse) //TODO: handle error and add to Shram Errors
                return
            }
            
            switch response.statusCode {
            case 200..<400:
                completion?(request, data, dzenResponse)
            case 400...500:
                failure?(request, err, dzenResponse) //TODO: handle error and add to Shram Errors
            default:
                break
            }
        } 
    }
    
    //MARK: - Upload file task
    func createUploadTaskWithRequest(request: ShramRequest,
                                    completion: UploadCompletion?,
                                    progress: ProgressCallBack?,
                                    failure: FailureHTTPCallBack?) -> URLSessionUploadTask {
        
        let uploadTask = urlSession.uploadTask(withStreamedRequest: request.originalRequest)
        uploadTask.callBackHandler = CallBackHandler(request: request, progressHandler: progress, uploadCompletionHandler: completion, errorHandler: failure)
        
        return uploadTask
    }
    
    //MARK: - Download file task
    func createDownloadTaskWithRequest(request: ShramRequest,
                                       completion: DownloadCompletion?,
                                       progress: ProgressCallBack?,
                                       failure: FailureHTTPCallBack?) -> URLSessionDownloadTask {
        
        let downloadTask = urlSession.downloadTask(with: request.originalRequest)
        downloadTask.callBackHandler = CallBackHandler(request: request, progressHandler: progress, downloadCompletionHandler: completion, errorHandler: failure)
        
        return downloadTask
    }
}

internal class CallBackHandler: NSObject {
    
    var progress: ProgressCallBack?
    var downloadCompletion: DownloadCompletion?
    var error: FailureHTTPCallBack?
    var uploadCompletion: UploadCompletion?
    var request: ShramRequest
    
    init(request: ShramRequest,
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
