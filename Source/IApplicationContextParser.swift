//
//  File.swift
//  AlexWatch
//
//  Created by Anton Belousov on 10/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation

public protocol IApplicationContextParser {
    func encodeConextFrom(_ item: ISyncItem) -> [String: Any]
    func decodeItemFrom(_ context: [String: Any]) -> ISyncItem?
}
