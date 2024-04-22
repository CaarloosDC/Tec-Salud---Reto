//
//  NSCache.swift
//  Reto-Tec-Salud
//
//  Created by Javier Davila on 19/04/24.
//

import Foundation


final class CacheEntryObjectBodyPart{
    let entry: CacheEntryBodyPart
    init(entry: CacheEntryBodyPart) {
        self.entry = entry
    }
}

enum CacheEntryBodyPart{
    case inProgress(Task<[BodyPart], Error>)
    case ready ([BodyPart])
}
