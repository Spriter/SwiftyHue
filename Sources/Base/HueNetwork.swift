import Foundation
import Alamofire

private final class HueLocalTrustURLSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let trust = challenge.protectionSpace.serverTrust,
              HueNetwork.isLocalBridgeHost(challenge.protectionSpace.host) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}

private final class HueLocalTrustManager: ServerTrustManager {
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        if HueNetwork.isLocalBridgeHost(host) {
            return DisabledTrustEvaluator()
        }

        return nil
    }
}

enum HueNetwork {
    private static let sessionDelegate = HueLocalTrustURLSessionDelegate()

    static let urlSession: URLSession = {
        URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
    }()

    static let session: Session = {
        let trustManager = HueLocalTrustManager(allHostsMustBeEvaluated: false, evaluators: [:])
        return Session(configuration: .default, serverTrustManager: trustManager)
    }()

    static func isLocalBridgeHost(_ host: String) -> Bool {
        if host == "localhost" || host == "127.0.0.1" || host == "::1" {
            return true
        }

        if host.hasPrefix("10.") || host.hasPrefix("192.168.") {
            return true
        }

        if host.hasPrefix("172.") {
            let components = host.split(separator: ".")
            if components.count > 1, let secondOctet = Int(components[1]) {
                return (16...31).contains(secondOctet)
            }
        }

        return false
    }
}
