//
//  UIImageViewExt.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import Foundation
import UIKit

extension UIImageView {
    func getImage(url: URL, placeholderImage:  UIImage?, success:@escaping (_ _result : Any? ) -> Void,  failer:@escaping (_ _result : Any? ) -> Void) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.sd_setImage(with: url, placeholderImage:  placeholderImage, options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            
            if error == nil {
                self.image = image
                success(true)
            }else {
                failer(false)
            }
        })
    }
}

