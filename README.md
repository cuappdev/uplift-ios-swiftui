# Uplift - Cornell Fitness

<p align="center"><img src=https://raw.githubusercontent.com/cuappdev/uplift-ios/master/Uplift/Assets.xcassets/AppIcon.appiconset/ItunesArtwork%402x.png width=210 /></p>

Uplift is one of the latest apps by [Cornell AppDev](http://cornellappdev.com), an engineering project team at Cornell University focused on mobile app development. Uplift aims to be the go-to fitness and wellness tool that provides information and class times for gym resources at Cornell. Download the current release on the [App Store](https://apps.apple.com/bn/app/uplift-cornell-fitness/id1439374374)!

<br />

## System Requirements

You must have at least Xcode 15.0, iOS 16.0, and Swift 5.5 to run this app.

## Dependencies

This app uses CocoaPods and Swift Package Manager for dependencies.

## Getting Started

1. Clone the repository.
2. Go to `UpliftSecrets/` and drag the following four files into **FINDER (NOT Xcode). You must create this folder through Finder.** For AppDev members, you can find these pinned in the `#uplift-ios` Slack channel.
    - `GoogleService-Info.plist`
    - `Keys.xcconfig`
    - `apollo-codegen-config-dev.json`
    - `apollo-codegen-config-prod.json`
3. Run `pod install` to install dependencies via CocoaPods. If you do not have CocoaPods installed, you can install it using `sudo gem install cocoapods`.
4. Open the **Workspace**, select **Uplift** under Targets, then choose the **Build Phases** tab.

  - There should be a run script labeled **SwiftLint**. If not, create a **New Run Script Phase** with the following script:

```bash
"${PODS_ROOT}/SwiftLint/swiftlint"

if which swiftlint >/dev/null; then
    swiftlint --fix && swiftlint
else
    echo "WARNING: SwiftLint not installed"
fi
```

  - There should also be another run script labeled **Generate API** If not, create a **New Run Script Phase** with the following script:

```bash
CLI_PATH="./apollo-ios-cli"
SECRETS_PATH="${SRCROOT}/UpliftSecrets"

if [ "${CONFIGURATION}" != "Release" ]; then
  CONFIG_PATH="${SECRETS_PATH}/apollo-codegen-config-dev.json"
fi

if [ "${CONFIGURATION}" = "Release" ]; then
  CONFIG_PATH="${SECRETS_PATH}/apollo-codegen-config-prod.json"
fi

"${CLI_PATH}" generate -p "${CONFIG_PATH}" -f
```

5. Download and install [Apollo](https://www.apollographql.com/docs/devtools/cli/) and GraphQL with the following commands. You will need to have Node’s NPM installed on your device.
    - `npm install -g apollo`
    - `npm install -g graphql`

6. Select the `Uplift` schema to use our development server and `Uplift-Prod` to use our production server.
7. Run the following code: `./apollo-ios-cli generate -p "UpliftSecrets/apollo-codegen-config-dev.json" -f`
8. Build the project and you should be good to go.
    
## Common Issues

If you are unable to reproduce a new Apollo generated API file, go to **Project > Package Dependencies** and remove `UpliftAPI`. Then, add a new **Local** package dependency that points to the `UpliftAPI` folder in the project directory.

## Codebase Outline

- **Configs**: the app environment settings, like production, staging, and development configurations, all using the .xcconfig files.
- **Core**: the app’s entry point.
- **Models**: model objects used by the API and throughout the app.
- **Resources**: the project assets, LaunchScreen.storyboard, etc.
- **Services**: service helpers such as a Networking API service, CoreData, SwiftData, UserDefaults, etc.
- **Utils**: other helper files such as constants, extensions, custom errors, etc.
- **ViewModels**: our app’s view models which implement properties and commands to which the view can data bind to and notify the view of any state changes.
- **Views**: the appearance and UI of the app.
