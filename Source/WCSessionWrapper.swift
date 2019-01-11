//
//  File.swift
//  AlexWatch
//
//  Created by Anton Belousov on 10/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation
import WatchConnectivity

public class WCSessionWrapper: NSObject, IConnectivityService {
    var session: WCSession?
    var onReceiveHandler: (ISyncItem) -> () = {_ in }
    public var parser: IApplicationContextParser!
    
    public func run() {
        if session?.activationState == .activated {
            return
        }
        if WCSession.isSupported() { //makes sure it's not an iPad or iPod
            let watchSession = WCSession.default
            watchSession.delegate = self
            watchSession.activate()
            #if os(iOS)
            if watchSession.isPaired && watchSession.isWatchAppInstalled {
                session = watchSession
            }
            #else
            session = watchSession
            #endif
        }
    }
    
    public func send(item: ISyncItem) {
        run()
        guard let session = self.session else {
            print(self, #function, #line, "there is no session")
            return
        }
        do {
            try session.updateApplicationContext(parser.encodeConextFrom(item))
            
        } catch let error as NSError {
            print(self, #function, #line, error.description)
        }
    }
    
    public func onReceive(handler: @escaping (ISyncItem) -> ()) {
        onReceiveHandler = handler
    }
}

extension WCSessionWrapper: WCSessionDelegate {
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {}
    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let item = parser.decodeItemFrom(applicationContext) {
            onReceiveHandler(item)
        }
    }
}
