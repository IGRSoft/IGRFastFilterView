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
    UIImage *image = [self.instaFiltersView.processedImage copy];
    
    return image;
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
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"From Library", @"")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
                                 pickerView.delegate = weak;
                                 [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                 [self presentViewController:pickerView animated:YES completion:nil];
                             }];
    [alert addAction:action];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"From Camera", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                       UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
                                       pickerView.delegate = weak;
                                       [pickerView setSourceType:UIImagePickerControllerSourceTypeCamera];
                                       [self presentViewController:pickerView animated:YES completion:nil];
                                   }];
    [alert addAction:cameraAction];
    
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
				
				
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onTouchShareButton:(UIBarButtonItem *)sender
{
    __unused UIImage *image = [self prepareImage];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[image]
                                                                      applicationActivities:nil];
    avc.popoverPresentationController.barButtonItem = sender;
    avc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [viewController presentViewController:avc animated:YES completion:nil];
}

#pragma mark - NSNotificationCenter

- (void)setupWorkImage:(NSNotification *)notification
{
    NSAssert([notification.object isKindOfClass:[UIImage class]], @"Image only allowed!");
    
    [self.instaFiltersView setImage:notification.object];
}

#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *img = [info valueForKey:UIImagePickerControllerOriginalImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWorkImageNotification
                                                        object:img];
}

@end
