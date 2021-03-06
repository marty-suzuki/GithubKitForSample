# GithubKitForSample

This is a simple Github API client and UI to use in sample projects.

## Requirements

- Xcode 12
- Swift 5
- iOS 13.0

## Installation

You can install via Carthage.

```ruby: Cartfile
github "marty-suzuki/GithubKitForSample"
```

You can install via Cocoapods.

```ruby: Cartfile
pod 'GithubKitForSample', :git => 'https://github.com/marty-suzuki/GithubKitForSample.git'
```

You can install via Swift Package Manager.

Simply add the following line to your `Package.swift`:

```
.package(url: "https://github.com/marty-suzuki/GithubKitForSample.git", from: "version")
```

## Usage

```swift
import GithubKit

ApiSession.shared.token = "/* Your Token */"

/// - note: You can search users.
let request = SearchUserRequest(query: "marty-suzuki", after: nil)
ApiSession.shared.send(request) {
    switch $0 {
    case .success(let value):
        //
    case .failure(let error):
        //
    }
}

/// - note: You can fetch user's repositories.
let request = UserNodeRequest(id: user.id, after: nil)
ApiSession.shared.send(request) {
    switch $0 {
    case .success(let value):
        //
    case .failure(let error):
        //
    }
}
```

## Layout

### UserViewCell
![user](./Images/image1.png)

### RepositoryViewCell
![repository](./Images/image2.png)

## Special Thanks
- https://primer.style/octicons/
