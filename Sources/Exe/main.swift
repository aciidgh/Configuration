import ConfigLoader

do {
    let config = try Config(load: "Configuration.swift")
    print(config)
} catch {
    print("error: \(error)")
}
