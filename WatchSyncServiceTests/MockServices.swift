//
//  File.swift
//  AlexWatchTests
//
//  Created by Anton Belousov on 11/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation

class MockConnectivityService: IConnectivityService {
    
    var onReceiveHandler: (ISyncItem) -> () = {_ in}
    var onSendHandler: ([String: Any]) -> () = {_ in}
    var parser: ApplicationContextParser!
    
    var lastItem: ISyncItem? {
        didSet {
            print(lastItem ?? "nil")
        }
    }
    func receive(_ applicationContext: [String: Any]) {
        if let item = parser.decodeItemFrom(applicationContext) {
            lastItem = item
            onReceiveHandler(item)
        }
    }
    
    func run() {}
    func send(item: ISyncItem) {
        print(#function, item)
        onSendHandler(parser.encodeConextFrom(item))
    }
    func onReceive(handler: @escaping (ISyncItem) -> ()) {
        onReceiveHandler = handler
    }
}

class ConnectivityServicesConnector {
    func runWith(serviceA: MockConnectivityService, serviceB: MockConnectivityService) {
        serviceA.onSendHandler = {
            item in
            print(#function, item)
            serviceB.receive(item)
        }
        serviceB.onSendHandler = {
            item in
            print(#function, item)
            serviceA.receive(item)
        }
    }
}
