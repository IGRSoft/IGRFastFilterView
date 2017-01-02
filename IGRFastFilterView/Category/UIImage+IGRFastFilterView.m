//
//  IGRInstaFilters.m
//  IGRFastFilterViewFramework
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

#import "UIImage+IGRFastFilterView.h"

@implementation UIImage (IGRFastFilterView)

- (UIImage *)igr_aspectFillImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGSize selfSize = self.size;
    CGFloat scale = MAX(size.width / selfSize.width, size.height / selfSize.height);
    CGSize newSize = CGSizeMake(ceil(selfSize.width * scale), ceil(selfSize.height * scale));
    CGRect frame = CGRectMake(ceil((size.width - newSize.width) * 0.5),
                              ceil((size.height - newSize.height) * 0.5),
                              newSize.width,
                              newSize.height);
    [self drawInRect:frame];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
