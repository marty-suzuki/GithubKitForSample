# GithubKitForSample

This is a simple Github API client and UI to use in sample projects.

## Requirements

- Xcode 9.1
- Swift 4.0.2
- iOS 9.0
- carthage 0.23.0
- [RxSwift](https://github.com/ReactiveX/RxSwift) 4.0.0
- [SwiftIconFont](https://github.com/0x73/SwiftIconFont) 2.7.2
- [Nuke](https://github.com/kean/Nuke) 5.2

## Installation

You can install via Carthage.

```ruby: Cartfile
github "marty-suzuki/GithubKitForSample"
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
