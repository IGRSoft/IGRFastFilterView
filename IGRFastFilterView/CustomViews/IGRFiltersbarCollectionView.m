//
//  IGRFiltersbarCollectionView.m
//  IGRFastFilterViewFramework
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

#import "IGRFiltersbarCollectionView.h"
#import "IGRFilterbarCell.h"
#import "IGRBaseShaderFilter.h"
#import "UIImage+IGRFastFilterView.h"
#import "NSBundle+IGRFastFilterView.h"

@implementation IGRFiltersbarCollectionView

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [self cellSize];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.headerReferenceSize = layout.footerReferenceSize = CGSizeZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        _items = [NSBundle getFilters];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentInset = UIEdgeInsetsZero;
        
        [self registerNib:[NSBundle filterbaCell] forCellWithReuseIdentifier:[self cellIdentifier]];
    }
    
    return self;
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
}

- (NSString *)cellIdentifier
{
    return NSStringFromClass([IGRFilterbarCell class]);
}

- (nullable __kindof UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [super cellForItemAtIndexPath:indexPath];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
    IGRFilterbarCell *cell = [self dequeueReusableCellWithReuseIdentifier:[self cellIdentifier]
                                                             forIndexPath:indexPath];
    
    [cell setItem:self.items[indexPath.row]];
    
    return cell;
}

- (void)updateWorkImage:(UIImage *)workImage
{
    [self.items makeObjectsPerformSelector:@selector(reset)];
    
    NSMutableArray *items = [self.items mutableCopy];
    
    UIImage *img = [workImage igr_aspectFillImageWithSize:[self previewSize]];
    
    [items enumerateObjectsUsingBlock:^(IGRBaseShaderFilter *item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item processPreview:img completeBlock:^(UIImage * _Nullable processedImage) {}];
    }];
    
    [self reloadData];
}

#pragma mark - Private

- (CGSize)cellSize
{
    return CGSizeMake(106.0, 120.0);  //TODO: Add to config
}

- (CGSize)previewSize
{
    static CGSize previewSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize selfSize = self.frame.size;
        previewSize = CGSizeMake(selfSize.height, selfSize.height);
    });
    
    return previewSize;
}

@end
