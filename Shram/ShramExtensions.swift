import Foundation

extension Dictionary
{
    func stringFromHttpParameters() -> String
    {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = String(describing: key).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = String(describing: value).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joined(separator: "&")
    }
}

extension String
{
    func stringByAddingPercentEncodingForURLQueryValue() -> String?
    {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._~")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
}

//TODO: Test it carefully
extension URLSessionTask
{
    fileprivate struct AssociatedKeys
    {
        static var callBackHandler: CallBackHandler? = nil
    }
    
    weak var callBackHandler : CallBackHandler?
    {
        get
        {
            guard let callBackHandler = objc_getAssociatedObject(self, &AssociatedKeys.callBackHandler) else { return nil }
            return callBackHandler as? CallBackHandler
        }
        
        set(value)
        {
            objc_setAssociatedObject(self, &AssociatedKeys.callBackHandler, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
