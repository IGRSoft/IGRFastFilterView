//
//  IGRFastFilterViewCustomizer.m
//  IGRFastFilterView
//
//  Created by Vitalii Parovishnyk on 1/3/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

#import "IGRFastFilterViewCustomizer.h"

@implementation IGRFastFilterViewCustomizer

+ (instancetype)defaultCustomizer
{
    static IGRFastFilterViewCustomizer *defaultCustomizer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCustomizer = [IGRFastFilterViewCustomizer new];
    });
    
    return defaultCustomizer;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _filterBarHeight = 120.0;
        _filterBarCellSize = CGSizeMake(100.0, 120.0);
        
        _filterBarCellTextColor = [UIColor colorWithRed:0.255 green:0.255 blue:0.255 alpha:1.00];
        _filterBarCellHighlightTextColor = [UIColor colorWithRed:0.050 green:0.350 blue:0.650 alpha:1.00];
        
        _cacheSize = 5;
    }
    
    return self;
}

@end
