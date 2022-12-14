# mbition-ios

MBition tech challenge

Description:
- Language: Swift
- Architecture: MVVM + Combine
- UI: UIKit (built programmatically with declarative approach)

Implementation details:
- namespaces
- service layer:
    - generic network / endpoints
    - generic cache (with image cache implementation);
    - image loader;
    - user list service;
    - user details service;
    - universal logger;
- codable models
- UI-agnostic view models
- UI:
    - pull-to-refresh on user list
    - user avatar placeholder
    - in-memory user avatar caching
- helpers:
    - generic & reactive pagination (UISource, Sink)
    - universal UI for error handling (BannerView)
    - reusable Combine extension
    - universal activity indicator
- tests:
    - unit tests for view models
    - unit tests for services
    - unit tests for pagination
    - integration and unit-tests for the network
    - bare minimum testing for view controllers and views

Potential improvements:
- add splash-screen
- generic navigation approach + unit-tests
- generic font scheme to support white-label
- network availability + UI
- support landscape device orientation
- CI / CD