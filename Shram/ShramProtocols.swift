import Foundation

public class Association {
    let propertyName: String!
    let associatedKey: String!
    let relatedClass: ShramMappingProtocol.Type?
    
    init(associatedKey: String, propertyName: String, relatedClass: ShramMappingProtocol.Type? = nil) {
        self.propertyName = propertyName
        self.associatedKey = associatedKey
        self.relatedClass = relatedClass
    }
}

public protocol ShramMappingProtocol: class
{
    init()
}

extension ShramMappingProtocol
{
    public var description: String
    {
        let mirror = Mirror(reflecting: self)
        var descriptionStr = "\n"
        for (label, value) in mirror.children {
            if let lbl = label
            {
                descriptionStr += "\(lbl)" + ": " + "\(value)" + "\n"
            }
        }
        return descriptionStr
    }
    
    public func setAssociation(serverKey associatedKey: String, propertyName: String)
    {
        self.associations.append(Association(associatedKey: associatedKey, propertyName: propertyName))
    }
    
    public func setRelatedAssociation(serverKey associatedKey: String, propertyName value: String, relatedClass: ShramMappingProtocol.Type)
    {
        self.associations.append(Association(associatedKey: associatedKey, propertyName: value, relatedClass: relatedClass))
    }
}

private struct ShramMappingAssociatedKeys
{
    static var associations: [String: AnyObject] = [:]
}

extension ShramMappingProtocol
{
    internal var associations : [Association]
    {
        get
        {
            guard let associations = objc_getAssociatedObject(self, &ShramMappingAssociatedKeys.associations) else { return [] }
            return associations as! [Association]
        }
        
        set(value)
        {
            objc_setAssociatedObject(self, &ShramMappingAssociatedKeys.associations, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
