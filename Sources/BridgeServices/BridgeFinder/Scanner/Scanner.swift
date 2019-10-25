//
//  Scanner.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//


protocol Scanner {
    var delegate: ScannerDelegate? { get set }

    init(delegate: ScannerDelegate?)
    func start()
    func stop()
}
