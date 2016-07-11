#if os(Linux)
import Glibc
#else
import Darwin.C
#endif
import Foundation

public struct Config {
    public let name: String
    public let bool: Bool
    public let int: Int

    public init(name: String, bool: Bool, int: Int) {
        self.name = name
        self.bool = bool
        self.int = int

        if Process.argc > 0 {
            if let fileNoOptIndex = Process.arguments.index(of: "-fileno"),
               let fileNo = Int32(Process.arguments[fileNoOptIndex + 1]) {
                dumpPackageAtExit(self, fileNo: fileNo)
            }
        }
    }
}

extension Config {
    func toJSON() -> Data {
        var dict = [String : AnyObject]()
        dict["name"] = name
        dict["bool"] = bool
        dict["int"] = int
        return try! JSONSerialization.data(withJSONObject: dict as NSDictionary, options: .prettyPrinted)
    }
}

private var dumpInfo: (config: Config, fileNo: Int32)? = nil
private func dumpPackageAtExit(_ config: Config, fileNo: Int32) {
    func dump() {
        guard let dumpInfo = dumpInfo else { return }
        let file = FileHandle(fileDescriptor: dumpInfo.fileNo)
        file.write(dumpInfo.config.toJSON())
    }
    dumpInfo = (config, fileNo)
    atexit(dump)
}
