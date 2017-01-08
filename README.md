# IGRFastFilterView

Replicate Instragram-style filters in Objective-C.

## Requirements

- Xcode 8.0+
- iOS 9.0+

## Installation

### CocoaPods

The preferred installation method is with [CocoaPods](https://cocoapods.org). Add the following to your `Podfile`:

```ruby
pod 'IGRFastFilterView'
```

### Carthage

For [Carthage](https://github.com/Carthage/Carthage), add the following to your `Cartfile`:

```ogdl
github "IGRSoft/IGRFastFilterView"
```

## Getting Started

- Add View to Storyboard or XIB 
- Set Custom Class to IGRFastFilterView
```objective-c
@import IGRFastFilterView;

@interface ViewController ()

@property (nonatomic, weak) IBOutlet IGRFastFilterView *instaFiltersView;

@end

@implementation ViewController

- (void)setupWorkImage:(UIImage *)image
{    
    [self.instaFiltersView setImage:image];
}

- (UIImage *)getProcessedImage
{
    UIImage *image = [self.instaFiltersView.processedImage copy];
    
    return image;
}

@end
```

> see sample Xcode project in /Demo

## Customization

```objective-c
- (void)setupTheme
{
    [IGRFastFilterView appearance].backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [IGRFiltersbarCollectionView appearance].backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    IGRFastFilterViewCustomizer *customizer = [IGRFastFilterViewCustomizer defaultCustomizer];
    customizer.filterBarHeight = 120.0;
    customizer.filterBarCellSize = CGSizeMake(100.0, 120.0);
        
    customizer.filterBarCellTextColor = [UIColor colorWithRed:0.255 green:0.255 blue:0.255 alpha:1.00];
    customizer.filterBarCellHighlightTextColor = [UIColor colorWithRed:0.050 green:0.350 blue:0.650 alpha:1.00];
        
    customizer.cacheSize = 5;
}
```

## TODO

- Add Filter to Video

## Credits

`IGRFastFilterView` is owned and maintained by the [IGR Software and Vitalii Parovishnyk](https://igrsoft.com).

## License

`IGRFastFilterView` is MIT-licensed. We also provide an additional patent grant.
