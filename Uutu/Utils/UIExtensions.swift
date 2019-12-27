//
//  UIExtensions.swift
//  Uutu
//
//  Created by admin on 27/12/2019.
//  Copyright © 2019 akp. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView : UIView {
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 5.0
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
     
    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
          
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor

            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}


extension UIImageView {

    func addShadowToImageNotLayer(blurSize: CGFloat = 5.0){

        let shadowColor = UIColor.darkGray.cgColor

        guard let image = self.image else {return}

        let context = CGContext(data: nil,
                                width: Int(image.size.width + blurSize),
                                height: Int(image.size.height + blurSize),
                                bitsPerComponent: image.cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        context.setShadow(offset: CGSize(width: 0,height: -blurSize/2),
                          blur: blurSize,
                          color: shadowColor)
        context.draw(image.cgImage!,
                     in: CGRect(x: 0, y: blurSize, width: image.size.width, height: image.size.height),
                     byTiling:false)

        self.image = UIImage(cgImage: context.makeImage()!)

    }
}
