//
//  BridgeResultParser.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation

class BridgeResultParser: NSObject, NSXMLParserDelegate {
    private let parser: NSXMLParser
    private var element: String = ""
    private var bridge: HueBridge?
    private var successBlock: ((bridge: HueBridge) -> Void)?
    private var failureBlock: ((error: NSError) -> Void)?

    private var urlBase: String = ""
    private var ip: String = ""
    private var deviceType: String = ""
    private var friendlyName: String = ""
    private var modelDescription: String = ""
    private var modelName: String = ""
    private var serialNumber: String = ""
    private var UDN: String = ""
    private var icons = [HueBridgeIcon]()
    private var mimetype: String = ""
    private var height: String = ""
    private var width: String = ""
    private var iconName: String = ""

    init(xmlData: NSData) {
        parser = NSXMLParser(data: xmlData)
        super.init()
        parser.delegate = self
    }

    func parse(success: (bridge: HueBridge) -> Void, failure: (error: NSError) -> Void) {
        self.successBlock = success
        self.failureBlock = failure

        parser.parse()
    }

    private func cancelWithError(errorMessage: String) {
        parser.abortParsing()
        if let failureBlock = failureBlock {
            failureBlock(error: NSError(domain: "HueBridgeParser", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
        }
    }

    // MARK: - NSXMLParserDelegate

    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName

        if elementName == "root" {
            if attributeDict["xmlns"] == nil || attributeDict["xmlns"] != "urn:schemas-upnp-org:device-1-0" {
                cancelWithError("XML is not a known HueBridge XML.")
            }
        } else if elementName == "icon" {
            mimetype = ""
            height = ""
            width = ""
            iconName = ""
        }
    }

    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        switch element {
        case "deviceType":
            deviceType += string
        case "friendlyName":
            friendlyName += string
        case "modelDescription":
            modelDescription += string
        case "modelName":
            modelName += string
        case "serialNumber":
            serialNumber += string
        case "UDN":
            UDN += string
        case "URLBase":
            urlBase += string
        case "mimetype":
            mimetype += string
        case "height":
            height += string
        case "width":
            width += string
        case "url":
            iconName += string
        default: break
        }
    }

    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        element = ""

        if elementName == "device" {
            if isBridgeDataValid() {
                bridge = HueBridge(ip: ip, deviceType: deviceType, friendlyName: friendlyName, modelDescription: modelDescription, modelName: modelName, serialNumber: serialNumber, UDN: UDN, icons: icons)
            } else {
                cancelWithError("HueBridge data not valid.")
            }
        } else if elementName == "URLBase" {
            let url = NSURL(string: urlBase)
            if let host = url?.host {
                ip = host
            }
        } else if elementName == "icon" {
            if let height = Int(height), let width = Int(width) {
                icons.append(HueBridgeIcon(mimetype: mimetype, height: height, width: width, name: iconName))
            }
        }
    }

    public func parserDidEndDocument(parser: NSXMLParser) {
        if let successBlock = successBlock, let bridge = bridge {
            successBlock(bridge: bridge)
        }
    }

    private func isBridgeDataValid() -> Bool {
        return ip.characters.count != 0 && deviceType.characters.count != 0
    }
}