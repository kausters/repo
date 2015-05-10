# Zupa Repo

This is the package content and build script for the Zupa Repo Cydia repository found at http://repo.kristapsausters.lv

# Packages

## Key Addons (iOS 6 – iOS 8)

Adds custom symbols to keyboards.

## LV Key Cleaner (iOS 4 – iOS 8)

Removes extended-Latin characters from the English keyboard and non-Latvian characters from the Latvian keyboard.

This ensures that there are no non-Latvian accents under keys in Latvian keyboard even when it's used in combination with the English keyboard. It works by letting English QWERTY keyboard hold only ASCII characters and Latvian keyboard only ASCII and Latvian accent characters.

## LV Key Speeder (iOS 4 – iOS 8)

Removes non-accented characters from Latvian keyboard's key accent menus.

This ensures that accents are instantly under the finger, making accent activation much faster.

# Building

To build packages, run `make.sh` from root folder. If successful, the packages will be placed into the upload/deb folder.
