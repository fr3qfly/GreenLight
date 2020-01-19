import XCTest
import class Foundation.Bundle
@testable import GreenLight

final class GreenLightTests: XCTestCase {
    var app: GreenLight?
    
    override func setUp() {
        super.setUp()
    }
    
    func testExample() {
        app = GreenLight(["~/Developer/@Fr3qFly_Dev/GreenLight/testfile.plist"])
        let path = "~/Developer/@Fr3qFly_Dev/GreenLight/testfile.plist"
        
        let dict = app?.openFile(with: path)
        
        XCTAssertEqual(dict, [:])
    }
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//
//        // Some of the APIs that we use below are available in macOS 10.13 and above.
//        guard #available(macOS 10.13, *) else {
//            return
//        }
//
//        let fooBinary = productsDirectory.appendingPathComponent("greenlight")
//
//
//        let process = Process()
//        process.executableURL = fooBinary
//        process.arguments = ["~/Developer/@Fr3qFly_Dev/GreenLight/testfile.plist"]
//
//        let pipe = Pipe()
//        process.standardOutput = pipe
//
//        try process.run()
//        process.waitUntilExit()
//
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = String(data: data, encoding: .utf8)
//
//        XCTAssertEqual(output, "Hello, world!\n")
//    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
