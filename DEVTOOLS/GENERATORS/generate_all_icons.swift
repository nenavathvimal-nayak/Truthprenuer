import Foundation
import AppKit

func renderIcon(
    sourcePath: String,
    size: Int,
    paddingFraction: Double,
    backgroundColor: NSColor?,
    outputPath: String
) {
    guard let sourceImage = NSImage(contentsOfFile: sourcePath) else {
        print("Error: Could not load source image at \(sourcePath)")
        return
    }

    let targetSize = NSSize(width: size, height: size)
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: size,
        pixelsHigh: size,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        print("Error: Could not allocate NSBitmapImageRep")
        return
    }

    NSGraphicsContext.saveGraphicsState()
    guard let context = NSGraphicsContext(bitmapImageRep: rep) else {
        print("Error: Could not create NSGraphicsContext")
        return
    }
    NSGraphicsContext.current = context
    context.imageInterpolation = .high

    if let bg = backgroundColor {
        bg.setFill()
        let rect = NSRect(origin: .zero, size: targetSize)
        rect.fill()
    } else {
        NSColor.clear.setFill()
        let rect = NSRect(origin: .zero, size: targetSize)
        rect.fill()
    }

    let innerWidth = Double(size) * (1.0 - paddingFraction * 2.0)
    let innerHeight = Double(size) * (1.0 - paddingFraction * 2.0)
    let srcW = Double(sourceImage.size.width)
    let srcH = Double(sourceImage.size.height)
    let scale = min(innerWidth / srcW, innerHeight / srcH)

    let drawW = srcW * scale
    let drawH = srcH * scale
    let drawX = (Double(size) - drawW) / 2.0
    let drawY = (Double(size) - drawH) / 2.0

    let destRect = NSRect(x: drawX, y: drawY, width: drawW, height: drawH)
    sourceImage.draw(in: destRect, from: .zero, operation: .sourceOver, fraction: 1.0)

    NSGraphicsContext.restoreGraphicsState()

    if let pngData = rep.representation(using: .png, properties: [:]) {
        do {
            try pngData.write(to: URL(fileURLWithPath: outputPath))
            print("Successfully written: \(outputPath) (\(size)x\(size))")
        } catch {
            print("Failed to write \(outputPath): \(error)")
        }
    }
}

let basePath = "/Volumes/NAYAK/taeed_flutter_source"
let logoDarkPath = "\(basePath)/assets/logos/truthprenuer_logo_dark.png"
let logoLightPath = "\(basePath)/assets/logos/truthprenuer_logo_light.png"
let logoDarkTransparentPath = "\(basePath)/assets/logos/truthprenuer_logo_dark_transparent.png"
let darkBg = NSColor(red: 10/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1.0)

// 1. web/favicon.png (High-resolution 64x64 Truthprenuer logo)
renderIcon(sourcePath: logoDarkPath, size: 64, paddingFraction: 0.0, backgroundColor: darkBg, outputPath: "\(basePath)/web/favicon.png")

// 2. web/icons/Icon-192.png (PWA & Apple touch icon: 192x192 with full brand logo)
renderIcon(sourcePath: logoDarkPath, size: 192, paddingFraction: 0.0, backgroundColor: darkBg, outputPath: "\(basePath)/web/icons/Icon-192.png")

// 3. web/icons/Icon-512.png (PWA & OpenGraph preview: 512x512 with full brand logo)
renderIcon(sourcePath: logoDarkPath, size: 512, paddingFraction: 0.0, backgroundColor: darkBg, outputPath: "\(basePath)/web/icons/Icon-512.png")

// 4. web/icons/Icon-maskable-192.png (Maskable icon with 10% safe-zone margin)
renderIcon(sourcePath: logoDarkPath, size: 192, paddingFraction: 0.10, backgroundColor: darkBg, outputPath: "\(basePath)/web/icons/Icon-maskable-192.png")

// 5. web/icons/Icon-maskable-512.png (Maskable icon with 10% safe-zone margin)
renderIcon(sourcePath: logoDarkPath, size: 512, paddingFraction: 0.10, backgroundColor: darkBg, outputPath: "\(basePath)/web/icons/Icon-maskable-512.png")
