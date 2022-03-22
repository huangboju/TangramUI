//
//  UIImageView+Extension.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2022/3/22.
//  Copyright © 2022 黄伯驹. All rights reserved.
//

import Nuke

extension UIImageView {
    
    @discardableResult
    public func loadImage(with request: ImageRequestConvertible,
                          options: ImageLoadingOptions = ImageLoadingOptions.shared,
                          progress: ((_ intermediateResponse: ImageResponse?, _ completedUnitCount: Int64, _ totalUnitCount: Int64) -> Void)? = nil,
                          completion: ((_ result: Result<ImageResponse, ImagePipeline.Error>) -> Void)? = nil) -> ImageTask? {
        return Nuke.loadImage(with: request,
                              options: options,
                              into: self,
                              progress: progress,
                              completion: completion)
    }
}
