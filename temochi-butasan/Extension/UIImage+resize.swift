//
//  UIImage+resize.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/04.
//

import UIKit
extension UIImage{
    // 画質を担保したままResizeするメソッド.
    func resizeImage(width: CGFloat, height: CGFloat)-> UIImage?{
        
        let resizedSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    // 画質を担保したままResizeするメソッド. 横幅をもとにアスペクト比はそのまま
    func resizeImage(width: CGFloat)-> UIImage?{
        
        let resizedSize = CGSize(width: width, height: self.size.height * width / self.size.width)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func resizeImage(height: CGFloat)-> UIImage?{
        
        let resizedSize = CGSize(width: self.size.width * height / self.size.height, height: height)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
