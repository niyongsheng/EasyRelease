//
//  NYSTool.swift
//  EasyRelease
//
//  Created by 倪永胜 on 2021/2/6.
//  Copyright © 2021 NYS. All rights reserved.
//

import Cocoa

class NYSTool {
    static func imageChangeColor(tintColor: NSColor, oldImage: NSImage) -> NSImage {
        if oldImage.isTemplate == false {
            return oldImage
        }
        
        let image = oldImage.copy() as! NSImage
        image.lockFocus()
        
        tintColor.set()
        
        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceIn)
        
        image.unlockFocus()
        image.isTemplate = false
        
        return image
    }
}
