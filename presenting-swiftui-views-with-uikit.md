# Presenting SwiftUI Views with UIKit

When we want to present a SwiftUI `View` from `UIViewController`, Apple provides us [`UIHostingController`](https://developer.apple.com/documentation/swiftui/uihostingcontroller). Which is essentially a container object that wraps our SwiftUI `View` into a `UIViewController` object. An instance of our hosting controller can then be presented modally or pushed onto a navigation stack as any other `UIViewController`. 

Let's look at an example...

Here we have the SwiftUI `View` we want to present:
```swift
struct HungryView : View {
    var body: some View {
        Text("Need food")
    }
}
```

In order to expose our `HungryView` to `UIKit` objects, we can wrap it in view controller:
```swift
import SwiftUI

class HungryHostingController : UIHostingController<HungryView> { }
```
Subclassing `UIHostingController` with `Content` type of `HungryView` is enough for compiler to infer 