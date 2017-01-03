//
//  IGRToolbarCell.m
//  IGRFastFilterViewFramework
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

#import "IGRFilterbarCell.h"
#import "IGRBaseShaderFilter.h"

@interface IGRFilterbarCell ()

@property (nonatomic, weak) __kindof IGRBaseShaderFilter *item;

@property (nonatomic, weak) IBOutlet UILabel     *title;
@property (nonatomic, weak) IBOutlet UIImageView *icon;

@end       

@implementation IGRFilterbarCell

- (void)setSelected:(BOOL)selected
{
    [self.title setTextColor:selected ? self.highlightTextColor : self.textColor];
    
    [self setNeedsDisplay];
    
    super.selected = selected;
}

- (void)setItem:(__kindof IGRBaseShaderFilter *)item withThumbImage:(UIImage *)thumbImage
{
    _item = item;
    
    self.title.text = self.item.displayName;
    self.icon.image = nil;
    
    __weak typeof(self) weak = self;
    [self.item processImage:thumbImage completeBlock:^(UIImage * _Nullable processedImage) {
        self.icon.image = processedImage;
    }];
}

@end
