//
//  SecondViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MineViewController.h"
#import "MineEditingViewController.h"
#import "MyInfoTopViewCell.h"
#import "GridViewCell.h"
#import "ButtonViewCell.h"
#import "ViewConstants.h"
#import "DataManager.h"
#import "WeiboListViewController.h"
#import "ViewHelper.h"
#import "PrivateLetterViewController.h"
#import "FriendListViewController.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "BSDKManager.h"
#import "iToast.h"
#import "LoginViewController.h"

@interface MineViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UIButton * followButton;
@property (retain, nonatomic) IBOutlet UIButton * fansButton;
@property (retain, nonatomic) IBOutlet UIButton * collectionButton;
@property (retain, nonatomic) IBOutlet UIButton * blackListButton;
@property (retain, nonatomic) IBOutlet UIButton * buyedButton;
@property (retain, nonatomic) IBOutlet UIButton * mypublishButton;
@property (retain, nonatomic) IBOutlet UIButton * topicButton;
@property (retain, nonatomic) IBOutlet UIButton * editButton;

-(void)refreshUserInfo;

@end

@implementation MineViewController
@synthesize tableView = _tableView;
@synthesize followButton = _followButton;
@synthesize fansButton = _fansButton;
@synthesize collectionButton = _collectionButton;
@synthesize blackListButton = _blackListButton;
@synthesize buyedButton = _buyedButton;
@synthesize topicButton = _topicButton;
@synthesize editButton = _editButton;
@synthesize mypublishButton = _mypublishButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)dealloc
{
    [super dealloc];
    [_followButton release];
    [_fansButton release];
    [_collectionButton release];
    [_blackListButton release];
    [_buyedButton release];
    [_topicButton release];
    [_editButton release];
    [_mypublishButton release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"title_mine", @"title_mine")];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onRefreshButtonClick) title:NSLocalizedString(@"refresh", @"refresh")]];
    [self refreshUserInfo];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.followButton = nil;
    self.fansButton = nil;
    self.collectionButton = nil;
    self.blackListButton = nil;
    self.buyedButton = nil;
    self.topicButton = nil;
    self.editButton = nil;
    self.mypublishButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) onRefreshButtonClick
{
    [self refreshUserInfo];
}

