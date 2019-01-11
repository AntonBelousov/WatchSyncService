//
//  File.swift
//  AlexWatch
//
//  Created by Anton Belousov on 10/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation

class ISyncItemHandler: NSObject {
    var typeId: String = ""
    func handleItem(_ item: ISyncItem) {}
}

class SyncItemHandler<T: ISyncItem>: ISyncItemHandler {
    let handlerBlock: (T) -> ()
    init(itemType: T.Type, handlerBlock: @escaping (T) -> ()) {
        self.handlerBlock = handlerBlock
        super.init()
        typeId = itemType.syncTypeId
    }
    override func handleItem(_ item: ISyncItem) {
        if let item = item as? T {
            handlerBlock(item)
        }
    }
}
