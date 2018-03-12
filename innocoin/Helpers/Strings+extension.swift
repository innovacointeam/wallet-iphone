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
    
    func generateQRCode() -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator"),
            let data = self.data(using: .isoLatin1) else {
            return nil
        }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 1, y: 1)
        guard let qrCode = filter.outputImage?.transformed(by: transform) else {
            return nil
        }
        return UIImage(ciImage: qrCode)
    }
}
