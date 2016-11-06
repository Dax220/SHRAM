import Foundation

public let ShramJSON = ShramJSONManager()

open class ShramJSONManager
{
    open func createJSONData(fromObject object: AnyObject) -> Data?
    {
        var jsonData: Data?
        do
        {
            jsonData = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        catch let error as NSError
        {
            NSLog("JSON error = \(error)")//TODO: Add to Shram Errors
        }
        return jsonData
    }
    
    open func createJSONObject(fromObject object: AnyObject) -> [String : AnyObject]
    {
        var JSON = [String : AnyObject]()
        switch object
        {
        case is [AnyObject]:
            
            parseArray(array: object as! [AnyObject], parentKey: "", toJSON: &JSON)
            
        case is [String : AnyObject]:
            
            parseDictionary(dictionary: object as! [String: AnyObject], parentKey: "", toJSON: &JSON)
            
        default:
            break
        }
        return JSON
    }
    
    //MARK: - Maping method
    internal func stringValue(_ object: Any) -> String
    {
        switch object {
        case is String:
            return object as? String ?? ""
        case is NSNumber:
            return (object as! NSNumber).stringValue
        case is Int:
            return String(describing: object)
        default:
            return ""
        }
    }
    
    internal func intValue(_ object: AnyObject) -> Int
    {
        return self.numberValue(object).intValue
    }
    
    internal func doubleValue(_ object: AnyObject) -> Double
    {
        return self.numberValue(object).doubleValue
    }
    
    internal func cgfloatValue(_ object: AnyObject) -> CGFloat
    {
        return CGFloat(self.numberValue(object).doubleValue)
    }
    
    internal func boolValue(_ object: AnyObject) -> Bool
    {
        switch object {
        case is Bool:
            return object as! Bool
        default:
            return false
        }
    }
    
    internal func numberValue(_ object: AnyObject) -> NSNumber
    {
        switch object {
        case is String:
            let decimal = NSDecimalNumber(string: object as? String)
            if decimal == NSDecimalNumber.notANumber {
                return NSDecimalNumber.zero
            }
            return decimal
        case is NSNumber:
            return object as? NSNumber ?? NSNumber(value: 0)
        default:
            return NSNumber(value: 0.0)
        }
    }
    
    internal func createJSONObjectFrom(_ incomingData: Data) -> Any?
    {
        var JSONObject: Any?
        do
        {
            JSONObject = try JSONSerialization.jsonObject(with: incomingData, options: .allowFragments)
            
            switch JSONObject {
            case _ as [String : Any]:
                JSONObject = JSONObject as! [String : Any]
            case _ as [Any]:
                JSONObject = JSONObject as! [Any]
            default:
                break
            }
        }
        catch let error
        {
            NSLog("JSON error = \(error)")//TODO: Add to Shram Errors
        }
        return JSONObject
    }
    
    fileprivate func parseDictionary(dictionary: [String: AnyObject], parentKey: String, toJSON JSON: inout [String : AnyObject])
    {
        for (var key, value) in dictionary
        {
            key = parentKey == "" ? key : parentKey + "[\(key)]"
            
            switch value
            {
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
    
    fileprivate func parseArray(array: [AnyObject], parentKey: String, toJSON JSON: inout [String : AnyObject])
    {
        for (i, obj) in array.enumerated()
        {
            let key = parentKey == "" ? "" : parentKey + "[\(i)]"
            
            switch obj
            {
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
