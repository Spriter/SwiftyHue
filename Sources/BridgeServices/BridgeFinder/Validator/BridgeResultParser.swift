//
//  BridgeResultParser.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation

class BridgeResultParser: NSObject, XMLParserDelegate {
    private let parser: XMLParser
    private var element: String = ""
    private var bridge: HueBridge?
    private var successBlock: ((_ bridge: HueBridge) -> Void)?
    private var failureBlock: ((_ error: NSError) -> Void)?

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

    init(xmlData: Data) {
        parser = XMLParser(data: xmlData)
        super.init()
        parser.delegate = self
    }

    func parse(_ success: @escaping (_ bridge: HueBridge) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        self.successBlock = success
        self.failureBlock = failure

        parser.parse()
    }

    private func cancelWithError(_ errorMessage: String) {
        parser.abortParsing()
        if let failureBlock = failureBlock {
            failureBlock(NSError(domain: "HueBridgeParser", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
        }
    }

    // MARK: - NSXMLParserDelegate

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
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

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
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

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        element = ""

        if elementName == "device" {
            if isBridgeDataValid() {
                bridge = HueBridge(ip: ip, deviceType: deviceType, friendlyName: friendlyName, modelDescription: modelDescription, modelName: modelName, serialNumber: serialNumber, UDN: UDN, icons: icons)
            } else {
                cancelWithError("HueBridge data not valid.")
            }
        } else if elementName == "URLBase" {
            let url = URL(string: urlBase)
            if let host = url?.host {
                ip = host
            }
        } else if elementName == "icon" {
            if let height = Int(height), let width = Int(width) {
                icons.append(HueBridgeIcon(mimetype: mimetype, height: height, width: width, name: iconName))
            }
        }
    }

    public func parserDidEndDocument(_ parser: XMLParser) {
        if let successBlock = successBlock, let bridge = bridge {
            successBlock(bridge)
        }
    }

    private func isBridgeDataValid() -> Bool {
        return ip.characters.count != 0 && deviceType.characters.count != 0
    }
}
