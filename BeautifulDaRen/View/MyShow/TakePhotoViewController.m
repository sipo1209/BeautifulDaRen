//
//  FirstViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "WeiboForwardCommentViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "iToast.h"

@interface TakePhotoViewController ()
@property (nonatomic, retain)  TakePhotoViewController * galleryPhotoViewController;
@property (nonatomic, assign)  UIImagePickerControllerSourceType currentSourceType; 
@property (nonatomic, assign)  BOOL isCameraReady;
- (void)setToolbar;
@end

@implementation TakePhotoViewController

@synthesize delegate = _delegate;
@synthesize imagePickerController = _imagePickerController;
@synthesize galleryPhotoViewController = _galleryPhotoViewController;
@synthesize currentSourceType = _currentSourceType;
@synthesize toolbarView = _toolbarView;
@synthesize isCameraReady = _isCameraReady;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _currentSourceType = UIImagePickerControllerSourceTypeCamera;
        _isCameraReady = NO;
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    _imagePickerController = nil;
    _toolbarView = nil;
    _galleryPhotoViewController = nil;
}

- (void)dealloc
{
    [_imagePickerController release];
    [_toolbarView release];
    [_galleryPhotoViewController release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//
//    if (self.currentSourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
//        self.imagePickerController.cameraOverlayView = nil;
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)onGalleryBartButtonPressed {
    [self.delegate didChangeToGalleryMode];
//    self.imagePickerController.cameraOverlayView = nil;
}

- (void)onCameraBarButtonPressed {
    if (self.isCameraReady) {
        [self.imagePickerController performSelector:@selector(takePicture) withObject:nil afterDelay:0.5];
    }
    else
    {
        [[iToast makeText:@"照相机还没准备好!"] show];
    }
}

//- (void)takePicture {
//    [self.imagePickerController takePicture];  
//}

- (void)onAvatarBartButtonPressed {
    
}

- (void)setToolbar
{
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *galleryBarButton = [ViewHelper getBarItemOfTarget:self action:@selector(onGalleryBartButtonPressed) title:@"相册"];
    
    UIBarButtonItem *cameraBarButton = [ViewHelper getCameraBarItemOftarget:self action:@selector(onCameraBarButtonPressed)];
    
    UIBarButtonItem *avatarBarButton = [ViewHelper getBarItemOfTarget:self action:@selector(onAvatarBartButtonPressed) title:@"头像"];

    
    NSArray *barItems = [[NSArray alloc]initWithObjects:galleryBarButton, 
                         flexible,
                         cameraBarButton,
                         flexible,
                         avatarBarButton,
                         nil];
    
    self.toolbarView.items= barItems;
    
    [barItems release];
    [flexible release];
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    [self.imagePickerController setSourceType:sourceType];
    self.currentSourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.imagePickerController.showsCameraControls = NO;

        CGRect defaultFrame = self.imagePickerController.cameraOverlayView.frame;
        CGRect newFrame = CGRectMake(0.0,
                                     SCREEN_HEIGHT -
                                     TOOL_BAR_HEIGHT - 10.0,
                                     CGRectGetWidth(defaultFrame),
                                     TOOL_BAR_HEIGHT + 10.0);
        self.view.frame = newFrame;
        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            self.toolbarView.frame = newFrame;
            UIImageView * tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_toolbar_background"]];
            tabBarBg.frame = CGRectMake(0, 0, 320, 55);
            tabBarBg.contentMode = UIViewContentModeScaleToFill;
            if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
                [self.toolbarView  insertSubview:tabBarBg atIndex:0];
            }
            else
            {
                [self.toolbarView  insertSubview:tabBarBg atIndex:1];            
            }
            [self setToolbar];
            [tabBarBg release];
            [self.imagePickerController.cameraOverlayView addSubview:self.toolbarView];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cameraIsReady:)
                                                 name:AVCaptureSessionDidStartRunningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cameraIsNotReady:)
                                                 name:AVCaptureSessionDidStopRunningNotification object:nil];
}

- (void)cameraIsReady:(NSNotification *)notification
{   
    NSLog(@"Camera is ready...");
    // Whatever
    _isCameraReady = YES;
}

- (void)cameraIsNotReady:(NSNotification *)notification
{   
    NSLog(@"Camera is NOT ready...");
    // Whatever
    _isCameraReady = NO;
}
#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // give the taken picture to our delegate
    if (self.delegate)
        [self.delegate didTakePicture:image];

    if (self.currentSourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [self.galleryPhotoViewController dismissModalViewControllerAnimated:NO];
        self.galleryPhotoViewController = nil;
        self.currentSourceType = UIImagePickerControllerSourceTypeCamera;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    if (self.currentSourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self dismissModalViewControllerAnimated:YES];
    }
    [self.delegate didFinishWithCamera]; 
}

@end
















