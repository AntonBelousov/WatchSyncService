//
//  File.swift
//  AlexWatch
//
//  Created by Anton Belousov on 10/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation

public typealias ISyncItemType = String
public protocol ISyncItem {
    static var syncTypeId: ISyncItemType { get }
    var syncValue: Any { get } // Change to Abstract IPropertyListDataType (Int, String, Data etc)
    static func instatiate(with syncValue: Any) -> ISyncItem?
}

extension ISyncItem {
    var syncTypeId: ISyncItemType { return type(of: self).syncTypeId }
}

