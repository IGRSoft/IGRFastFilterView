//
//  IGRFastFilterView.m
//  IGRFastFilterView
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

#import "IGRFastFilterView.h"
#import "IGRBaseShaderFilter.h"
#import "IGRFiltersbarCollectionView.h"
#import "IGRFastFilterViewCustomizer.h"

@interface IGRFastFilterView ()   <UIScrollViewDelegate,
                                    UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIImage *originalImage;
}

@property (nonatomic, nullable, weak ) UIScrollView *scrollView;
@property (nonatomic, nullable, weak ) UIImageView *imageView;
@property (nonatomic, nullable, weak ) IGRFiltersbarCollectionView *filterBarView;

@property (nonatomic, nonnull, strong) __kindof IGRBaseShaderFilter *shaderFilter;

@property (nonatomic, nullable, strong, readwrite) UIImage *processedImage;

@property (nonatomic, copy  ) IGRBaseShaderFilterCancelBlock cancelFilterProcess;
@property (nonatomic, strong) NSCache *filterCache;

@property (nonatomic, assign) CGFloat filterBarHeight;

@end

@implementation IGRFastFilterView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    IGRFastFilterViewCustomizer *customizer = [IGRFastFilterViewCustomizer defaultCustomizer];
    self.filterBarHeight = customizer.filterBarHeight;
    
    self.filterCache = [NSCache new];
    self.filterCache.countLimit = customizer.cacheSize;
    
    [self addFilterBar];
    [self addImageView];
    [self adjustViews];
}

- (void)addFilterBar
{
    IGRFiltersbarCollectionView *filterBarView = [[IGRFiltersbarCollectionView alloc] initWithFrame:self.frame];
    
    [filterBarView setDataSource:self];
    [filterBarView setDelegate:self];
    
    filterBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:filterBarView];
    self.filterBarView = filterBarView;
}

- (void)addImageView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    scrollView.backgroundColor = [UIColor clearColor];
    
    scrollView.delegate = self;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = self.frame;
    [self.scrollView addSubview:imgView];
    self.imageView = imgView;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void)adjustViews
{
    NSDictionary *views = @{@"scrollView" : self.scrollView, @"filterBarView" : self.filterBarView};
    NSDictionary *metrics = @{@"filterBarHeight": @(self.filterBarHeight)};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView]-0-[filterBarView(filterBarHeight)]-0-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:views];
    NSArray *verticalConstraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views];
    NSArray *verticalConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[filterBarView]-0-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views];
    
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints1];
    [self addConstraints:verticalConstraints2];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self zoomOutAnimated:YES];
}

- (void)updateZoomScale
{
    self.scrollView.maximumZoomScale = 1.0;
    CGFloat difH = (self.scrollView.frame.size.height / self.imageView.bounds.size.height);
    CGFloat difW = (self.scrollView.frame.size.width / self.imageView.bounds.size.width);
    self.scrollView.minimumZoomScale = MIN(difH, difW);
}

- (void)zoomOutAnimated:(BOOL)animated
{
    [self updateZoomScale];
    
    CGFloat difH = (self.scrollView.frame.size.height / self.imageView.bounds.size.height);
    CGFloat difW = (self.scrollView.frame.size.width / self.imageView.bounds.size.width);
    CGFloat zoomScale = MAX(difH, difW);
    [self.scrollView setZoomScale:zoomScale animated:animated];
    [self scrollViewDidZoom:self.scrollView];
    
    CGSize newSize = CGSizeMake(self.scrollView.frame.size.width / zoomScale,
                                self.scrollView.frame.size.height / zoomScale);
    
    CGPoint offset = CGPointMake((self.imageView.bounds.size.width - newSize.width) * 0.5,
                                 (self.imageView.bounds.size.height - newSize.height) * 0.5);
    offset = CGPointMake(offset.x * zoomScale, offset.y * zoomScale);
    
    [self.scrollView setContentOffset:offset animated:animated];
}

- (void)setProcessedImage:(UIImage *)processedImage
{
    _processedImage = processedImage;
    
    self.imageView.image = processedImage;
    [self.imageView setNeedsDisplay];
}

- (void)resetViewForImage:(UIImage *)image
{
    self.scrollView.zoomScale = 1.0;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.imageView.bounds.size;
    
    [self zoomOutAnimated:NO];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self collectionView:self.filterBarView didSelectItemAtIndexPath:indexPath];
}

- (void)setImage:(UIImage *)image
{
    [self.filterCache removeAllObjects];
    
    originalImage = image;

    [self resetViewForImage:image];
    [self.filterBarView updateWorkImage:image];
}

- (void)setShaderFilter:(__kindof IGRBaseShaderFilter *)shaderFilter
{
    [self setProgress:YES];
    
    _shaderFilter = shaderFilter;
    
    __weak typeof(self) weak = self;
    if (self.cancelFilterProcess)
    {
        self.cancelFilterProcess();
    }
    
    void(^compleatBlock)(UIImage *) = ^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weak.processedImage = image;
            [weak setProgress:NO];
        });
    };
    
    UIImage *cachedImage = [self.filterCache objectForKey:self.shaderFilter];
    if (cachedImage)
    {
        compleatBlock(cachedImage);
    }
    else
    {
        self.cancelFilterProcess = [self.shaderFilter processImage:originalImage
                                                     completeBlock:^(UIImage * _Nullable processedImage) {
                                                         compleatBlock(processedImage);
                                                         [weak.filterCache setObject:processedImage
                                                                              forKey:weak.shaderFilter];
                                                     }];
    }
}

- (void)setProgress:(BOOL)isProgress
{
    self.userInteractionEnabled = !isProgress;
}

#pragma mark - Scroll delegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(IGRFiltersbarCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return collectionView.items.count;
}

- (UICollectionViewCell *)collectionView:(IGRFiltersbarCollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifierAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(IGRFiltersbarCollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    self.shaderFilter = collectionView.items[indexPath.row];
    
    CGFloat borderOffset = [self igr_borderOffsetFromFiltersbar:collectionView];
    
    UICollectionViewLayoutAttributes *attrs = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame = attrs.frame;
    frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0.0, -borderOffset, 0.0, -borderOffset));
    [collectionView scrollRectToVisible:frame animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:NO];
}

- (CGSize)collectionView:(IGRFiltersbarCollectionView *)collectionView
                  layout:(nonnull UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return collectionView.cellSize;
}

- (CGFloat)igr_borderOffsetFromFiltersbar:(IGRFiltersbarCollectionView *)collectionView
{
    return collectionView.frame.size.height * 0.5;
}

@end
