import Foundation
import SwiftyJSON

open class SHResponse {
    
    public var JSON: JSON? {
        
        get {
            
            if let json = _JSON {
                return json
            }
            
            dataToJSON(data, parseKeys: parseKeys)
            return _JSON
        }
    }
    
    public var statusCode: Int? {
        
        get {
            return (response as? HTTPURLResponse)?.statusCode
        }
    }
    
    fileprivate var _JSON: JSON?
    
    fileprivate let response: URLResponse?
    fileprivate let parseKeys: [String]?
    fileprivate let data: Data?
    
    init(data: Data? = nil, response: URLResponse?, parseKeys: [String]? = nil) {
        
        self.response = response
        self.parseKeys = parseKeys
        self.data = data
    }
    
    internal func dataToJSON(_ incomingData: Data?, parseKeys: [String]?) {
        
        guard
            let data = incomingData,
            let json = SHJSON.createJSONObjectFrom(data)
            else {
            //TODO: Add to Errors
            return
        }
        
        _JSON = json
        
        guard let pKeys = parseKeys else {
            return
        }
        
        for key in pKeys {
            
            if _JSON![key].exists() {
                
                _JSON = _JSON?[key]
                
            } else {
                
                NSLog("error: Parsing JSON Error")//TODO: Add to Errors
            }
        }
    }
}
