# Stories

This is a sample application just to exercise the process of creating a stories module of an app.
Currently it is very simple and only accepts using pictures as stories data.

Mocked data is stored in [ActiveStores.json](Stories/ActiveStoriesUseCase/Resources/ActiveStories.json) file.

This sample makes use of the following patterns:

* [ViewCode]() to create the app's UI.
* [Coordinator](https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps) to control the flow of stories.
* [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) to organize the structure of the project.

## Dependencies

* [KingFisher](https://github.com/onevcat/Kingfisher) to download story pictures.