//
//  IGRFastFilterView.h
//  IGRFastFilterView
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

@import UIKit;

@class IGRBaseShaderFilter;

NS_ASSUME_NONNULL_BEGIN

@interface IGRFastFilterView : UIView

@property (nonatomic, strong, readonly) UIImage *workImage;

- (void)setupImage:(UIImage *)anImage;

@end

NS_ASSUME_NONNULL_END
