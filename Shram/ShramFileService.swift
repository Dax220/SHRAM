import Foundation

let ShramFileManager = ShramFileService()

internal class ShramFileService: FileManager {
    
    internal func checkPathForResource(_ pathForResource: AnyObject) -> String? {
        
        guard pathForResource is String && fileExists(atPath: pathForResource as! String) else {
                
            guard
                let path = (pathForResource as? URL)?.path,
                fileExists(atPath: path) else {
                    
                return nil
            }
            
            return path
        }
        
        return pathForResource as? String
    }
}
