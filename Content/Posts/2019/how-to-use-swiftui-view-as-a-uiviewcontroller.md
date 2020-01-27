---
layout: default
---

# How to use SwiftUI View as a UIViewController

There is no direct way of using SwiftUI `View` as a `UIViewController`, nor is there a direct way to use `UIViewController` as a SwiftUI `View`. To make former possible, Apple provides us `UIHostingController` which acts as container `UIViewController` for the SwiftUI `View`.

## Example

Here we have a SwiftUI `View` we want to use as `UIViewController`: `HungryView`. It looks like this:
```swift
struct HungryView : View {
    var body: some View {
        Text("Need food")
    }
}
```

In order to expose `HungryView` to `UIKit`, we wrap it in a `UIHostingController` like this:
```swift
import SwiftUI

final class HungryHostingController : UIHostingController<HungryView> {

}
```
Subclassing `UIHostingController` with `Content` type of `HungryView` is enough to wrap `HungryView` into a `UIViewController`.

Now we can create a `HungryHostingController` object with an instance of `HungryView` and use it as any normal `UIViewController`. In this example we push it on a navigation stack like this:
```swift
let hungryView = HungryView()
let hungryHostingController = HungryHostingController(rootView: hungryView)

navigationController.pushViewController(hungryHostingController, animated: true)
```

And that's all it takes to use your shiny new SwiftUI `View` like an oldfashined `UIViewController`. 

