//
//  Utilities.swift
//  Pods
//
//  Created by Jerome Schmitz on 13.05.16.
//
//

import Foundation
import CoreGraphics

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit.UIColor
    public typealias SwiftyHueColor = UIKit.UIColor
    public typealias SwiftyPoint = CGPoint
#else
    import Cocoa
    public typealias SwiftyHueColor = NSColor
    public typealias SwiftyPoint = NSPoint
#endif


/**
 This class contains some utilities for applications using SwiftyHue.
 */
public struct Utilities {
    
    static let cptRED = 0
    static let cptGREEN = 1
    static let cptBLUE = 2
    
    /**
     Generates the color for the given XY values.
     Note: When the exact values cannot be represented, it will return the closest match.
     
     - Parameters:
        - xy: the xy point of the color
        - model: model of the lamp, example: "LCT001" for hue bulb. Used to calculate the color gamut. If this value is empty the default gamut values are used.
     - Returns: The color
     */
    public static func colorFromXY(_ xy: CGPoint, forModel model: String) -> SwiftyHueColor {
     
        var xy = xy
        let colorPoints: [NSValue] = colorPointsForModel(model)
        let inReachOfLamps: Bool = checkPointInLampsReach(xy, withColorPoints: colorPoints)
        
        if !inReachOfLamps {
            //It seems the colour is out of reach
            //let's find the closest colour we can produce with our lamp and send this XY value out.
            
            //Find the closest point on each line in the triangle.
            let pAB: CGPoint = getClosestPointToPoints(point1: getPointFromValue(colorPoints[cptRED]), point2: getPointFromValue(colorPoints[cptGREEN]), point3: xy)
            let pAC: CGPoint = getClosestPointToPoints(point1: getPointFromValue(colorPoints[cptBLUE]), point2: getPointFromValue(colorPoints[cptRED]), point3: xy)
            let pBC: CGPoint = getClosestPointToPoints(point1: getPointFromValue(colorPoints[cptGREEN]), point2: getPointFromValue(colorPoints[cptBLUE]), point3: xy)
 
            //Get the distances per point and see which point is closer to our Point.
            let dAB: CGFloat = getDistanceBetweenTwoPoints(point1: xy, point2: pAB)
            let dAC: CGFloat = getDistanceBetweenTwoPoints(point1: xy, point2: pAC)
            let dBC: CGFloat = getDistanceBetweenTwoPoints(point1: xy, point2: pBC)

            var lowest = dAB
            var closestPoint = pAB
            
            if dAC < lowest {
                lowest = dAC
                closestPoint = pAC
            }
            if dBC < lowest {
                lowest = dBC
                closestPoint = pBC
            }
            
            //Change the xy value to a value which is within the reach of the lamp.
            xy.x = closestPoint.x
            xy.y = closestPoint.y
        }
        
        let x: CGFloat = xy.x
        let y: CGFloat = xy.y
        let z: CGFloat = 1.0 - x - y
        
        let Y: CGFloat = 1.0
        let X: CGFloat = (Y / y) * x
        let Z: CGFloat = (Y / y) * z
        
        // sRGB D65 conversion
        var r: CGFloat =  X * 1.656492 - Y * 0.354851 - Z * 0.255038
        var g: CGFloat = -X * 0.707196 + Y * 1.655397 + Z * 0.036152
        var b: CGFloat =  X * 0.051713 - Y * 0.121364 + Z * 1.011530
        
        if r > b && r > g && r > 1.0 {
            
            // red is too big
            g = g / r;
            b = b / r;
            r = 1.0;
            
        } else if g > b && g > r && g > 1.0 {
            
            // green is too big
            r = r / g;
            b = b / g;
            g = 1.0;
            
        } else if b > r && b > g && b > 1.0 {
            
            // blue is too big
            r = r / b;
            g = g / b;
            b = 1.0;
        }
        
        // Apply gamma correction
        r = r <= 0.0031308 ? 12.92 * r : (1.0 + 0.055) * pow(r, (1.0 / 2.4)) - 0.055;
        g = g <= 0.0031308 ? 12.92 * g : (1.0 + 0.055) * pow(g, (1.0 / 2.4)) - 0.055;
        b = b <= 0.0031308 ? 12.92 * b : (1.0 + 0.055) * pow(b, (1.0 / 2.4)) - 0.055;
        
        if r > b && r > g {
            
            // red is biggest
            if r > 1.0 {
                g = g / r;
                b = b / r;
                r = 1.0;
            }
            
        } else if g > b && g > r {
            
            // green is biggest
            if g > 1.0 {
                r = r / g;
                b = b / g;
                g = 1.0;
            }
            
        } else if b > r && b > g {
            
            // blue is biggest
            if b > 1.0 {
                r = r / b;
                g = g / b;
                b = 1.0;
            }
        }
        
        return SwiftyHueColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    /**
     Generates a point with x an y value that represents the given color
     
     - Parameters:
        - color: the xy point of the color
        - model: model of the lamp, example: "LCT001" for hue bulb. Used to calculate the color gamut. If this value is empty the default gamut values are used.
     - Returns: The xy color
     */
    public static func calculateXY(_ color: SwiftyHueColor, forModel model: String) -> CGPoint {

        let cgColor = color.cgColor
        let numberOfComponents = cgColor.numberOfComponents

        var redOrBlackComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0

        color.getRed(&redOrBlackComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)

        // Default to white
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0

        if numberOfComponents == 4 {
            // Full color
            red = redOrBlackComponent
            green = greenComponent
            blue = blueComponent

        } else if numberOfComponents == 2 {

            // Greyscale color
            red = redOrBlackComponent
            green = redOrBlackComponent
            blue = redOrBlackComponent
        }

        // Apply gamma correction
        let r: CGFloat = (red   > 0.04045) ? pow((red   + 0.055) / (1.0 + 0.055), 2.4) : (red   / 12.92)
        let g: CGFloat = (green > 0.04045) ? pow((green + 0.055) / (1.0 + 0.055), 2.4) : (green / 12.92)
        let b: CGFloat = (blue  > 0.04045) ? pow((blue  + 0.055) / (1.0 + 0.055), 2.4) : (blue  / 12.92)
        
        // Wide gamut conversion D65
        let X: CGFloat = r * 0.664511 + g * 0.154324 + b * 0.162028
        let Y: CGFloat = r * 0.283881 + g * 0.668433 + b * 0.047685
        let Z: CGFloat = r * 0.000088 + g * 0.072310 + b * 0.986039
        
        var cx: CGFloat = X / (X + Y + Z)
        var cy: CGFloat = Y / (X + Y + Z)
        
        if cx.isNaN {
            cx = 0.0
        }
        
        if cy.isNaN {
            cy = 0.0
        }

        //Check if the given XY value is within the colourreach of our lamps.
        
        let xyPoint: CGPoint =  CGPoint(x: cx, y: cy)
        let colorPoints: [NSValue] = colorPointsForModel(model)
        let inReachOfLamps: Bool = checkPointInLampsReach(xyPoint, withColorPoints: colorPoints)
        
        if !inReachOfLamps {
            //It seems the colour is out of reach
            //let's find the closest colour we can produce with our lamp and send this XY value out.
            
            //Find the closest point on each line in the triangle.
            let pAB = getClosestPointToPoints(point1: getPointFromValue(colorPoints[cptRED]), point2: getPointFromValue(colorPoints[cptGREEN]), point3: xyPoint)
            let pAC = getClosestPointToPoints(point1: getPointFromValue(colorPoints[cptBLUE]), point2: getPointFromValue(colorPoints[cptRED]), point3: xyPoint)
            let pBC = getClosestPointToPoints(point1: getPointFromValue(colorPoints[cptGREEN]), point2: getPointFromValue(colorPoints[cptBLUE]), point3: xyPoint)
            
            //Get the distances per point and see which point is closer to our Point.
            let dAB: CGFloat = getDistanceBetweenTwoPoints(point1: xyPoint, point2: pAB)
            let dAC: CGFloat = getDistanceBetweenTwoPoints(point1: xyPoint, point2: pAC)
            let dBC: CGFloat = getDistanceBetweenTwoPoints(point1: xyPoint, point2: pBC)
            
            var lowest: CGFloat = dAB
            var closestPoint: CGPoint = pAB
            
            if dAC < lowest {
                lowest = dAC
                closestPoint = pAC
            }
            if dBC < lowest {
                lowest = dBC
                closestPoint = pBC
            }
            
            //Change the xy value to a value which is within the reach of the lamp.
            cx = closestPoint.x
            cy = closestPoint.y
        }
        
        return CGPoint(x: cx, y: cy)
    }
    
    /**
     Generates the colorPoint values for the light model and the matching gamut.
     
     - Parameters:
         - model: the light model
     - Returns: colorPoints
     */
    private static func colorPointsForModel(_ model: String) -> [NSValue] {
        
        var colorPoints: [NSValue] = [NSValue]()

        let gamutA: [String] = ["LLC001" /* Monet, Renoir, Mondriaan (gen II) */,
                                "LLC005" /* Bloom (gen II) */,
                                "LLC006" /* Iris (gen III) */,
                                "LLC007" /* Bloom, Aura (gen III) */,
                                "LLC011" /* Hue Bloom */,
                                "LLC012" /* Hue Bloom */,
                                "LLC013" /* Storylight */,
                                "LST001" /* Light Strips */]
        
        let gamutB: [String] = ["LCT001" /* Hue A19 */,
                                "LCT007" /* Hue A19 */,
                                "LCT002" /* Hue BR30 */,
                                "LCT003" /* Hue GU10 */]
        
        let gamutC: [String] = ["LLC020" /* Hue Go */,
                                "LST002" /* Hue LightStrips Plus */]
        
        if gamutA.contains(model) {
            
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.703, y: 0.296)))  // Red
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.214, y: 0.709)))  // Green
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.139, y: 0.081)))  // Blue
            
        } else if gamutB.contains(model) {
            
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.674, y: 0.322)))  // Red
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.408, y: 0.517)))  // Green
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.168, y: 0.041)))  // Blue
            
        } else if gamutC.contains(model) {
            
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.692, y: 0.308)))  // Red
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.17, y: 0.7)))     // Green
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.153, y: 0.048)))  // Blue
            
        } else {
            
            // Default construct triangle wich contains all values
            colorPoints.append(getValueFromPoint(CGPoint(x: 1.0, y: 0.0)))      // Red
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.0, y: 1.0)))      // Green
            colorPoints.append(getValueFromPoint(CGPoint(x: 0.0, y: 0.0)))      // Blue
        }
        
        return colorPoints;
    }
    
    /**
     Calculates crossProduct of two 2D vectors / points.
     
     - Parameters:
         - p1: first point used as vector
         - p2: second point used as vector
     - Returns: crossProduct of vectors
     */
    private static func crossProduct(point1 p1: CGPoint, point2 p2:CGPoint) -> CGFloat {
        
        return p1.x * p2.y - p1.y * p2.x
    }
    
    /**
     Find the closest point on a line.
     This point will be within reach of the lamp.
     
     - Parameters:
        - A: the point where the line starts
        - B: the point where the line ends
        - P: the point which is close to a line
     - Returns: the point which is on the line
     */
    private static func getClosestPointToPoints(point1 A:CGPoint, point2 B:CGPoint, point3 P:CGPoint) -> CGPoint {
        
        let AP: CGPoint = CGPoint(x: P.x - A.x, y: P.y - A.y)
        let AB: CGPoint = CGPoint(x: B.x - A.x, y: B.y - A.y)
        let ab2: CGFloat = AB.x * AB.x + AB.y * AB.y;
        let ap_ab: CGFloat = AP.x * AB.x + AP.y * AB.y;
        
        var t: CGFloat = ap_ab / ab2;
        
        if t < 0.0 {
            t = 0.0
        } else if t > 1.0 {
            t = 1.0
        }
        
        return CGPoint(x: A.x + AB.x * t, y: A.y + AB.y * t)
    }
    
    /**
     Find the distance between two points.
     
     - Parameters:
         - p1: point 1
         - p2: point 2
     - Returns: the distance between p1 and p2
     */
    private static func getDistanceBetweenTwoPoints(point1 p1: CGPoint, point2 p2:CGPoint) -> CGFloat {
    
        let dx: CGFloat = p1.x - p2.x // horizontal difference
        let dy: CGFloat = p1.y - p2.y // vertical difference
        
        return sqrt(dx * dx + dy * dy)
    }
    
    /**
     Method to see if the given XY value is within the reach of the lamps.
     
     - Parameters:
         - p: the point containing the X,Y value
     - Returns: true if within reach, false otherwise.
     */
    private static func checkPointInLampsReach(_ p: CGPoint, withColorPoints colorPoints:[NSValue]) -> Bool {
    
        let red: CGPoint =   getPointFromValue(colorPoints[cptRED])
        let green: CGPoint = getPointFromValue(colorPoints[cptGREEN])
        let blue: CGPoint =  getPointFromValue(colorPoints[cptBLUE])
        
        let v1: CGPoint = CGPoint(x: green.x - red.x, y: green.y - red.y)
        let v2: CGPoint = CGPoint(x: blue.x - red.x, y: blue.y - red.y)
        
        let q: CGPoint = CGPoint(x: p.x - red.x, y: p.y - red.y)
        
        let s: CGFloat = crossProduct(point1: q, point2:v2) / crossProduct(point1: v1, point2:v2)
        let t: CGFloat = crossProduct(point1: v1, point2:q) / crossProduct(point1: v1, point2:v2)
        
        return (s >= 0.0) && (t >= 0.0) && (s + t <= 1.0)
    }
    
    /**
     Get a CGPoint from a NSValue object (works on both iOS and OSX)
     
     - Parameters:
        - value: value with a point
     - Returns: The point from this value
     */
    private static func getPointFromValue(_ point: NSValue) -> SwiftyPoint {
        
        #if os(OSX)
            return point.pointValue
        #else
            return point.cgPointValue
        #endif
    }
    
    /**
     Get a NSValue from a CGPoint object (works on both iOS and OSX)
     
     - Parameters:
        - point: The point
     - Returns: The value with a point
     */
    private static func getValueFromPoint(_ point: CGPoint) -> NSValue {
        
        #if os(OSX)
            return NSValue(point: point)
        #else
            return NSValue(cgPoint: point)
        #endif
    }
}
