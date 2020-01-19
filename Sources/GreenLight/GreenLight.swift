//
//  GreenLight.swift
//  
//
//  Created by Balazs Szamody on 17/1/20.
//

import Foundation
import SPMUtility

public struct GreenLight {
    
    enum GreenLightError: Error {
        case noError
        case url
        case fileNotFound(path: String)
        
        var localizedDescription: String {
            switch self {
            case .noError:
                return "This is here to avoid the 0 exit code"
            case .url:
                return "URL Error"
            case .fileNotFound(let path):
                return "File not found at path: \(path)"
            }
        }
    }
    
    let manager = FileManager.default
    let args: ArgumentParser.Result
    let parser: ArgumentParser
    
    let inputFile: PositionalArgument<String>
    
    public init?(_ args: [String]) {
        parser = ArgumentParser(commandName: "GreenLight",
                                usage: "greenlight",
                                overview: "A simple app that export the content of a plist as environment variables.",
                                seeAlso: "getopt(1)")
        
        
        inputFile = parser.add(positional: "inputFile",
                              kind: String.self,
                              optional: false,
                              usage: "The path to the plist file",
                              completion: .filename)
        
        guard let parsed = GreenLight.parse(args, parser: parser) else {
            return nil
        }
        self.args = parsed
    }
    
    public  func run() {
        if let fileName = args.get(inputFile) {
            let dict = openFile(with: fileName)
            let command = dict
                .getKeyValue()
                .map({ "export " + $0 })
                .joined(separator: " && ")
            print(command)
            
//            process.arguments = ["echo", command]
        }
    }
    
    func openFile(with name: String) -> [String: String] {
        // Converting to URL is a safety
        var url: Foundation.URL?
        switch name.first {
        case "/":
            url = URL(string: "file://\(name)")
        case "~":
            let subs = name.dropFirst().dropFirst()
            url = manager
                .homeDirectoryForCurrentUser
                .appendingPathComponent(String(subs))
        default:
            url = URL(string: manager.currentDirectoryPath)?.appendingPathComponent(name)
        }
        do {
            guard let url = url else {
                throw GreenLightError.url
            }
            var format = PropertyListSerialization.PropertyListFormat.xml
            let path = url.path
            guard let data = manager.contents(atPath: path) else {
                throw GreenLightError.fileNotFound(path: path)
            }
            let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format)
            return (plist as? [String: String]) ?? [:]
        } catch {
            error.exitWithCode()
            fatalError("Never say never")
        }
    }
    
    static func parse(_ args: [String], parser: ArgumentParser) -> ArgumentParser.Result? {
        do {
            let parguments = try parser.parse(args.dropFirst().array)
            return parguments
        } catch ArgumentParserError.expectedValue(let arg) {
            print("Missing value for argument \(arg)")
            exit(1)
        } catch ArgumentParserError.expectedArguments(_, let args) {
            print("Missing arguments: \(args.joined(separator: " ")).")
            exit(2)
        } catch {
            error.exitWithCode()
            fatalError("Never say never")
        }
    }
}

public extension ArraySlice {
    var array: [Element] {
        return Array(self)
    }
}

extension Dictionary where Key == String, Value == String {
    func getKeyValue() -> [String] {
        self.map { (key, value) -> String in
            let output = "\(key)='\(value)'"
//            print(output)
            return output
        }
    }
}

extension Error {
    var exitCode: Int32 {
        return Int32((self as NSError).code)
    }
    
    func exitWithCode() {
        print((self as? GreenLight.GreenLightError)?.localizedDescription ?? self.localizedDescription)
        exit(self.exitCode)
    }
}
