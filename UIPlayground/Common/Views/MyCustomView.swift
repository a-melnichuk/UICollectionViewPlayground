//
//  MyCustomView.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 11/4/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import UIKit
import os.log

@IBDesignable
class MyCustomView: UIControl {
    
    private var prevRect: CGRect? = nil
    private var prevText: String? = nil
    
    override var bounds: CGRect {
        didSet {
            // Do stuff here
            os_log("__CUSTOM_VIEW bounds height: %.0f", self.bounds.height)
            resizeIfNeeded()
        }
    }
    
    private var height: Int = 80 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    private var textAttr: [NSAttributedStringKey: Any] = [
        .font : UIFont(name: "Helvetica Neue", size: 12),
        .foregroundColor : UIColor.black
    ]
    
    @IBInspectable
    var sectionPadding: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var croppedImage: UIImage? = nil
    
    @IBInspectable
    var image: UIImage? = UIImage(named: "cat_image") {
        didSet {
            setNeedsDisplay()
            
            guard let image = self.image, let cgImage = image.cgImage else {
                croppedImage = nil
                 os_log("__CUSTOM_VIEW image not initialized")
                return
            }
            
            let w = CGFloat(cgImage.width)
            let h = CGFloat(cgImage.height)
            
            let a = w / h
            if (a == 1.0) {
                os_log("__CUSTOM_VIEW image rectangle")
                croppedImage = image
            } else {
                let minSize = min(w, h)

                let x = (w - minSize) / 2.0
                let y = (h - minSize) / 2.0
                
                os_log("__CUSTOM_VIEW image x: %f y: %f", x, y)
                
                let rect = CGRect(x: x,
                                  y: y,
                                  width: minSize,
                                  height: minSize)
                
                guard let imageRef = cgImage.cropping(to: rect) else {
                    os_log("__CUSTOM_VIEW cropping failed")
                    return
                }
                croppedImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
                
                os_log("__CUSTOM_VIEW image cropped")
            }
            
            
            
        }
    }
    

    @IBInspectable
    var textBackground: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var text: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." {
        didSet {
            resizeIfNeeded()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initControl()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        os_log("__CUSTOM_VIEW start")
        
        os_log("__CUSTOM_VIEW draw!")
        
        let separatorStart = CGPoint(x: rect.width / 2, y: 0)
        let separatorEnd = CGPoint(x: rect.width / 2, y: rect.height)
        drawSeparator(canvas: rect, from: separatorStart, to: separatorEnd)
        
        let textBackgroundRect = CGRect(x: sectionPadding,
                                        y: sectionPadding,
                                        width: rect.width / 2.0 - 2.0 * sectionPadding,
                                        height: rect.height - 2.0 * sectionPadding)
        drawTextBackground(canvas: rect, rect: textBackgroundRect)
        
        drawText(rect: textBackgroundRect)
        
        drawImage(canvas: rect)
    }
    
    private func measureTextHeight(fromRect: CGRect) {
        
    }
    
    private func drawSeparator(canvas: CGRect, from: CGPoint, to: CGPoint) {
        guard let c = UIGraphicsGetCurrentContext() else {
            return
        }
        c.setLineWidth(2.0)
        c.setStrokeColor(UIColor.black.cgColor)
        c.move(to: from)
        c.addLine(to: to)
        c.strokePath()
    }
    
    private func drawTextBackground(canvas: CGRect, rect: CGRect) {
        guard let c = UIGraphicsGetCurrentContext() else {
            return
        }
        c.setFillColor(textBackground.cgColor)
        c.fill(rect)
    }
    
    private func drawText(rect: CGRect) {
        text.draw(in: rect, withAttributes: textAttr)
    }
    
    private func drawImage(canvas: CGRect) {
    
        guard let c = UIGraphicsGetCurrentContext(), let image = self.croppedImage else {
            return
        }
        
       // UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
       // defer { UIGraphicsEndImageContext() }

        
        //layer.addSublayer(shapeLayer)
       
        let rect = CGRect(x: sectionPadding + canvas.width / 2.0,
                          y: sectionPadding,
                          width: canvas.width / 2.0 - 2.0 * sectionPadding,
                          height: canvas.height - 2.0 * sectionPadding)
        
       // c.setBlendMode(.destinationOut)
        
        //let shapeLayer = CAShapeLayer()
        
        
        let path = UIBezierPath(ovalIn: rect)
        path.usesEvenOddFillRule = true

       // path.append(UIBezierPath(roundedRect: rect, cornerRadius: 0))
        path.addClip()
        //path.append(UIBezierPath(ovalIn: rect))
        
        /*
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        */
      //  layer.mask = shapeLayer
        
      //  c.setBlendMode(.normal)
        
          image.draw(in: rect)
        
    }
    
    private func initControl() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
    }
    
    
    private func resizeIfNeeded() {
        let shouldRecalculateBounds = bounds != prevRect || text != prevText
        if (shouldRecalculateBounds) {
            os_log("__CUSTOM_VIEW should recalc")
            
            let textSize = CGSize(
                width: bounds.width / 2.0 - 2.0 * sectionPadding,
                height: .greatestFiniteMagnitude)
            
            let boundingBox = text.boundingRect(
                with: textSize,
                options: .usesLineFragmentOrigin,
                attributes: textAttr,
                context: nil)
            
            prevRect = bounds
            prevText = text
            
            let textHeight = ceil(boundingBox.height)
            height = Int(textHeight + 2 * sectionPadding)
            //setNeedsDisplay()
            os_log("__CUSTOM_VIEW text height %f, height %d", textHeight, height)
        }
    }
    
}
