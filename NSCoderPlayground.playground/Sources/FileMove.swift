import Foundation

public struct FileMove {
    // if a file exists at the old path and doesn't exist at the new path then the file is move
    public static func move(fromPath:String, fromDirectory:FileManager.SearchPathDirectory,  fromSubdirectory:String?, toPath:String, toDirectory:FileManager.SearchPathDirectory,  toSubdirectory:String?) throws {
     
        let oldPath = buildPath(path: fromPath, inDirectory: fromDirectory, subdirectory: fromSubdirectory)
        let newPath = buildPath(path: toPath, inDirectory: toDirectory, subdirectory: toSubdirectory)
        if let newDirectory = NSURL(fileURLWithPath: newPath).deletingLastPathComponent
        {
        try FileManager.default.createDirectory(at: newDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        if FileManager.default.fileExists(atPath: oldPath) && !FileManager.default.fileExists(atPath: newPath) {
        try FileManager.default.moveItem(at: NSURL(fileURLWithPath: oldPath) as URL, to: NSURL(fileURLWithPath: newPath) as URL)
        }
    }
    
    private static func buildPath(path:String, inDirectory directory:FileManager.SearchPathDirectory, subdirectory:String?) -> String  {
        // Remove unnecessary slash if need
        let newPath = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: path)
        var subDir:String?
        if let sub = subdirectory {
            subDir = FileHelper.stripSlashIfNeeded(stringWithPossibleSlash: sub)
        }
        
        // Create generic beginning to file load path
        var loadPath = ""
        
        if let direct = FileDirectory.applicationDirectory(directory: directory),
            let path = direct.path {
                loadPath = path + "/"
        }
        
        if let sub = subDir {
            loadPath += sub
            loadPath += "/"
        }
        
        
        // Add requested load path
        loadPath += newPath
        return loadPath
    }
}
