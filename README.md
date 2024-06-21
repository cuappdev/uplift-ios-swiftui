# Uplift - Cornell Fitness

<p align="center"><img src="https://github.com/cuappdev/assets/blob/master/app-icons/Uplift-83.5x83.5%402x.png" width=210 /></p>

Uplift is one of the latest apps by [Cornell AppDev](http://cornellappdev.com), an engineering project team at Cornell University focused on mobile app development. Uplift aims to be the go-to fitness and wellness tool that provides information and class times for gym resources at Cornell. Download the current release on the [App Store](https://apps.apple.com/bn/app/uplift-cornell-fitness/id1439374374)!

<br />

## System Requirements

You must have at least Xcode 15.0, iOS 16.0, and Swift 5.5 to run this app.

## Dependencies

This app uses Swift Package Manager for dependencies.

## Getting Started

1. Clone the repository.
2. Go to `UpliftSecrets/` and drag the following four files into **FINDER (NOT Xcode). You must create this folder through Finder.** For AppDev members, you can find these pinned in the `#uplift-ios` Slack channel.
   - `GoogleService-Info.plist`
   - `Keys.xcconfig`
   - `apollo-codegen-config-dev.json`
   - `apollo-codegen-config-prod.json`
3. Install Swiftlint with `brew install swiftlint`. As of SP24, there is a bug with SPM involving incompatible OS versions with package dependencies. Because the codebase uses SPM, we don't want to introduce CocoaPods, so Swiftlint will be installed via Homebrew.
4. Open the **Project**, select **Uplift** under Targets, then choose the **Build Phases** tab.

- There should be a run script labeled **SwiftLint**. If not, create a **New Run Script Phase** with the following script:

```bash
if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if which swiftlint >/dev/null; then
    swiftlint --fix && swiftlint
else
    echo "ERROR: SwiftLint not installed"
    exit 1
fi

```

5. Select the `Uplift` schema to use our development server and `Uplift-Prod` to use our production server.
6. Generate the Apollo API:

- Dev: `./apollo-ios-cli generate -p "UpliftSecrets/apollo-codegen-config-dev.json" -f`
- Prod: `./apollo-ios-cli generate -p "UpliftSecrets/apollo-codegen-config-prod.json" -f`

7. Build the project and you should be good to go.

## Common Issues

- If you are unable to reproduce a new Apollo generated API folder, go to **Project > Package Dependencies** and remove `UpliftAPI`. Then, add a new **Local** package dependency that points to the `UpliftAPI` folder in the project directory.
- If the API is not working properly, try manually generating the API with the CLI.

## Codebase Outline

- **Configs**: the app environment settings, like production, staging, and development configurations.
- **Core**: the app’s entry point and LaunchScreen.
- **Models**: model objects used by the API and throughout the app.
- **Resources**: the project assets, such as fonts.
- **Services**: service helpers such as a Networking API service, CoreData, SwiftData, UserDefaults, etc.
- **Utils**: other helper files such as constants, extensions, custom errors, etc.
- **ViewModels**: our app’s view models which implement properties and commands to which the view can data bind to and notify the view of any state changes.
- **Views**: the appearance and UI of the app.
