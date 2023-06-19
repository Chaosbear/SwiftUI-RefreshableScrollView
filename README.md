# SwiftUI RefreshableScrollView

RefreshableScrollView is a component that based on SwiftUI ScrollView. 
But allow us to implement pull to refresh with the interface like our old friend (**UIRefreshControl** in UIKit).

Thank you [Kavsoft](https://www.youtube.com/watch?v=5rD5GhYVBPg&t=35s) and other articles for inspiration, this project was modified from [Kavsoft](https://www.youtube.com/watch?v=5rD5GhYVBPg&t=35s) example with techniques from other articles.

## Information

- This project isn't a library, it's just a simple view component. So you can just copy and paste it into your project.
- This component support only iOS15+. (you can use it in iOS 13-14 with some modification)
- This component support both callback and async/await.
- You can change refresh control view to any view as you desired.
- No need to add another dependency, this component is implement with only native apple api.


## Demo

Simple ProgressView        |  LottieView
:-------------------------:|:-------------------------:
![Simple ProgressView](./SwiftUI-RefresableScrollView/Resource/Demo/DemoDefault.gif)  |  ![LottieView](./SwiftUI-RefresableScrollView/Resource/Demo/DemoLottie.gif)
