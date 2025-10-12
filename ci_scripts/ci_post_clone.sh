#!/bin/sh

#  ci_post_clone.sh
#  Uplift
#
#  Created by Vin Bui on 1/6/24.
#  Copyright © 2024 Cornell AppDev. All rights reserved.

echo "Installing Swiftlint via Homebrew"
brew install swiftlint

echo "Downloading Secrets"
brew install wget
cd $CI_PRIMARY_REPOSITORY_PATH/ci_scripts
mkdir ../UpliftSecrets
wget -O ../UpliftSecrets/apollo-codegen-config-dev.json "$CODEGEN_DEV"
wget -O ../UpliftSecrets/apollo-codegen-config-prod.json "$CODEGEN_PROD"
wget -O ../UpliftSecrets/Keys.xcconfig "$KEYS"
wget -O ../UpliftSecrets/GoogleService-Info.plist "$GOOGLE_PLIST"
wget -O ../UpliftSecrets/schema.graphqls "$GRAPHQL_SCHEMA"

echo "Generating API file"
../apollo-ios-cli generate -p "../UpliftSecrets/apollo-codegen-config-prod.json" -f

echo "Deleting Xcode Configurations"
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution
