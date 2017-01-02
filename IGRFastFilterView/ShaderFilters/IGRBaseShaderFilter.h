//
//  IGRBaseShaderFilter.h
//  IGRFastFilterViewFramework
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

@import GPUImage;

NS_ASSUME_NONNULL_BEGIN

typedef void(^IGRBaseShaderFilterCompletionBlock)(UIImage * _Nullable processedImage);
typedef void(^IGRBaseShaderFilterCancelBlock)();

@interface IGRBaseShaderFilter : GPUImageFilter

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@property (nonatomic, copy  , nullable) NSString *displayName;

@property (atomic   , strong, nullable, readonly) UIImage *preview;

- (IGRBaseShaderFilterCancelBlock)processImage:(UIImage *)image
                                completeBlock:(IGRBaseShaderFilterCompletionBlock)completeBlock;

- (void)processPreview:(UIImage *)image
        completeBlock:(IGRBaseShaderFilterCompletionBlock)completeBlock;

- (void)getPreview:(IGRBaseShaderFilterCompletionBlock)completion;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
