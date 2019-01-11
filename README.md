# WatchSyncService
This framework is needed to facilitate the work on data synchronization between ios and watchOS

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

### Assembly Services

```
class SyncServiceAssembly {
 
    static let service = GenericSyncService(withTypes: [
        State.self
        ])
}

extension GenericSyncService {
    convenience init(withTypes types: [ISyncItem.Type]) {
        self.init()
        
        let parser = ApplicationContextParser()
        parser.setItemTypes(types)

        let connectivityService = WCSessionWrapper()
        connectivityService.parser = parser
        
        self.runWith(connectivityService: connectivityService)
    }
}

```

### Using service
```

// listen incoming messages (on both iOS and watchOS)
SyncServiceAssembly.service.onReceived(type: State.self) { (state) in
    print("state received: ", state.rawValue)
}

// send message (on both iOS and watchOS)
SyncServiceAssembly.service.send(State.waiting)

```
