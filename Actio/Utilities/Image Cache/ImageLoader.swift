//
//  ImageLoader.swift
//  Actio
//
//  Created by senthil on 16/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

public final class ImageLoader {
	public static let shared = ImageLoader()
	
	private let cache: ImageCacheType
	private lazy var backgroundQueue: OperationQueue = {
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 5
		return queue
	}()
	
	public init(cache: ImageCacheType = ImageCache()) {
		self.cache = cache
	}
	
	public func loadImage(from url: URL, completion: @escaping (UIImage) -> Void) {
		if let image = cache[url] {
			return completion(image)
		}
		
		DispatchQueue.global().async {
			if let data = try? Data(contentsOf: url) {
				if let image = UIImage(data: data) {
					DispatchQueue.main.async { [weak self] in
						self?.cache[url] = image
						
						completion(image)
					}
				}
			}
		}
	}
}

extension UIImageView {
	func load(url: URL) {
		ImageLoader.shared.loadImage(from: url) { [weak self] (image) in
			self?.image = image
		}
	}
}
