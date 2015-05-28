# BuiltInADay

Helper for Rome plugin for CocoaPods to create universal binaries.

* [Rome](https://github.com/neonichu/Rome)

# How To Run

The main script is `build_all.sh` which runs the `pod` command with
the -no-integrate switch so that it just creates the Pods folder with 
everything that is needed to build the pods as frameworks. Then each
pod is built by calling `build_universal.sh` by providing the product name
as an argument.

# Known Issues

* The FormatterKit pod has trouble with building which may be the project itself.

# License

MIT

# Credits

Brennan Stehling (@smallsharptools)
