fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios ci
```
fastlane ios ci
```
CI entrypoint
### ios buildPullrequest
```
fastlane ios buildPullrequest
```
Build for a pullrequest
### ios buildDevelop
```
fastlane ios buildDevelop
```
build for merge to develop
### ios buildLocal
```
fastlane ios buildLocal
```
Run test
### ios buildRelease
```
fastlane ios buildRelease
```
Release app

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
