import Foundation
import SwiftyJSON

public let SHJSON = SHJSONJSONManager()

open class SHJSONJSONManager {
    
    open func createJSONData(fromObject object: AnyObject) -> Data? {
        
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch let error as NSError {
            NSLog("JSON error = \(error)")//TODO: Add to Errors
        }
        return jsonData
    }
    
    open func createJSONObject(fromObject object: AnyObject) -> [String : AnyObject] {
        
        var JSON = [String : AnyObject]()
        
        switch object {
            
        case is [AnyObject]:
            
            parseArray(array: object as! [AnyObject], parentKey: "", toJSON: &JSON)
            
        case is [String : AnyObject]:
            
            parseDictionary(dictionary: object as! [String: AnyObject], parentKey: "", toJSON: &JSON)
            
        default:
            break
        }
        
        return JSON
    }
    
    internal func createJSONObjectFrom(_ incomingData: Data) -> JSON? {
        
        return JSON(incomingData)
    }
    
    fileprivate func parseDictionary(dictionary: [String: AnyObject], parentKey: String, toJSON JSON: inout [String : AnyObject]) {
        
        for (var key, value) in dictionary {
            
            key = parentKey == "" ? key : parentKey + "[\(key)]"
            
            switch value {
                
            case is String, is Int, is Double:
                
                JSON[key] = value
                
            case is [AnyObject]:
                
                parseArray(array: value as! [AnyObject], parentKey: key, toJSON: &JSON)
                
            case is [String : AnyObject]:
                
                parseDictionary(dictionary: value as! [String : AnyObject], parentKey: key, toJSON: &JSON)
                
            default:
                
                NSLog("Unsupported type")
                break
            }
        }
    }
    
    fileprivate func parseArray(array: [AnyObject], parentKey: String, toJSON JSON: inout [String : AnyObject]) {
        
        for (i, obj) in array.enumerated() {
            
            let key = parentKey == "" ? "" : parentKey + "[\(i)]"
            
            switch obj {
                
            case is String, is Int, is Double:
                
                JSON[key] = obj
                
            case is [[String : AnyObject]]:
                
                parseArray(array: obj as! [[String : AnyObject]] as [AnyObject], parentKey: key, toJSON: &JSON)
                
            case is [String : AnyObject]:
                
                parseDictionary(dictionary: obj as! [String : AnyObject], parentKey: key, toJSON: &JSON)
                
            default:
                NSLog("Unsupported type")
                break
            }
        }
    }
}
