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

@property (nonatomic, weak) __kindof IGRBaseShaderFilter *item;

@end

NS_ASSUME_NONNULL_END
