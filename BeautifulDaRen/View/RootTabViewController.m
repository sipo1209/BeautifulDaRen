//
//  RootTabViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootTabViewController.h"
#import "ViewConstants.h"
#import "CustomUITabBarItem.h"
#import "BSDKManager.h"
#import "ViewConstants.h"
#import "HomeViewController.h"
#import "UIImage+Scale.h"
#import "WeiboComposerViewController.h"
#import "MyShowViewController.h"
#import "CategoryViewController.h"
#import "LoginViewController.h"
#import "MineViewController.h"
#import "FindMoreViewController.h"

#define INDEX_MINE_VIEW_NAVIGATION (2)

@interface RootTabViewController()

@property (retain, nonatomic) id observerForNewInfoToMe;
@property (assign, nonatomic) UINavigationController * mineViewNavigationController;

- (void)initLocalizedString;
- (void)startMyshowAction;
@end

@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"nav_bar_background"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation RootTabViewController
@synthesize mineViewNavigationController = _mineViewNavigationController;
@synthesize observerForNewInfoToMe = _observerForNewInfoToMe;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_observerForNewInfoToMe];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self initLocalizedString];

    if (!SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_background"] forBarMetrics:UIBarMetricsDefault];

        [[UIToolbar appearance]setBackgroundImage:[UIImage imageNamed:@"toolbar_background"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    }
    _observerForNewInfoToMe = [[NSNotificationCenter defaultCenter]
                          addObserverForName:K_NOTIFICATION_MINE_NEW_INFO
                          object:nil
                          queue:nil
                          usingBlock:^(NSNotification *notification) {
                              
                              NSDictionary * apsDict = [notification valueForKey:@"userInfo"];
                              NSLog(@"notification:\n%@",notification);
                              NSInteger newCount = [[apsDict valueForKey:@"badge"] intValue];
                              if (newCount > 0) {
                                  self.mineViewNavigationController.tabBarItem.badgeValue = [[NSNumber numberWithInteger:newCount] stringValue];
                              }
                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:newCount] forKey:USERDEFAULT_MY_NEW_NOTIFICATION_COUNT];

                              NSDictionary * notisDict = [apsDict valueForKey:@"notifications"];

                              NSInteger newAtCount = [[notisDict valueForKey:@"newAtNum"] intValue];
                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:newAtCount] forKey:USERDEFAULT_AT_ME_NOTIFICATION_COUNT];

                              NSInteger newMessageCount = [[notisDict valueForKey:@"newPrivateNum"] intValue];
                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:newMessageCount] forKey:USERDEFAULT_PRIVATE_MESSAGE_NOTIFICATION_COUNT];

                              NSInteger newFollowCount = [[notisDict valueForKey:@"newAttentionNum"] intValue];
                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:newFollowCount] forKey:USERDEFAULT_FOLLOW_ME_NOTIFICATION_COUNT];

                              NSInteger newCommentCount = [[notisDict valueForKey:@"newCommentNum"] intValue];
                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:newCommentCount] forKey:USERDEFAULT_COMMENT_ME_NOTIFICATION_COUNT];
                          }];

    NSNumber * count = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_MY_NEW_NOTIFICATION_COUNT];
    self.mineViewNavigationController.tabBarItem.badgeValue =  count.intValue > 0 ? [[NSNumber numberWithInteger:count.integerValue] stringValue] : nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSAssert([viewController isKindOfClass:[UINavigationController class]],@"viewController should be UINavigationController");
    UINavigationController * navController = (UINavigationController*)viewController;
    [navController popToRootViewControllerAnimated:NO];
    // when clicked HomeView, it should be turn to home view.
    if (![[BSDKManager sharedManager] isLogin] && 
        !([navController.topViewController isKindOfClass:[HomeViewController class]] ||
          [navController.topViewController isKindOfClass:[CategoryViewController class]] ||
          [navController.topViewController isKindOfClass:[FindMoreViewController class]] )) {

        LoginViewController * loginContorller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: loginContorller];
        [self presentModalViewController:navController animated:YES];
        [navController release];
        [loginContorller release];

        return NO;
    }
    else if ( [navController.topViewController isKindOfClass:[MyShowViewController class]] )
    {
        [self startMyshowAction];
        return NO;
    }

    return YES;
}

