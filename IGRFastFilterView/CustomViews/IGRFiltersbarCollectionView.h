//
//  IGRFiltersbarCollectionView.h
//  IGRFastFilterViewFramework
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class IGRBaseShaderFilter;

@interface IGRFiltersbarCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <IGRBaseShaderFilter *> *items;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifier;

- (void)updateWorkImage:(UIImage *)workImage;

@end

NS_ASSUME_NONNULL_END
