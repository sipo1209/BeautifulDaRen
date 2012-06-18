//
//  WeiboDetailViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboDetailViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView * detailScrollView;
@property (nonatomic, retain) NSString * userId;

@property (nonatomic, retain) IBOutlet UILabel  * contentLabel;
@property (nonatomic, retain) IBOutlet UILabel  * timestampLabel;

@property (nonatomic, retain) IBOutlet UIButton * forwardedButton;
@property (nonatomic, retain) IBOutlet UIButton * commentButton;
@property (nonatomic, retain) IBOutlet UIButton * favourateButton;

@property (nonatomic, retain) IBOutlet UIImageView * avatarImageView;
@property (nonatomic, retain) IBOutlet UIImageView * weiboAttachedImageView;
@property (nonatomic, retain) IBOutlet UIButton * weiboAttachedImageButton;

-(IBAction)onCommentListButtonPressed:(UIButton*)sender;
-(IBAction)onForwardButtonPressed:(UIButton*)sender;
-(IBAction)onImageButtonPressed:(id)sender;

-(IBAction)onBrandButtonPressed:(id)sender;
-(IBAction)onBusinessButtonPressed:(id)sender;
@end