#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * myInfoTopViewIdentifier = @"MyInfoTopViewCell";
    static NSString * gridViewIndentifier = @"GridViewCell";
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:myInfoTopViewIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:myInfoTopViewIdentifier owner:self options:nil] objectAtIndex:0];
        }
        
        NSDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
        ((MyInfoTopViewCell*)cell).avatarImageView.image = [UIImage imageNamed:@"avatar_big"];
        ((MyInfoTopViewCell*)cell).levelLabel.text = [NSString stringWithFormat:@"LV%d",
                                                      [[userDict valueForKey:USERDEFAULT_ACCOUNT_LEVEL] intValue]];
        ((MyInfoTopViewCell*)cell).levelLabelTitle.text = [NSString stringWithFormat:@"%@%d",
                                                           NSLocalizedString(@"point", @"point"),
                                                           [[userDict valueForKey:USERDEFAULT_ACCOUNT_POINT] intValue]];
        ((MyInfoTopViewCell*)cell).beautifulIdLabel.text = [userDict valueForKey:USERDEFAULT_ACCOUNT_USERNAME];
        ((MyInfoTopViewCell*)cell).rightImageView.image = [UIImage imageNamed:@"gender_female"];
        ((MyInfoTopViewCell*)cell).editImageView.image = [UIImage imageNamed:@"my_edit"];
        ((MyInfoTopViewCell*)cell).cityLabel.text = [NSString stringWithFormat:@"%@ %@", [userDict valueForKey:USERDEFAULT_ACCOUNT_CITY], [userDict valueForKey:USERDEFAULT_ACCOUNT_ADDRESS]];
        _editButton = ((MyInfoTopViewCell*)cell).editButton;
        ((MyInfoTopViewCell*)cell).delegate = self;
    }
    else if(section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:gridViewIndentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:gridViewIndentifier owner:self options:nil] objectAtIndex:1];
        }
        ((GridViewCell*)cell).delegate = self;
        
        NSDictionary * userDict = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
        NSMutableAttributedString * attrStr = nil;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"follow", @"") detail:[NSString stringWithFormat:@"(%d)", [[userDict valueForKey:USERDEFAULT_ACCOUNT_FOLLOW_COUNT] intValue]]];
        ((GridViewCell*)cell).firstLabel.attributedText = attrStr;
        ((GridViewCell*)cell).firstLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"fans", @"") detail:[NSString stringWithFormat:@"(%d)", [[userDict valueForKey:USERDEFAULT_ACCOUNT_FANS_COUNT] intValue]]];
        ((GridViewCell*)cell).secondLabel.attributedText = attrStr;
        ((GridViewCell*)cell).secondLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"collection", @"") detail:[NSString stringWithFormat:@"(%d)", [[userDict valueForKey:USERDEFAULT_ACCOUNT_FAVORITE_COUNT] intValue]]];
        ((GridViewCell*)cell).thirdLabel.attributedText = attrStr;
        ((GridViewCell*)cell).thirdLabel.textAlignment = UITextAlignmentCenter;
        
        attrStr = [ViewHelper getGridViewCellForContactInformationWithName:NSLocalizedString(@"my_publish", @"") detail:[NSString stringWithFormat:@"(%d)", [[userDict valueForKey:USERDEFAULT_ACCOUNT_WEIBO_COUNT] intValue]]];
        ((GridViewCell*)cell).fourthLabel.attributedText = attrStr;
        ((GridViewCell*)cell).fourthLabel.textAlignment = UITextAlignmentCenter;

        _followButton = ((GridViewCell*)cell).firstButton;
        _fansButton = ((GridViewCell*)cell).secondButton;
        _collectionButton = ((GridViewCell*)cell).thirdButton;
        _mypublishButton = ((GridViewCell*)cell).fourthButton;
    }
    else if (section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row]) {
            case 0:
            {
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"at_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"my_at"];
                break;
            }
            case 1:
            {
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"comment_me", @"");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"comment_icon"];
                break;
            }
        }
    }
    else if (section == 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"switch_account", @"");
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"comment_icon"];
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
            numberOfRows = 1;
            break;
        case 2:
            numberOfRows = 2;
            break;
        case 3:
            numberOfRows = 1;
            break;
    }
    return numberOfRows;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        height = 72.0f;
    }
    else if (section == 1)
    {
        height = 71.0f;
    }
    else if (section == 2)
    {
        height = 40.0f;
    }
    else if (section == 3)
    {
        height = 40.0f;
    }
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    // 我发表的 and 私信
    if(section == 2)
    {
        switch ([indexPath row]) {
            case 0:
            {
                WeiboListViewController * forwadMeViewController = [[WeiboListViewController alloc]
                                                                    initWithNibName:@"WeiboListViewController"
                                                                    bundle:nil
                                                                    type:WeiboListViewControllerType_FORWARD_ME
                                                                    dictionary:nil];
                
                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: forwadMeViewController];
                
                [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
                
                [navController release];
                [forwadMeViewController release];
                break;
            }
            case 1:
            {
                WeiboListViewController * commentMeViewController = [[WeiboListViewController alloc]
                                                                     initWithNibName:@"WeiboListViewController"
                                                                     bundle:nil
                                                                     type:WeiboListViewControllerType_COMMENT_ME
                                                                     dictionary:nil];
                
                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: commentMeViewController];
                
                [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
                [navController release];
                [commentMeViewController release];
                break;
            }
        }
    }
    else if(section == 3)
    {
        [[BSDKManager sharedManager] logoutWithDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
            if(status == AIO_STATUS_SUCCESS)
            {
                LoginViewController * loginContorller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                [self.navigationController pushViewController:loginContorller animated:YES];
                [loginContorller release];
            }
            else {
                [[iToast makeText:@"账户退出失败!"] show];
            }
        }];

    }
}

