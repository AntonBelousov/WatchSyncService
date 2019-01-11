//
//  ConnectivityServiceTestCase.swift
//  AlexWatchTests
//
//  Created by Anton Belousov on 10/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import XCTest

class ConnectivityServiceTestCase: XCTestCase {

    let connector = ConnectivityServicesConnector()
    let serviceA = MockConnectivityService()
    let serviceB = MockConnectivityService()
    
    let genericSyncServiceA = GenericSyncService()
    let genericSyncServiceB = GenericSyncService()
    
    override func setUp() {
        connector.runWith(serviceA: serviceA, serviceB: serviceB)
        
        let parser = ApplicationContextParser()
        parser.setItemTypes([
            RemindersFrequency.self,
            ])
        serviceA.parser = parser
        serviceB.parser = parser
        
        genericSyncServiceA.runWith(connectivityService: serviceA)
        genericSyncServiceB.runWith(connectivityService: serviceB)
    }

    func testSendReminderFrequency_lowLevel() {
        let fr1 = RemindersFrequency.hour
        serviceA.send(item: fr1)
        XCTAssertEqual(serviceB.lastItem as? RemindersFrequency, fr1)
    }
    
    func testSendReminderFrequency_highLevel() {
        let fr1 = RemindersFrequency.hour
        let item = fr1
        
        let expectation = self.expectation(description: "ex")
        
        genericSyncServiceB.onReceived(type: RemindersFrequency.self) { (item) in
            XCTAssertEqual(item, fr1)
            expectation.fulfill()
        }
        
        genericSyncServiceA.send(item)
        wait(for: [expectation], timeout: 0.001)

    }
    
    func testParse() {
        let timer = TimerItem(name: "azaza", colorHex: "112233")
        let range = TimerRange(start: 123, end: 345)
        timer.ranges = [range]
        let timers = [timer]

        let syncValue = timers.syncValue
        
        let type = [TimerItem].self
        let parsedValue = type.instatiate(with: syncValue) as? [TimerItem]
        XCTAssertEqual(parsedValue, timers)
    }
}
