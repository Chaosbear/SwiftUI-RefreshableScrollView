# SwiftUI RefreshableScrollView

RefreshableScrollView is a component that wraps SwiftUI ScrollView with a refreshable modifier. 
But allow us to implement pull to refresh with the interface like **UIRefreshControl** in UIKit.

## Information

- This project isn't a library, it's just a simple view component. So you can just copy and paste it into your project.
- This component supports only iOS16+, which refreshable modifier is available on ScrollView.
- This component supports both callback and async/await.
- You can change refresh control view to any view as you desired.
- No need to add another dependency, this component is implemented with only native apple api.


## Demo

Simple ProgressView        |  LottieView
:-------------------------:|:-------------------------:
![Simple ProgressView](./SwiftUI-RefresableScrollView/Resource/Demo/DemoDefault.gif)  |  ![LottieView](./SwiftUI-RefresableScrollView/Resource/Demo/DemoLottie.gif)