- (void)initLocalizedString
{
    NSArray* homeArray = nil;

    homeArray = [NSArray arrayWithObjects:@"",NSLocalizedString(@"tab_home", @"tab_home"),nil];   

    NSArray* categoryArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_hot", @"tab_hot"),NSLocalizedString(@"tab_hot", @"tab_hot"),nil];
    NSArray* cameraShareArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_myshow", @"tab_myshow"),NSLocalizedString(@"tab_myshow", @"tab_myshow"),nil];
    NSArray* mineArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_mine", @"tab_mine"),NSLocalizedString(@"tab_mine", @"tab_mine"),nil];
    NSArray* moreArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_search", @"tab_search"), NSLocalizedString(@"tab_search", @"tab_search"),nil];
    NSArray* localizedStringsArray = [NSArray arrayWithObjects:homeArray, categoryArray, mineArray, moreArray, cameraShareArray, nil];

    NSArray* tabbarIconNamesArray = [NSArray arrayWithObjects:@"tabbar_home_icon", @"tabbar_hot_icon", @"tabbar_mine_icon", @"tabbar_search_icon", @"tabbar_show_icon", nil];

    NSInteger index = 0;
    for (UINavigationController* navigation in [self customizableViewControllers]){
        if (index == INDEX_MINE_VIEW_NAVIGATION) {
            self.mineViewNavigationController = navigation;
        }
        UINavigationItem* navigationItem = navigation.topViewController.navigationItem;
        NSArray* textArray = [localizedStringsArray objectAtIndex:index];
        [navigationItem setTitle:[textArray objectAtIndex:0]];

        CustomUITabBarItem * tempTabBarItem = [[CustomUITabBarItem alloc] initWithTitle:[textArray objectAtIndex:1] normalImage:[UIImage imageNamed:[tabbarIconNamesArray objectAtIndex:index]] highlightedImage:[UIImage imageNamed:[tabbarIconNamesArray objectAtIndex:index]] tag:index];
        navigation.tabBarItem = tempTabBarItem;
        [tempTabBarItem release];
        index++;
    }

    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        UIImageView * tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_background"]];
        tabBarBg.frame = CGRectMake(0, 0, 320, 50);
        tabBarBg.contentMode = UIViewContentModeScaleToFill;

        [self.tabBar insertSubview:tabBarBg atIndex:0];
        [tabBarBg release];
    }
    else
    {
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet destructiveButtonIndex])
    {
        switch (actionSheet.tag)
        {
            case ACTIONSHEET_IMAGE_PICKER:
            {
                NSString *pressed = [actionSheet buttonTitleAtIndex:buttonIndex];

                if ([pressed isEqualToString:IMAGE_PICKER_CAMERA])
                {
                    UIImagePickerController * imagePicker = [APPDELEGATE getImagePicker];

                    [imagePicker setDelegate: self];
                    [imagePicker setSourceType: UIImagePickerControllerSourceTypeCamera];

                    [self presentModalViewController:imagePicker animated:YES];

                }
                else if ([pressed isEqualToString:IMAGE_PICKER_LIBRARY])
                {
                    UIImagePickerController * imagePicker = [APPDELEGATE getImagePicker];

                    [imagePicker setDelegate: self];
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

                     [self presentModalViewController:imagePicker animated:YES];
                }
                else if ([pressed isEqualToString:IMAGE_PICKER_DELETE])
                {
                    // TODO:
                }
            }
            default:
                break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:NO];

    WeiboComposerViewController *weiboComposerViewControlller =
    [[WeiboComposerViewController alloc] initWithNibName:nil bundle:nil];

    weiboComposerViewControlller.selectedImage = [image scaleToSize:CGSizeMake(320.0, image.size.height * 320.0/image.size.width)];

    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboComposerViewControlller];

    [self presentModalViewController:navController animated:YES];
    [weiboComposerViewControlller release];
    [navController release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissModalViewControllerAnimated:YES];
}

- (void)startMyshowAction
{
    UIActionSheet * imagePickerActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil];

    imagePickerActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    imagePickerActionSheet.tag = ACTIONSHEET_IMAGE_PICKER;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_CAMERA];
        }
    }

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_LIBRARY];
    }

    if ([imagePickerActionSheet numberOfButtons] > 0)
    {
        [imagePickerActionSheet setDestructiveButtonIndex:[imagePickerActionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")]];
        [imagePickerActionSheet showInView:self.view];
    }

    [imagePickerActionSheet release];
}

@end
