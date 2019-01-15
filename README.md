# WatchSyncService
This framework is needed to facilitate the work on data synchronization between iOS and watchOS. It's ready to use on both platforms and you use it simultaneously on both platforms.

# Installation
pod 'WatchSyncService'

# Example

### Model

```
enum State: Int {
    case idle
    case waiting
    case failed
    case succeeded
}

extension State: ISyncItem {
    // should be unique across all item types
    static var syncTypeId: ISyncItemType {
        return "state"
    }
    
    // you should return property-list data types (numbers, string, data etc)
    var syncValue: Any {
        return self.rawValue
    }
    
    static func instatiate(with syncValue: Any) -> ISyncItem? {
        if let rawValue = syncValue as? Int {
            return State(rawValue: rawValue)
        }
        return State.idle
    }
}

```

### Using service
```

// listen incoming messages (on both iOS and watchOS)
GenericSyncService.setSyncTipes(types: [State.self]) // On both iOS and watchOS apps

GenericSyncService.default.onReceived(type: State.self) { (state) in
    print("state received: ", state.rawValue)
}

// send message (on both iOS and watchOS)
GenericSyncService.default.send(State.waiting)

```

## Flexibility

You can use any types for `ISyncItem`: classes, structs, enums. For example, arrays:

```
public class User: Codable {
    var id       = UUID()
    var name     = ""
    var children = [User]()
    init(name: String) {
        self.name = name
    }
}

extension Array: ISyncItem where Element == User {
    public static var syncTypeId: ISyncItemType {
        return "users"
    }
    
    public var syncValue: Any {
        return try! JSONEncoder().encode(self)
    }
    
    public static func instatiate(with syncValue: Any) -> ISyncItem? {
        if let data = syncValue as? Data {
            return try? JSONDecoder().decode([User].self, from: data)
        }
        return nil
    }
}

let child = User(name: "Ivan")
let father = User(name: "Alex")
father.children = [child]

GenericSyncService.setSyncTipes(types: [User.self])

GenericSyncService.default.onReceived(type: [User].self) { (users) in
    print("received users")
}

GenericSyncService.default.send([father])

```


