//
//  GenericSyncService.swift
//  AlexWatch
//
//  Created by Anton Belousov on 10/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation
import WatchConnectivity

public class GenericSyncService: NSObject {    
    private var connectivityService: IConnectivityService?
    
    private var handlers = [ISyncItemType: ISyncItemHandler]()

    public func runWith(connectivityService: IConnectivityService) {
        self.connectivityService = connectivityService
        
        connectivityService.onReceive(handler: { (item) in
            if let handler = self.handlers[item.syncTypeId] {
                handler.handleItem(item)
            }
        })
        
        connectivityService.run()
    }
    
    public func send(_ item: ISyncItem) {
        connectivityService?.send(item: item)
    }
    
    public func onReceived<T: ISyncItem>(type: T.Type, handlerBlock: @escaping (T) -> ()) {
        handlers[type.syncTypeId] = SyncItemHandler(itemType: type, handlerBlock: handlerBlock)
    }
}
