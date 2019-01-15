//
//  File.swift
//  WatchSyncService
//
//  Created by Anton Belousov on 15/01/2019.
//

import Foundation

extension GenericSyncService {

    public static let defaultParser = ApplicationContextParser()
    
    public static let defaultConnectivityService: IConnectivityService = {
        let connectivityService = WCSessionWrapper()// WCSessionWrapperUsingMessage()
        connectivityService.parser = defaultParser
        return connectivityService
    }()
    
    public static let `default`: GenericSyncService = {
        let service = GenericSyncService()
        service.runWith(connectivityService: defaultConnectivityService)
        return service
    }()
    
    public static func setSyncTipes(types: [ISyncItem.Type]) {
        self.defaultParser.setItemTypes(types)
    }
}


