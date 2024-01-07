#!/bin/sh

#  ci_post_clone.sh
#  Uplift
#
#  Created by Vin Bui on 1/6/24.
#  Copyright © 2024 Cornell AppDev. All rights reserved.

echo "Installing Cocoapods Dependencies"
brew install cocoapods
pod deintegrate
pod install

echo "Installing Apollo Client Dependencies"
brew install node
npm install -g apollo
npm install -g graphql

echo "Downloading Secrets"
brew install wget
cd $CI_WORKSPACE/ci_scripts
mkdir ../UpliftSecrets
wget -O ../UpliftSecrets/apollo-codegen-config-dev.json "$CODEGEN_DEV"
wget -O ../UpliftSecrets/apollo-codegen-config-prod.json "$CODEGEN_PROD"
wget -O ../UpliftSecrets/Keys.xcconfig "$KEYS"
wget -O ../UpliftSecrets/schema.graphqls "$SCHEMA"
