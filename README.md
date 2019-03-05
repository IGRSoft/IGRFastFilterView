IGRFastFilterView
=

<p align="center">
  <img src="https://raw.githubusercontent.com/IGRSoft/IGRFastFilterView/master/Screenshots/screen.png" width="120"/>
</p>

Replicate Instragram-style filters in Objective-C (Swift 3.0 Compatibility).

[![Build Status](https://travis-ci.org/IGRSoft/IGRFastFilterView.svg)](https://travis-ci.org/IGRSoft/IGRFastFilterView)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](http://www.apple.com/ios/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/IGRFastFilterView.svg)](https://img.shields.io/cocoapods/v/IGRFastFilterView.svg)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://opensource.org/licenses/MIT)

 ___
### Contribute to Development Goals Here: 

BTC: 16tGJzt4gJJBhBetpV6BuaWuNfxvkdkbt4

BCH: bitcoincash:qpcwefpxddjqzdpcrx6tek3uh6x9v7t8tugu30jvks

LTC: litecoin:MLZxuAdJCaW7LdM4sQuRazgdNvd8G2bdyt

 ___
### How It Works
It is built upon [GPUImage](https://github.com/BradLarson/GPUImage), written open sourced framework by [Brad Larson](http://stackoverflow.com/users/19679/brad-larson) that hanles low-level GPU interactions on **IGRFastFilterView**'s behalf.

The GPUImage framework is a BSD-licensed iOS library that lets you apply GPU-accelerated filters and other effects to images, live camera video, and movies. In comparison to Core Image (part of iOS 5.0), GPUImage allows you to write your own custom filters, supports deployment to iOS 4.0, and has a simpler interface. However, it currently lacks some of the more advanced features of Core Image, such as facial detection.

For massively parallel operations like processing images or live video frames, GPUs have some significant performance advantages over CPUs. On an iPhone 4, a simple image filter can be over 100 times faster to perform on the GPU than an equivalent CPU-based filter.

## Filters
- 1977
- Amaro
- Brannan
- Earlybird
- Hefe
- Hudson
- Inkwell
- Lomo
- Lord Kelvin
- Nashville
- Rise
- Sierra
- Sutro
- Toaster
- Valencia
- Walden
- Xproll

 ___
### Requirements

- Xcode 8.0+
- iOS 9.0+

 ___
### Installation

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
 ___
### Getting Started

- Add View to Storyboard or XIB 
- Set Custom Class to IGRFastFilterView

<details>
  <summary>Objective-C</summary>
  <p>
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
    return self.instaFiltersView.processedImage;
}

@end
```
</p></details>
<details>
  <summary>Swift 3.0</summary>
  <p>
```swift
import IGRFastFilterView

class ViewController: UIViewController {
    @IBOutlet weak fileprivate var instaFiltersView: IGRFastFilterView?
    
    func setupWorkImage(image: UIImage) {
        instaFiltersView?.setImage(image)
    }
    
    func prepareImage() -> UIImage {
        return self.instaFiltersView!.processedImage!;
    }
}
```
</p></details>

> see sample Xcode project in /Demo

 ___
### Customization

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

 ___
### TODO
 - [x] Add Filters to Images
 - [ ] Add Filters to Video
 - [ ] Add Custom Filters

 ___
### Credits

`IGRFastFilterView` is owned and maintained by the [IGR Software and Vitalii Parovishnyk](https://igrsoft.com).

 ___
### License

`IGRFastFilterView` is MIT-licensed. We also provide an additional patent grant.
