
Homework - Boris Barac

**Tools**
Xcode 11.3.1, Swift 5, SwiftPM

Architecture:
MVVM - R - N ( R-router, N - Network manager )
With Dependency Injection

**Testing**
Non UI files are covered with unit tests - App coverage is 77.5%
ViewModels coverage is over 90% - just please be carefull when checking the coverage, you get 2 coverages for UI and unit tests, the UI Test coverage is smaller.

Router tests, Network manager tests, Stubbing is in place to make the test faster, there are also Network Integration Tests in place.

I also made a couple of UI Tests to cover basic cases.

**Notes**
Most of my efforts were put to have a clean, nice and extendable architecture, and to build the project in a way that enables you to have good test coverage, and writing the tests (unit and UI)

I hope you like the project.

Best,
Boris
