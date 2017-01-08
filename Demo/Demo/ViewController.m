//
//  IGRMainViewController.m
//  InstaFilters
//
//  Created by Vitalii Parovishnyk on 12/29/16.
//  Copyright © 2016 IGR Software. All rights reserved.
//

@import IGRFastFilterView;

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet IGRFastFilterView *instaFiltersView;

@end

static NSString * const kWorkImageNotification = @"WorkImageNotification";
#define DEMO_IMAGE [UIImage imageNamed:@"demo"]

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTheme];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(setupWorkImage:)
                          name:kWorkImageNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupDemoView];
    });
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:kWorkImageNotification object:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.instaFiltersView layoutSubviews];
    } completion:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Setter / Getter

- (void)setInstaFiltersView:(IGRFastFilterView *)instaFiltersView
{
    _instaFiltersView = instaFiltersView;
}

#pragma mark - Private

- (void)setupTheme
{
    [IGRFastFilterView appearance].backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [IGRFiltersbarCollectionView appearance].backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
}

- (void)setupDemoView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kWorkImageNotification
                                                        object:DEMO_IMAGE];
}

- (UIImage *)prepareImage
{
    return self.instaFiltersView.processedImage;
}

#pragma mark - Action

- (IBAction)onTouchGetImageButton:(UIBarButtonItem *)sender
{
    UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Select image", @"")
                                                                   message:@""
                                                            preferredStyle:style];
    
    alert.popoverPresentationController.barButtonItem = sender;
    
    __weak typeof(self) weak = self;
    void(^completeActionBlock)(UIImagePickerControllerSourceType) = ^(UIImagePickerControllerSourceType type) {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.delegate = weak;
        [pickerView setSourceType:type];
        [self presentViewController:pickerView animated:YES completion:nil];
    };
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"From Library", @"")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       completeActionBlock(UIImagePickerControllerSourceTypePhotoLibrary);
                                                   }];
    [alert addAction:action];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"From Camera", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             completeActionBlock(UIImagePickerControllerSourceTypeCamera);
                                                         }];
    [alert addAction:cameraAction];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
				
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onTouchShareButton:(UIBarButtonItem *)sender
{
    UIImage *image = [self prepareImage];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[image]
                                                                      applicationActivities:nil];
    avc.popoverPresentationController.barButtonItem = sender;
    avc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - NSNotificationCenter

- (void)setupWorkImage:(NSNotification *)notification
{
    NSAssert([notification.object isKindOfClass:[UIImage class]], @"Image only allowed!");
    
    [self.instaFiltersView setImage:notification.object];
}

#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *img = [info valueForKey:UIImagePickerControllerOriginalImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWorkImageNotification
                                                        object:img];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
