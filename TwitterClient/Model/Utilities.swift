//
//  Utilities.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/30/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class Utilities: NSObject {
	
	class func setImage(forImage imageView: UIImageView, using url: URL) {
		let imageRequest = NSURLRequest(url: url)
		
		imageView.setImageWith(
			imageRequest as URLRequest,
			placeholderImage: nil,
			success: { (imageRequest, imageResponse, image) -> Void in
				// imageResponse will be nil if the image is cached
				if imageResponse != nil {
					print("Image was NOT cached, fade in image")
					imageView.alpha = 0.0
					imageView.image = image
					UIView.animate(withDuration: 0.3, animations: { () -> Void in
						imageView.alpha = 1.0
					})
				} else {
					print("Image was cached so just update the image")
					imageView.image = image
				}
		},
			failure: { (imageRequest, imageResponse, error) -> Void in
				// do something for the failure condition
		})
	}

}
