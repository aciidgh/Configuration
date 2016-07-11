import Basic
import POSIX
@_exported import Config
import Foundation

public enum Error: ErrorProtocol {
    case couldNotParse
}

public extension Config {

    public init(load: RelativePath) throws {
        guard let jsonData = try parse(configPath: load.asString, swiftc: "swiftc", libdir: ".build/debug") else {
            throw Error.couldNotParse
        }
        let json = try JSON(string: jsonData)

        guard case let .dictionary(contents) = json,
              case let .string(name)? = contents["name"],
              case let .bool(bool)? = contents["bool"],
              case let .int(int)? = contents["int"] else {
            throw Error.couldNotParse
        }
        self.name = name
        self.bool = bool
        self.int = int
    }
}

private func parse(configPath: String, swiftc: String, libdir: String) throws -> String? {

    var cmd = [swiftc]
    cmd += ["--driver-mode=swift"]
    cmd += ["-I", libdir]
    cmd += ["-L", libdir, "-lConfig"]

#if os(OSX)
    cmd += ["-target", "x86_64-apple-macosx10.10"]
#endif
    cmd += [configPath]

    let file = try TemporaryFile()
    cmd += ["-fileno", "\(file.fileHandle.fileDescriptor)"]
    do {
        try system(cmd)
    } catch {
        throw Error.couldNotParse
    }

    return try! localFS.readFileContents(file.path.asString).asString
}
