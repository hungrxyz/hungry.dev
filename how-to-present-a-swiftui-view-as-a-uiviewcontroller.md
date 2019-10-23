# How to present a SwiftUI View as a UIViewController

There is no direct way to present a SwiftUI `View` from a `UIKit` object. In order to mix SwiftUI views with UIKit view controllers in a flow, Apple provides us [`UIHostingController`](https://developer.apple.com/documentation/swiftui/uihostingcontroller). Hosting controller is essentially a container that wraps our SwiftUI `View` into a `UIViewController`, which can then be presented using standard UIKit methods (`present`, `push`, `addChild`,...).

## Example

Here we have the SwiftUI `View` we want to present:
```swift
struct HungryView : View {
    var body: some View {
        Text("Need food")
    }
}
```

In order to expose our `HungryView` to `UIKit`, we wrap it in a hosting container:
```swift
import SwiftUI

final class HungryHostingController : UIHostingController<HungryView> {

}
```
Subclassing `UIHostingController` with `Content` type of `HungryView` is enough to wrap `HungryView` into a `UIViewController`.

Now we can create a `HungryHostingController` with a `HungryView` and present it as we need:
```swift
let hungryView = HungryView()
let hungryHostingController = HungryHostingController(rootView: hungryView)

// push
navigationController.pushViewController(hungryHostingController, animated: true)

// modal
present(hungryHostingController, animated: true)
```

## Further reading
[`UIHostingController`](https://developer.apple.com/documentation/swiftui/uihostingcontroller)

[SwiftUI Tutorials - Creating and Combining Views](https://developer.apple.com/tutorials/swiftui/creating-and-combining-views)