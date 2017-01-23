//
//  AppDelegate.swift
//  HexClock
//
//  Created by Daniel Höpfl on 08.01.2015.
//  Copyright (c) 2015 Daniel Höpfl. All rights reserved.
//

import Cocoa

class HexClock : NSObject {

    var windows : [NSWindow] = []
	
    override init() {
        super.init()

        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSApplicationDidChangeScreenParameters, object: NSApplication.shared(), queue: OperationQueue.main) { (x) -> Void in
            self.updateScreens()
        }
        updateScreens()
    }

	func reinterpret_decimal_as_hex( _ inDecimalThatIsReallyHex:Int ) -> Int {
		let	highNybble : Int = inDecimalThatIsReallyHex / 10;
		let	lowNybble : Int = inDecimalThatIsReallyHex - highNybble;
		return highNybble * 16 + lowNybble;
	}

    func tick() {
        let now = Date()

        let cal = Calendar.current
        let components = cal.dateComponents([.hour, .minute, .second], from: now)
        NSLog("%02d:%02d:%02d", components.hour!, components.minute!, components.second!)
        for window in windows
		{
            window.backgroundColor = NSColor(deviceRed: CGFloat(reinterpret_decimal_as_hex(components.hour!))/255.0, green: CGFloat(reinterpret_decimal_as_hex(components.minute!))/255.0, blue: CGFloat(reinterpret_decimal_as_hex(components.second!)) / 255.0, alpha: 1.0)

            let timeIntervalSinceReferenceDate = now.timeIntervalSinceReferenceDate
            let to : TimeInterval = 1 - (timeIntervalSinceReferenceDate - TimeInterval(Int(timeIntervalSinceReferenceDate)))
            Timer.scheduledTimer(timeInterval: to, target: self, selector: #selector(HexClock.tick), userInfo: nil, repeats: false)
        }
    }

    func updateScreens() {
        windows.removeAll()

        let screens = NSScreen.screens()! as [NSScreen]
        for screen in screens {
            let window = NSWindow(contentRect: screen.frame, styleMask: NSBorderlessWindowMask, backing: .buffered, defer: true)
            window.level = Int(CGWindowLevelForKey(CGWindowLevelKey(rawValue: 2)!))
            window.backgroundColor = NSColor.clear
			window.alphaValue = 0.7;
            window.orderFrontRegardless()

            windows.append(window)
        }
        tick()
    }

}

HexClock()
NSApplication.shared().run()
