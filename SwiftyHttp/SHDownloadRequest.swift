//
//  SHDownloadRequest.swift
//  SwiftyHttp
//
//  Created by Максим on 18.08.17.
//  Copyright © 2017 Maks. All rights reserved.
//

import Foundation

open class SHDownloadRequest: SHRequest {
    
    public var success: DownloadCompletion?
    public var progress: ProgressCallBack?
    public var failure: FailureHTTPCallBack?
    
    @discardableResult
    public func download() -> URLSessionDownloadTask {
        
        configureRequest()
        
        let downloadTask = SHDataTaskManager.createDownloadTaskWithRequest(request: self,
                                                                           completion: success,
                                                                           progress: progress,
                                                                           failure: failure)
        downloadTask.resume()
        return downloadTask
    }
    
    @discardableResult
    public func download(success: DownloadCompletion? = nil,
                         progress: ProgressCallBack? = nil,
                         failure: FailureHTTPCallBack?  = nil) -> URLSessionDownloadTask {
        
        self.success = success
        self.progress = progress
        self.failure = failure
        
        return download()
    }
}
