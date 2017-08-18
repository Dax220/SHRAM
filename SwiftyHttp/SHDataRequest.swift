//
//  SHDataRequest.swift
//  SwiftyHttp
//
//  Created by Максим on 18.08.17.
//  Copyright © 2017 Maks. All rights reserved.
//

import Foundation

open class SHDataRequest: SHRequest {
    
    public var failure: FailureHTTPCallBack?
    public var success: SuccessHTTPCallBack?
    
    @discardableResult
    public func send() -> URLSessionDataTask {
        
        configureRequest()
        
        let dataTask = SHDataTaskManager.createDataTaskWithRequest(request: self, completion: success, failure: self.failure)
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    public func send(completion: SuccessHTTPCallBack? = nil,
                     failure: FailureHTTPCallBack? = nil) -> URLSessionDataTask {
        
        success = completion
        self.failure = failure
        
        return send()
    }
}
