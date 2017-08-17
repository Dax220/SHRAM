import Foundation

open class ShramResponse
{    
    public var JSON: Any? {
        get {
            switch _JSON {
            case _ as [Any]:
                return _JSON as! [Any]
            case _ as [String : Any]:
                return _JSON as! [String : Any]
            default:
                return _JSON
            }
        }
    }
    
    fileprivate var _JSON: Any?
    
    public var statusCode: Int? {
        get {
            return (response as? HTTPURLResponse)?.statusCode
        }
    }
    
    fileprivate let response: URLResponse?
    
    init(data: Data? = nil, response: URLResponse?, parseKeys: [String]? = nil) {
        
        self.response = response
        dataToJSON(data, parseKeys: parseKeys)
    }
    
    internal func dataToJSON(_ incomingData: Data?, parseKeys: [String]?) {
        
        guard
            let data = incomingData,
            let json = ShramJSON.createJSONObjectFrom(data)
            else {
            //TODO: Add to Shram Errors
            return
        }
        
        _JSON = json as AnyObject?
        
        guard let pKeys = parseKeys else {
            return
        }
        
        for key in pKeys {
            
            if let JSONPart = (_JSON as AnyObject)[key] {
                
                _JSON = JSONPart
                
            } else {
                
                NSLog("error: Parsing JSON Error")//TODO: Add to Shram Errors
            }
        }
    }
}
