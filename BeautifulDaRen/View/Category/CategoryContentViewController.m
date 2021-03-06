//
//  CategoryContentViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryContentViewController.h"
#import "CommonScrollView.h"
#import "CategoryItemCell.h"
#import "ViewConstants.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"

#define CATEGORY_CONTENT_Y_OFFSET   (70.0)

@interface CategoryContentViewController ()

@property (retain, nonatomic) NSMutableArray * contentItems;

@end

@implementation CategoryContentViewController
@synthesize contentItems = _contentItems;

@synthesize categoryListView = _categoryListView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // TODO: Read categories from network
//        NSInteger index = 0;
//        CGFloat height = CONTENT_MARGIN;
//
//        NSArray * titles = [NSArray arrayWithObjects:@"女装", @""@"美食", @"化妆品", @"裙子", nil];
//        NSArray * samples1 = [NSArray arrayWithObjects:@"hot_clothes_sample1", @""@"hot_clothes_sample2", @"hot_clothes_sample3", @"hot_clothes_sample4", nil];
//
//        NSArray * samples2 = [NSArray arrayWithObjects:@"hot_food_sample1", @""@"hot_food_sample2", @"hot_food_sample3", @"hot_food_sample4", nil];
//
//        NSArray * samples3 = [NSArray arrayWithObjects:@"hot_toiletry_sample1", @""@"hot_toiletry_sample2", @"hot_toiletry_sample3", @"hot_toiletry_sample4", nil];
//
//        NSArray * samples4 = [NSArray arrayWithObjects:@"hot_clothes_sample5", @""@"hot_clothes_sample6", @"hot_clothes_sample7", @"hot_clothes_sample8", nil];
//
//        NSArray * samples = [NSArray arrayWithObjects:samples1, samples2, samples3, samples4, nil];
//
//        _contentItems = [[NSMutableArray alloc] initWithCapacity:[titles count]];
//        while (index < [titles count]) {
//            CategoryItemCell * categoryCell = [[CategoryItemCell alloc] initWithNibName:nil bundle:nil title:[titles objectAtIndex:index] andData:[samples objectAtIndex:index]];
//
//            categoryCell.view.frame = CGRectMake(0, height, CGRectGetWidth(self.view.frame), [categoryCell getHeight]);
//
//            height += ([categoryCell getHeight] + CONTENT_MARGIN);
//
//            [self.categoryListView addSubview: categoryCell.view];
//            [_contentItems addObject:categoryCell];
//            index++;
//            [categoryCell release];
//        }
//
//        [self.categoryListView setContentSize:CGSizeMake(SCREEN_WIDTH, height)];
//        [self.categoryListView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];

    }
//
//    [self getCategoryWeiboList];

    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [_categoryListView release];
    [_contentItems release];

    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    activityIndicator.frame = CGRectMake(SCREEN_WIDTH/2, CATEGORY_TITLE_FONT_HEIGHT + CONTENT_MARGIN, CGRectGetWidth(activityIndicator.frame), CGRectGetHeight(activityIndicator.frame));

    [self.view addSubview:activityIndicator];

    [activityIndicator startAnimating];

    [[BSDKManager sharedManager] getWeiboClassesWithDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [activityIndicator release];

        NSInteger index = 0;
        CGFloat height = CONTENT_MARGIN;
        NSArray * categoryList = [data objectForKey:K_BSDK_CLASSLIST];

        _contentItems = [[NSMutableArray alloc] initWithCapacity:[categoryList count]];
        while (index < [categoryList count]) {
            CategoryItemCell * categoryCell = [[CategoryItemCell alloc] initWithNibName:nil bundle:nil category:[categoryList objectAtIndex:index]];

            categoryCell.view.frame = CGRectMake(0, height, CGRectGetWidth(self.view.frame), [categoryCell getHeight]);

            height += ([categoryCell getHeight] + CONTENT_MARGIN);

            [self.categoryListView addSubview: categoryCell.view];
            [_contentItems addObject:categoryCell];
            index++;
            [categoryCell release];
        }

        [self.categoryListView setContentSize:CGSizeMake(SCREEN_WIDTH, height)];
        [self.categoryListView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.contentItems  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
