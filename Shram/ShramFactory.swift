import Foundation

internal class ShramFactory: NSObject
{
    static func createObject(_ object: AnyClass, response: AnyObject) -> AnyObject?
    {
        guard object is NSObject.Type else
        {
            NSLog("\(object) does not have NSObject type.")
            return nil
        }
        
        if let baseObj = object as? ShramMappingProtocol.Type
        {
            let obj = baseObj.init()
            
            if var resp = response as? [String : AnyObject]
            {
                return fillObject(obj, withResponse: &resp)
            }
            else if let resp = response as? [[String : AnyObject]]
            {
                var objArr:[AnyObject] = []
                for var item in resp
                {
                    objArr.append(fillObject(obj, withResponse: &item))
                    return objArr as AnyObject?
                }
            }
        }
        return nil
    }
    
    internal static func fillObject(_ obj: ShramMappingProtocol, withResponse response: inout [String : AnyObject]) -> AnyObject
    {
        for association in obj.associations
        {
            guard let val = response[association.associatedKey]
                else
            {
                NSLog("Responce doesn't have key \(association.associatedKey)")
                continue
            }
            
            let propertyName = association.propertyName as String
            guard (obj as! NSObject).responds(to: NSSelectorFromString(propertyName))
                else
            {
                NSLog("Unresolved key value pair = \(association.associatedKey) : \(association.propertyName)")
                continue
            }
            
            if let relatedClass = association.relatedClass
            {
                tryBlock {
                    (obj as! NSObject).setValue(createObject(relatedClass, response: val as AnyObject), forKey: propertyName)
                }
            }
            else
            {
                setValue(value: val, forKey: propertyName, inObject: obj)
            }
        }
        return obj
    }
    
    private static func setValue(value: AnyObject, forKey key: String, inObject obj: AnyObject)
    {
        for child in Mirror(reflecting:obj).children {
            if child.label! == key
            {
                let type = String(describing: type(of: child.value))
                NSLog("key = \(key), type = \(type)")
                var propertyValue: AnyObject?
                
                if let _ = type.lowercased().range(of: "string")
                {
                    propertyValue = ShramJSON.stringValue(value) as AnyObject?
                }
                else if let _ = type.lowercased().range(of: "int")
                {
                    propertyValue = ShramJSON.intValue(value) as AnyObject?
                }
                else if let _ = type.lowercased().range(of: "double")
                {
                    propertyValue = ShramJSON.doubleValue(value) as AnyObject?
                }
                else if let _ = type.lowercased().range(of: "nsnumber")
                {
                    propertyValue = ShramJSON.numberValue(value) as AnyObject?
                }
                else if let _ = type.lowercased().range(of: "cgfloat")
                {
                    propertyValue = ShramJSON.cgfloatValue(value) as AnyObject?
                }
                else if let _ = type.lowercased().range(of: "bool")
                {
                    propertyValue = ShramJSON.boolValue(value) as AnyObject?
                }
                else
                {
                    propertyValue = value
                }

                tryBlock {
                    (obj as! NSObject).setValue(propertyValue, forKey: key)
                }
            }
        }
    }
}
