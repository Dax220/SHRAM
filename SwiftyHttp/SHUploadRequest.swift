//
//  SHUploadRequest.swift
//  SwiftyHttp
//
//  Created by Максим on 18.08.17.
//  Copyright © 2017 Maks. All rights reserved.
//

import Foundation

open class SHUploadRequest: SHRequest {
    
    public var success: UploadCompletion?
    public var progress: ProgressCallBack?
    public var failure: FailureHTTPCallBack?
    
    public override init(URL: String, method: SHMethod) {
        super.init(URL: URL, method: method)
        
        contentType = .multipart_form_data
    }
    
    @discardableResult
    public func upload() -> URLSessionUploadTask {
        
        configureRequest()
        
        let uploadTask = SHDataTaskManager.createUploadTaskWithRequest(request: self,
                                                                       completion: success,
                                                                       progress: progress,
                                                                       failure: failure)
        uploadTask.resume()
        return uploadTask
    }
    
    @discardableResult
    public func upload(completion: UploadCompletion? = nil,
                       progress: ProgressCallBack? = nil,
                       failure: FailureHTTPCallBack? = nil) -> URLSessionUploadTask {
        
        self.success = completion
        self.progress = progress
        self.failure = failure
        
        return upload()
    }
}
