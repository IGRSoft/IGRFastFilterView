//
//  IGRToolbarCell.h
//  IGRFastFilterViewFramework
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

@import Foundation;
@import UIKit;

@class IGRBaseShaderFilter;

NS_ASSUME_NONNULL_BEGIN

@interface IGRFilterbarCell : UICollectionViewCell

@property (nonatomic, strong) UIColor   *textColor;
@property (nonatomic, strong) UIColor   *highlightTextColor;

- (void)setItem:(__kindof IGRBaseShaderFilter *)item withThumbImage:(UIImage *)thumbImage;

@end

NS_ASSUME_NONNULL_END
