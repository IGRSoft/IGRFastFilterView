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
#import "IGRFastFilterViewCustomizer.h"

@interface IGRFiltersbarCollectionView ()

@property (nonatomic, assign, readwrite) CGSize cellSize;

@property (nonatomic, strong) UIColor   *filterBarCellTextColor;
@property (nonatomic, strong) UIColor   *filterBarCellHighlightTextColor;

@property (nonatomic, strong) UIImage   *thumbImage;

@end

@implementation IGRFiltersbarCollectionView

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame
{
    IGRFastFilterViewCustomizer *customizer = [IGRFastFilterViewCustomizer defaultCustomizer];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = customizer.filterBarCellSize;
    
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
        
        self.filterBarCellTextColor = customizer.filterBarCellTextColor;
        self.filterBarCellHighlightTextColor = customizer.filterBarCellHighlightTextColor;
        self.cellSize = layout.itemSize;
        
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
    
    if (self.thumbImage)
    {
        [cell setItem:self.items[indexPath.item] withThumbImage:self.thumbImage];
    }
    
    cell.textColor = self.filterBarCellTextColor;
    cell.highlightTextColor = self.filterBarCellHighlightTextColor;
    
    return cell;
}

- (void)updateWorkImage:(UIImage *)workImage
{
    _items = [NSBundle getFilters];
        
    self.thumbImage = [workImage igr_aspectFillImageWithSize:[self previewSize]];
    
    [self reloadData];
}

#pragma mark - Private

- (CGSize)previewSize
{
    static CGSize previewSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        previewSize = CGSizeMake(self.cellSize.height, self.cellSize.height);
    });
    
    return previewSize;
}

@end
