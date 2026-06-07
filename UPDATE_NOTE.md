# SwiftyHue 0.6.0 Update Note

## Highlights

This update modernizes SwiftyHue for current Philips Hue bridges, including Hue Bridge Pro, and refreshes the dependency stack for Swift 5 projects.

## What Changed

- Added HTTPS support for all bridge API calls.
- Added local bridge certificate handling for private network bridge IPs, so Hue Bridge Pro can be reached over HTTPS despite its local/self-signed certificate.
- Updated bridge authentication to use HTTPS.
- Updated bridge resource fetching, heartbeat requests, and send API requests to use the shared Hue networking session.
- Updated bridge discovery to use the current Hue discovery endpoint: `https://discovery.meethue.com`.
- Improved bridge search completion so discovery does not hang indefinitely.
- Allows bridge discovery to return a usable fallback bridge from a discovered IP when legacy `description.xml` validation is unavailable or incompatible.
- Migrated from Alamofire 4 to Alamofire 5.
- Updated CocoaAsyncSocket from `7.6.3` to `7.6.5`.
- Removed the Gloss dependency.
- Migrated bridge resource models away from Gloss operators and helpers to Swift 5 compatible JSON/Codable-style parsing.
- Added shared `JSON` and `JSONValue` support for dynamic Hue API payloads.
- Updated the podspec and Carthage config to reflect the new dependency versions.

## Compatibility Notes

- The legacy Hue API is now accessed via HTTPS instead of HTTP.
- Local HTTPS trust is relaxed only for private/local bridge hosts such as `192.168.x.x`, `10.x.x.x`, `172.16.x.x` through `172.31.x.x`, localhost, and loopback addresses.
- Existing apps using SwiftyHue through CocoaPods should run `pod install` after updating.
- Existing apps using Carthage should run `carthage bootstrap` or `carthage update` after updating.
- Gloss imports in client apps should be removed if they were only needed for SwiftyHue model parsing.

## Verification

- Bridge discovery and manual IP authentication were tested with a Hue Bridge Pro.
- The SwiftyHue source tree no longer contains legacy Gloss usage such as `<~~`, `~~>`, `jsonify`, `JSONDecodable`, `JSONEncodable`, or `Glossy`.

## Migration Reminder

If an app still expects Alamofire 4 result types, update callbacks to Swift `Result<Success, Error>` or Alamofire 5 response APIs where needed.
