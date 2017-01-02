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

//TODO: Add to config
#define IGRNONSELECTED_COLOR    [UIColor colorWithRed:0.255 green:0.255 blue:0.255 alpha:1.00]
#define IGRSELECTED_COLOR       [UIColor colorWithRed:0.050 green:0.350 blue:0.650 alpha:1.00]

@implementation IGRFilterbarCell

- (void)setSelected:(BOOL)selected
{
    [self.title setTextColor:selected ? IGRSELECTED_COLOR : IGRNONSELECTED_COLOR];
    
    [self setNeedsDisplay];
    
    super.selected = selected;
}

- (void)setItem:(__kindof IGRBaseShaderFilter *)item
{
    _item = item;
    
    self.title.text = self.item.displayName;
    self.icon.image = nil;
    
    __weak typeof(self) weak = self;
    [self.item getPreview:^(UIImage * _Nullable processedImage) {
        if (weak.item == item)
        {
            weak.icon.image = processedImage;
        }
    }];
}

@end
