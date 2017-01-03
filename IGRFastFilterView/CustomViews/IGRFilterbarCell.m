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

- (void)setItem:(__kindof IGRBaseShaderFilter *)item
{
    _item = item;
    
    self.title.text = self.item.displayName;
    self.icon.image = nil;
    
    __weak typeof(self) weak = self;
    [self.item preview:^(UIImage * _Nullable processedImage) {
        if (weak.item == item)
        {
            weak.icon.image = processedImage;
        }
    }];
}

@end
