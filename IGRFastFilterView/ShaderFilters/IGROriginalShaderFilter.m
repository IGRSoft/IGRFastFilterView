//
//  IGROriginalShaderFilter.m
//  IGRFastFilterView
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

#import "IGROriginalShaderFilter.h"



@interface IGROriginalShaderFilter ()

@property (atomic, nullable, strong, readwrite) UIImage *preview;

@end

@implementation IGROriginalShaderFilter

@synthesize preview;

- (IGRBaseShaderFilterCancelBlock)processImage:(UIImage *)image
                                completeBlock:(IGRBaseShaderFilterCompletionBlock)completeBlock
{
    completeBlock(image);
    
    return ^{};
}

- (void)processPreview:(UIImage *)image completeBlock:(IGRBaseShaderFilterCompletionBlock)completeBlock
{
    self.preview = image;
    completeBlock(image);
}

@end
