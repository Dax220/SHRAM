//
//  SHDownloadRequest.swift
//  SwiftyHttp
//
//  Created by Максим on 18.08.17.
//  Copyright © 2017 Maks. All rights reserved.
//

import Foundation

open class SHDownloadRequest: SHRequest {
    
    public var downloadSuccess: DownloadCompletion?
    public var progress: ProgressCallBack?
    public var failure: FailureHTTPCallBack?
    
    @discardableResult
    public func download() -> URLSessionDownloadTask {
        
        configureRequest()
        
        let downloadTask = SHDataTaskManager.createDownloadTaskWithRequest(request: self,
                                                                           completion: downloadSuccess,
                                                                           progress: self.progress,
                                                                           failure: self.failure)
        downloadTask.resume()
        return downloadTask
    }
    
    @discardableResult
    public func download(completion: DownloadCompletion? = nil,
                         progress: ProgressCallBack? = nil,
                         failure: FailureHTTPCallBack?  = nil) -> URLSessionDownloadTask {
        
        downloadSuccess = completion
        self.progress = progress
        self.failure = failure
        
        return download()
    }
}
