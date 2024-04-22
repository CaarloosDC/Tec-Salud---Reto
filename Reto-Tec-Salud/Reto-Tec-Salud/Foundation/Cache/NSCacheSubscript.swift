//
//  NSCacheSubscript.swift
//  Reto-Tec-Salud
//
//  Created by Javier Davila on 20/04/24.
//

import Foundation


extension NSCache where KeyType == NSString, ObjectType == CacheEntryObjectBodyPart{
    subscript(_ url: URL) -> CacheEntryBodyPart?{
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = url.absoluteString as NSString
            if let entry = newValue{
                let value = CacheEntryObjectBodyPart(entry: entry)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
