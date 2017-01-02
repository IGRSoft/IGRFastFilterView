//
//  NSBundle+IGRInstaFilters.h
//  IGRFastFilterViewFramework
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class IGRBaseShaderFilter;

@interface NSBundle (IGRFastFilterView)

+ (NSString *)shaderForName:(NSString *)name;
+ (UIImage *)imageForName:(NSString *)name forShaderName:(NSString *)shaderName;

+ (UINib *)filterbaCell;

+ ( NSArray <IGRBaseShaderFilter *> *)getFilters;

@end

NS_ASSUME_NONNULL_END
