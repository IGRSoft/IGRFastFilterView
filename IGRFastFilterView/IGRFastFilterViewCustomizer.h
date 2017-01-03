//
//  IGRFastFilterViewCustomizer.h
//  IGRFastFilterView
//
//  Created by Vitalii Parovishnyk on 1/3/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreGraphics;

@interface IGRFastFilterViewCustomizer : NSObject

+ (instancetype)defaultCustomizer;

@property (nonatomic, assign) CGFloat   filterBarHeight;
@property (nonatomic, assign) CGSize    filterBarCellSize;

@property (nonatomic, strong) UIColor   *filterBarCellTextColor;
@property (nonatomic, strong) UIColor   *filterBarCellHighlightTextColor;

@property (nonatomic, assign) NSUInteger cacheSize;

@end
