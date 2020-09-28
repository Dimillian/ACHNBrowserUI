[![Swift 5.3](https://img.shields.io/badge/swift-5.3-ED523F.svg?style=flat)](https://swift.org/download/)
![Xcode build](https://github.com/Dimillian/ACHNBrowserUI/workflows/Xcode%20build/badge.svg)
[![@ACHelperApp](https://img.shields.io/badge/contact-@ACHelperApp-5AA9E7.svg?style=flat)](https://twitter.com/achelperapp)
[![@dimillian](https://img.shields.io/badge/contact-@dimillian-5AA9E7.svg?style=flat)](https://twitter.com/dimillian)

[You can now download the app on the App Store!](https://apps.apple.com/us/app/ac-helper/id1508764244?ls=1)

The best Animal Crossing New Horizons companion app! 

最高の「あつまれ どうぶつの森」コンパニオンアプリ

# Animal Crossing New Horizon SwiftUI application!

![Image](images/promo3.png?)

# Important notes:
The project `main` branch is now updated to `Xcode 12 beta 1`. 

There is a lot of SwiftUI issues that will be worked on as new betas arrive. For now it compile and will use the best & latest features of Swift 5.3 and SwiftUI.

If you want to compile using the stable version of Xcode (11), you can checkout the `legacy` branch. This is the branch used to ship the app on the App Store until iOS 14 is released.

# Features
This is a full featured Animal Crossing helper application written entirely in SwiftUI.

* Configureable dashboard to track your fishes, bugs, collection progress, active events, daily tasks, todos and much more.
* See the active critters this month and catch em all! 
* Music player for K.K. Slider's songs - plays when app is in background!
* Turnips price tracking and predictions with daily push notifications. 
* Turnip.exchange integration.
* Nookazon integration. 
* Full catalog browser with filter, sorting and search.
* Villagers list.
* Bookmark anything in the app to add it to your collection.
* Spotlight support for fishes, bugs, fossils and art
* iCloud sync for collection progress, lists, tasks and todos.
* Localized to English, French, German; Japanese and Chinese (TW) in progress - see [#68](https://github.com/Dimillian/ACHNBrowserUI/issues/68) to help us extend localization to missing languages
* iOS, iPad and macOS (Catalyst support)!

You can use this application to learn about SwiftUI and Combine. It uses a very standard view, and view model architecture with full use of @State, @Binding, @Published, Observed and Observable object. 

## Localizations Credits

* **Chinese, Simplified**: kartbnb [Github](https://github.com/kartbnb)
* **Chinese, Taiwan**: klin0816 [Github](https://github.com/klin0816)
* **French**: Dimillian [Github](https://github.com/Dimillian) | [Twitter](https://twitter.com/Dimillian) 
* **German**: TheVaan [Github](https://github.com/TheVaan) | [Twitter](https://twitter.com/TheVaan)
* **Italian**: MrOgeid [Github](https://github.com/MrOgeid)
* **Japanese**: mimikun [Github](https://github.com/mimikun) | [Mastodon](https://mstdn.mimikun.jp/@mimikun) | [Twitter](https://twitter.com/mimikun_Dev)
* **Spanish**: Mauro [Twitter](https://twitter.com/mauroocb_)
* **Russian**: MariaFeodora [Github](https://github.com/MariaFeodora)

## Credits

This is just a very simple SwiftUI application, all the database hard work has been done on the [master sheet](https://docs.google.com/spreadsheets/d/1Hxrdp7oxtK-J5x9u1-rzChUpLtkv3t0_kNGdS6dtyWI/edit#gid=2031086626) by the community. 

And [u/Azarro](https://www.reddit.com/user/Azarro/) made an awesome JSON API from that google sheet. (private for now).

As the API is private the app use a local dump of the API at the moment. 

Thanks to [Turnip.exchange](https://turnip.exchange/) for the turnips exchange API.

Thanks to [ACNH API](http://acnhapi.com/) for the API that allow us to display villagers and their icons/images.

Thanks to [Nookazon](https://nookazon.com/) for item listings and trading platform. 

Thanks to [Shihab](https://twitter.com/JPEGuin) for the app icons.

Thanks to [imthe666st](https://github.com/imthe666st/ACNH) for the repository with localized data.
