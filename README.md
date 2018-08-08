# Kodokomento

iOS Application to search Gist via QRCode and Comment on it

## Getting Started

Architecture Patterns:

* MVVM-C (MVVM + Coordinators)

* Factory Pattern

* Router Pattern

* POP


### Prerequisites

CocoaPods: https://cocoapods.org/

Install
```
  sudo gem install cocoapods
```
Run on root project folder
```
  pod install
```

### Installing

After cloned, made to installations of dependencies of CocoaPod (step above) only missing the configuration of the 'AccessControl.plist'.

This file contains the GitHubApi project keys, for security this file is not in the source control and needs to be added manually in your destination folder.

Request the same from the App developer.

Folder to Copy AccessControl.plist

```
/kodokomento/Kodokomento/Resources/Properties
```

### QRCode Creation

For create a Gist QRCode, use that value:

```
kodokomento://?gist={{Gist Id}}
```

Ex.

```
GistUrl: https://gist.github.com/rodolfohelfenstein/5dd8a4fa8a3d516529206e02811b031e

Get Gist Id in URL and replace:

QRCode Value: kodokomento://?gist=5dd8a4fa8a3d516529206e02811b031e

```

### Coding Style

Project using SwiftLint

```
https://github.com/realm/SwiftLint
```

## Known Issues and Improvement Goals

* All requests errors are already being mapped, but in some cases a notification has been missing for the user.

* Improve layout as well as layout of items such as animations to give a greater sense of fluidity

* Localization

* TESTS!!!!!!

( All described problems are known and their corrections also, what prevented them from performing was the same time 😢 )
