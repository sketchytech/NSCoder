//: Playground - noun: a place where people can play

import UIKit


class Book: NSObject, NSCoding {
    var title: String
    var author: String
    var pageCount: Int
    var categories: [String]
    var available: Bool
    
    init(title:String, author: String, pageCount:Int, categories:[String],available:Bool) {
        self.title = title
        self.author = author
        self.pageCount = pageCount
        self.categories = categories
        self.available = available
    }
    
    // MARK: NSCoding
    public convenience required init?(coder aDecoder: NSCoder) {
        
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let author = aDecoder.decodeObject(forKey: "author") as! String
        let categories = aDecoder.decodeObject(forKey: "categories") as! [String]
        let available = aDecoder.decodeBool(forKey: "available")
        let pageCount = aDecoder.decodeInteger(forKey: "pageCount")
        
        self.init(title:title, author:author,pageCount:pageCount,categories: categories,available:available)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(author, forKey: "author")
        aCoder.encodeCInt(Int32(pageCount), forKey: "pageCount")
        aCoder.encode(categories, forKey: "categories")
        aCoder.encode(available, forKey: "available")
    }
}

// We first of all create a class that can be initialized using an NSCoder instance and encode itself into an instance of NSCoder. And once we have this functionality, which is required by the NSCoding protocol, it is possible to create an instance that can be archived

let book = Book(title: "MyBook", author: "Me", pageCount: 10, categories: ["Fabulousness"], available: true)

let filePath = try! FileSave.buildPath(path: "bookdata", inDirectory: FileManager.SearchPathDirectory.cachesDirectory, subdirectory: "archive")
NSKeyedArchiver.archiveRootObject(book, toFile: filePath)

// and de-archived.
if let bookData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Book {
    bookData.available // true
    bookData.author // Me
}

// And equally easy to create an array of instances that can be archived and de-archived: 

let books = [Book(title: "MyBook", author: "Me", pageCount: 10, categories: ["Fabulousness"], available: true),Book(title: "YourBook", author: "You", pageCount: 10, categories: ["Fabulousness","Creativity"], available: true)]

let filePath2 = try! FileSave.buildPath(path: "bookdata2", inDirectory: FileManager.SearchPathDirectory.cachesDirectory, subdirectory: "archive")
NSKeyedArchiver.archiveRootObject(books, toFile: filePath2)

if let bookData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath2) as? [Book] {
    bookData[1].available // true
    bookData[1].title // YourBook
}