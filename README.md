# Clean swift + MVVM
This project was started like a homework for one company, and ended up turning in to my playground for architectures, TDD, and ways of refactoring.
## Notes about the current project state
### Architecture
- I am using a version of Clean Swift with MVVM
- To avoid duplication of functionality `UseCases` are not used at the moment because in most cases they just duplicate the business logic that is typically in the view model. I see how they could be useful (extracting the business logic, and making the view model less complex), and how they could be used with ViewModel, but this project just does not have that level of complexity for that.
- UI has been set up in a typical MVVM way, but the viewModel is using `Workers`. This is achieving greater flexibility, testability and separation of concerns. 
`Workers` could be replaced by `Managers` in some apps, especially if the set of the actions user can do is limited, and repeating. Typical example of this are video apps, that support multiple users, multiple profiles and have a offline mode. Actions are generic, but number pre-actions needed ca get big and quite complex.
- `Workers` are using the network manager to get the data they need
- Navigation is done using a `Router` that is based on `Presenter` in CLEAN SWIFT, with extension of having `Routes`. Every screen has it's own route. This is done mostly so we can easily unit test the navigation logic against preconditions (like isLoggedIn, hasIAP, ...). Based on the route, and parameters of the route (destination, presentation style, ...) navigation is done, and the screen is changed.
## Tests
### Unit Tests
- Code coverage is quite big, ViewModel coverage is over 90%, navigation is tested, as is the network layer.
- When we talk about mocking in the tests there are 2 approaches here, both with advantages and disadvantages.
- Mocks based on PROTOCOLS, this is used in DetailWorker, the worked is mocked in the tests of the viewModel where it is used, and it works great, gives us great flexibility. So this is approach is more a `UNIT` approach, and is amazing especially with more complex components.
- The other approach we could use in this case is to treat the ViewModel tests like 1 unit, and test the sub-components with it. This way we get a integration test of the viewModel, and we get to test the sub-components (like workers) for free. This approach is used in the Main view model. This is good for testing of simple components and if we want to save some time writing tests. U can see the coverage of StreamWorker and ListWorker is over 90%, and they do not have specific tests. What we can also do in this case to make our test faster and more controlled is to STUB the API calls that are being used by the workers and the view model. `Stubbing` is great power, but we should be careful not to over use it. Use of mock servers is also great, and gives us great power with integration tests (i could talk about this for hours).
- API calls are being mocked of stubbed in most places, but the Network manager tests are working against the real API to detect problems caused by BE changes.
### UI Tests
- Base user scenarios are also covered by UI tests.

## Improvements
- Refactor this to SwiftUI
- Use Combine (unfortunately no RX at the moment)
- With the use of SwiftUI change the base architecture to a REDUX variant of VIP
- In my current experience with SwiftUI, REDUX architectures work great because SwiftUI is already heavily based on states.
- Base the app navigation around Actions (So far i had a lot of problems with swiftUI views and navigation based on presenters)