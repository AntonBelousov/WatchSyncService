//
//  TestingModel.swift
//  AlexWatchTests
//
//  Created by Anton Belousov on 11/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import Foundation

enum RemindersFrequency: Int {
    case never = 846_000_000
    case min   = 60
    case min5  = 300
    case min15 = 900
    case min30 = 1800
    case hour  = 3600
}

extension RemindersFrequency {
    var title: String {
        switch self {
        case .never:
            return "Never"
        case .hour:
            return "Hour"
        default:
            return "\(self.rawValue/60) min"
        }
    }
}

extension RemindersFrequency: ISyncItem {
    public static var syncTypeId: ISyncItemType {
        return "frequency"
    }
    
    public var syncValue: Any {
        return rawValue
    }
    
    public static func instatiate(with syncValue: Any) -> ISyncItem? {
        if let int = syncValue as? Int {
            return RemindersFrequency(rawValue: int)
        }
        return RemindersFrequency.never
    }
}

public class TimerItem: Codable {
    var id       = UUID()
    var name     = ""
    var colorHex = ""
    var ranges = [TimerRange]()
    init(name: String, colorHex: String) {
        self.name     = name
        self.colorHex = colorHex
    }
}

extension TimerItem: Hashable {
    public static func == (lhs: TimerItem, rhs: TimerItem) -> Bool {
        return lhs.id == rhs.id
    }
    public var hashValue: Int { return id.hashValue }
}

class TimerRange: Codable {
    var start: TimeInterval = Date().timeIntervalSince1970
    var end: TimeInterval?
    
    init() {}
    
    convenience init(start: TimeInterval, end: TimeInterval? = nil) {
        self.init()
        self.start = start
        self.end = end
    }
    
    
    func stop() {
        end = Date().timeIntervalSince1970
    }
    
    var timeInterval: TimeInterval {
        return (end ?? Date().timeIntervalSince1970) - start
    }
}

extension Array: ISyncItem where Element == TimerItem {
    public static var syncTypeId: ISyncItemType {
        return "timers"
    }
    
    public var syncValue: Any {
        return try! JSONEncoder().encode(self)
    }
    
    public static func instatiate(with syncValue: Any) -> ISyncItem? {
        return AnyWrapper(value: syncValue).data?.decodeJSON(as: [TimerItem].self)
    }
}

struct AnyWrapper {
    var value: Any?
    var data: Data? { return value as? Data }
}

extension Data {
    func decodeJSON<T: Decodable>(as type: T.Type = T.self) -> T? {
        return try? tryDecodeJSON(as: type)
    }
    func tryDecodeJSON<T: Decodable>(as type: T.Type = T.self) throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
