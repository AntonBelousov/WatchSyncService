//
//  File.swift
//  AlexWatch
//
//  Created by Anton Belousov on 10/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation

public protocol IConnectivityService {
    func run()
    func send(item: ISyncItem)
    func onReceive(handler: @escaping (ISyncItem) -> ())
}
