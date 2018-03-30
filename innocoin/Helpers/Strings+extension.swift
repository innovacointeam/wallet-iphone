//
//  Strings+extension.swift
//  innocoin
//
//  Created by Yuri Drigin on 06.03.2018.
//  Copyright © 2018 DTech Labs. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func generateQRCode(withSize size: CGFloat) -> UIImage? {
        //Get self as data
        let stringData = self.data(using: String.Encoding.utf8)
        
        //Generate CIImage
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let ciImage = filter?.outputImage else {
            return nil
        }
        
        //Scale image to proper size
        let scale = size / ciImage.extent.size.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledCIImage = ciImage.transformed(by: transform)
        
        //Convert to CGImage
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(scaledCIImage, from: scaledCIImage.extent) else { return nil }
        
        //Finally return UIImage
        return UIImage(cgImage: cgImage)
    }
}
