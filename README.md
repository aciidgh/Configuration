# Configuration

An example of how to use swift for writing configuration/manifest files. This is how SwiftPM parses Package.swift

The basic concept is:

1. Create a `Config` module and its product (dynamic library).
2. Have a method to dump `Config` data structure to a serializable format. I used JSON in this example.
3. Invoke swift interpreter with the config product linked and dump JSON on exit.
4. Read back the JSON and re-create the Config model.
