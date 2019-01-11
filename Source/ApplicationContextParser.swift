//
//  File.swift
//  AlexWatch
//
//  Created by Anton Belousov on 10/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation
public class ApplicationContextParser {
    
    var types = [String: ISyncItem.Type]()
    public init(){}
    public func setItemTypes(_ types: [ISyncItem.Type]) {
        for type in types {
            self.types[type.syncTypeId] = type
        }
    }
    
    public func decodeItemFrom(_ context: [String : Any]) -> ISyncItem? {
        guard let rawType = context["type"] as? String,
            let value = context["value"] else {
                print(self, #function, #line, "can't parse applicationContext: \(context)")
                return nil
        }
        return types[rawType]?.instatiate(with: value)
    }
    
    public func encodeConextFrom(_ item: ISyncItem) -> [String : Any] {
        return [
            "type" : item.syncTypeId,
            "value" : item.syncValue
        ]
    }
}
