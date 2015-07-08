//
//  JSONConvertible.swift
//  ProjectNolan
//
//  Created by Mustafa Yusuf on 7.07.2015.
//  Copyright © 2015 Mustafa Yusuf. All rights reserved.
//

public typealias JSON = AnyObject

public protocol JSONConvertible {
    func toJSON() throws -> JSON
}

public extension JSONConvertible {
    func toJSON() throws -> JSON {
        let mirror = Mirror(reflecting: self)
        var json = [String: JSON]()
        for child in mirror.children {
            guard let value = child.value as? JSONConvertible else {
                let mirror = reflect(child.value)
                throw JSONConversionError.TypeIsNotConvertibleToJSON(typeName: mirror.summary)
            }
            
            json[child.label!] = try value.toJSON()
        }
        
        return json
    }
}

extension String: JSONConvertible {
    public func toJSON() throws -> JSON {
        return self
    }
}

extension Int: JSONConvertible {
    public func toJSON() throws -> JSON {
        return self
    }
}

extension Double: JSONConvertible {
    public func toJSON() throws -> JSON {
        return self
    }
}

extension Float: JSONConvertible {
    public func toJSON() throws -> JSON {
        return Double(self)
    }
}

extension Bool: JSONConvertible {
    public func toJSON() throws -> JSON {
        return self ? 1 : 0
    }
}

extension Optional: JSONConvertible {
    public func toJSON() throws -> JSON {
        switch self {
        case let .Some(val):
            guard let value = val as? JSONConvertible else {
                let mirror = reflect(val)
                throw JSONConversionError.TypeIsNotConvertibleToJSON(typeName: mirror.summary)
            }
            return try value.toJSON()
        case .None:
            return NSNull()
        }
    }
}

extension NSURL: JSONConvertible {
    public func toJSON() throws -> JSON {
        return self.absoluteString
    }
}

extension Array: JSONConvertible {
    public func toJSON() throws -> JSON {
        var jsonArray = [JSON]()
        
        for item in self {
            if let item = item as? JSONConvertible {
                jsonArray.append(try item.toJSON())
            } else {
                let mirror = reflect(item)
                throw JSONConversionError.TypeIsNotConvertibleToJSON(typeName: mirror.summary)
            }
        }
        
        return jsonArray
    }
}

extension NSDate: JSONConvertible {
    public func toJSON() throws -> JSON {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter.stringFromDate(self)
    }
}
