import PackageDescription

let package = Package(
    name: "Configuration",
    targets: [
        Target(name: "Config"),
        Target(name: "ConfigLoader", dependencies: ["Basic", "Config"]),
        Target(name: "Exe", dependencies: ["ConfigLoader"]),
        Target(name: "libc"),
        Target(name: "POSIX", dependencies: ["libc"]),
        Target(name: "Basic", dependencies: ["libc", "POSIX"]),
    ],
    exclude: ["Configuration.swift"]
)

let dylib = Product(name: "Config", type: .Library(.Dynamic), modules: "Config")

products.append(dylib)