#pragma mark ButtonPressDelegate
- (void) didButtonPressed:(UIButton*)button inView:(UIView *)view
{
    UIViewController * viewController = nil;
    if(button == _followButton)
    {
        viewController = [[FriendListViewController alloc]
                          initWithNibName:@"FriendListViewController"
                          bundle:nil
                          type:FriendListViewController_TYPE_MY_FOLLOW
                          dictionary:nil];
    }
    else if (button == _fansButton)
    {
        viewController = [[FriendListViewController alloc]
                          initWithNibName:@"FriendListViewController"
                          bundle:nil
                          type:FriendListViewController_TYPE_MY_FANS
                          dictionary:nil];
    }
    else if (button == _collectionButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_MY_COLLECTION
                          dictionary:nil];
    }
    else if (button == _blackListButton)
    {
        viewController = [[FriendListViewController alloc]
                          initWithNibName:@"FriendListViewController"
                          bundle:nil
                          type:FriendListViewController_TYPE_MY_BLACKLIST
                          dictionary:nil];
    }
    else if(button == _buyedButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_MY_BUYED
                          dictionary:nil];
    }
    else if(button == _topicButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_MY_BUYED
                          dictionary:nil];
    }
    else if(button == _editButton)
    {
        viewController = [[MineEditingViewController alloc]
                          initWithNibName:@"MineEditingViewController"
                          bundle:nil];
        
    }
    else if(button == _mypublishButton)
    {
        viewController = [[WeiboListViewController alloc]
                          initWithNibName:@"WeiboListViewController"
                          bundle:nil
                          type:WeiboListViewControllerType_MY_PUBLISH
                          dictionary:nil];
    }
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: viewController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    [navController release];
    [viewController release];
}
-(void)refreshUserInfo
{
    NSDictionary * accountInfo = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
               [accountInfo valueForKey:@"UserName"],      USERDEFAULT_ACCOUNT_USERNAME,
               [accountInfo valueForKey:@"UserType"],      USERDEFAULT_ACCOUNT_USER_TYPE,
               [accountInfo valueForKey:@"Sex"],           USERDEFAULT_ACCOUNT_GENDER,
               [accountInfo valueForKey:@"id"],            USERDEFAULT_ACCOUNT_ID,
               [accountInfo valueForKey:@"Email"],         USERDEFAULT_ACCOUNT_EMAIL,
               [accountInfo valueForKey:@"Address"],       USERDEFAULT_ACCOUNT_ADDRESS,
               [accountInfo valueForKey:@"Tel"],           USERDEFAULT_ACCOUNT_PHONE_NUMBER,
               [accountInfo valueForKey:@"City"],          USERDEFAULT_ACCOUNT_CITY,
               [accountInfo valueForKey:@"IsVerify"],      USERDEFAULT_ACCOUNT_IS_VERIFY,
               [accountInfo valueForKey:@"Levels"],        USERDEFAULT_ACCOUNT_LEVEL,
               [accountInfo valueForKey:@"Points"],        USERDEFAULT_ACCOUNT_POINT,
               [accountInfo valueForKey:@"Intro"],         USERDEFAULT_ACCOUNT_INTRO,
               [accountInfo valueForKey:@"Prov"],          USERDEFAULT_ACCOUNT_PROV,
               [accountInfo valueForKey:@"CreateTime"],    USERDEFAULT_ACCOUNT_CREATE_TIME,
               [accountInfo valueForKey:@"AtNum"],         USERDEFAULT_ACCOUNT_FORWARD_COUNT,
               [accountInfo valueForKey:@"AttentionNum"],  USERDEFAULT_ACCOUNT_FOLLOW_COUNT,
               [accountInfo valueForKey:@"BlackListNum"],  USERDEFAULT_ACCOUNT_BLACK_LIST_COUNT,
               [accountInfo valueForKey:@"BlogNum"],       USERDEFAULT_ACCOUNT_WEIBO_COUNT,
               [accountInfo valueForKey:@"BuyNum"],        USERDEFAULT_ACCOUNT_BUYED_COUNT,
               [accountInfo valueForKey:@"CommentNum"],    USERDEFAULT_ACCOUNT_COMMENT_COUNT,
               [accountInfo valueForKey:@"FansNum"],       USERDEFAULT_ACCOUNT_FANS_COUNT,
               [accountInfo valueForKey:@"FavNum"],        USERDEFAULT_ACCOUNT_FAVORITE_COUNT,
               [accountInfo valueForKey:@"PrivateMsgNum"], USERDEFAULT_ACCOUNT_PRIVATE_MSG_COUNT,
               [accountInfo valueForKey:@"TopicNum"],      USERDEFAULT_ACCOUNT_TOPIC_COUNT,
               nil];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];

}
@end
