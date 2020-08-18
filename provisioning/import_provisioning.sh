#!/bin/sh

# Decrypt the files
gpg --quiet --batch --yes --decrypt --passphrase="$PROVISIONING_PASSWORD" --output provisioning/DistributionCert.p12 provisioning/DistributionCert.p12.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$PROVISIONING_PASSWORD" --output provisioning/BusylessAppStore.mobileprovision provisioning/BusylessAppStore.mobileprovision.gpg

# Install provisioning profiles (which is just moving them to where Xcode can find them)
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
echo "List profiles"
ls ~/Library/MobileDevice/Provisioning\ Profiles/
echo "Move profiles"
cp provisioning/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
echo "List profiles"
ls ~/Library/MobileDevice/Provisioning\ Profiles/

# Add certificate to the keychain
security create-keychain -p "" build.keychain
security import provisioning/DistributionCert.p12 -t agg -k ~/Library/Keychains/build.keychain -P "$PROVISIONING_PASSWORD" -A
security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain
security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain