//
//  SHUploadRequest.swift
//  SwiftyHttp
//
//  Created by Максим on 18.08.17.
//  Copyright © 2017 Maks. All rights reserved.
//

import Foundation

open class SHUpRequest: SHRequest {
    
    public var uploadSuccess: UploadCompletion?
    public var progress: ProgressCallBack?
    public var failure: FailureHTTPCallBack?
    
    @discardableResult
    public func upload() -> URLSessionUploadTask {
        
        configureRequest()
        
        let uploadTask = SHDataTaskManager.createUploadTaskWithRequest(request: self,
                                                                       completion: uploadSuccess,
                                                                       progress: self.progress,
                                                                       failure: self.failure)
        uploadTask.resume()
        return uploadTask
    }
    
    @discardableResult
    public func upload(completion: UploadCompletion? = nil,
                       progress: ProgressCallBack? = nil,
                       failure: FailureHTTPCallBack? = nil) -> URLSessionUploadTask {
        
        uploadSuccess = completion
        self.progress = progress
        self.failure = failure
        
        return upload()
    }
}
