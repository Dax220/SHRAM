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
        
        if let request = downloadTask.callBackHandler?.request {
            
            let shResponse = SHResponse(response: downloadTask.response, parseKeys: request.parseKeys)
            
            guard let response = downloadTask.response as? HTTPURLResponse else {
                downloadTask.callBackHandler?.error?(request, nil, shResponse)
                return
            }
            
            switch response.statusCode {
            case 200..<400:
                downloadTask.callBackHandler?.downloadCompletion?(location, shResponse)
            case 400...500:
                downloadTask.callBackHandler?.error?(request, nil, shResponse)
            default:
                break
            }
        }
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
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let request = task.callBackHandler?.request {
            
            guard let response = task.response as? HTTPURLResponse else {
                task.callBackHandler?.error?(request, error, nil)
                return
            }
            
            let shResponse = SHResponse(response: response, parseKeys: request.parseKeys)
            
            if task is URLSessionUploadTask {
                
                if (error == nil) {
                    
                    switch response.statusCode {
                    case 200..<400:
                        task.callBackHandler?.uploadCompletion?(shResponse)
                    case 400...500:
                        task.callBackHandler?.error?(request, error, shResponse)
                    default:
                        break
                    }
                    
                } else {
                    task.callBackHandler?.error?(request, error, shResponse)
                }
                
            } else if task is URLSessionDownloadTask, let error = error {
                task.callBackHandler?.error?(request, error, shResponse)
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
        
        let uploadTask = urlSession.uploadTask(withStreamedRequest: request.originalRequest)
        uploadTask.callBackHandler = CallBackHandler(request: request, progressHandler: progress, uploadCompletionHandler: completion, errorHandler: failure)
        
        return uploadTask
    }
    
    //MARK: - Download file task
    func createDownloadTaskWithRequest(request: SHRequest,
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
