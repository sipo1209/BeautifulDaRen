//
//  Header.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#ifndef BeautifulDaRen_ViewConstants_Header_h
#define BeautifulDaRen_ViewConstants_Header_h

#define ADS_CELL_WIDTH              (320)
#define ADS_CELL_HEIGHT             (67)
#define USER_INFOR_CELL_HEIGHT      (80)

#define CONTENT_MARGIN              (5.0)


#define NAVIGATION_LEFT_LOGO_WIDTH (90.0)
#define NAVIGATION_LEFT_LOGO_HEIGHT (27.0)

#define SCROLL_ITEM_MARGIN      (11.0)
#define SCROLL_ITEM_WIDTH       (66.0)
#define SCROLL_ITEM_HEIGHT      (66.0)

#define CATEGORY_TITLE_FONT_HEIGHT  (14.0f)
#define CATEGORY_TITLE_MARGIN  (14.0f)
#define CATEGORY_ITEM_HEIGHT  (CATEGORY_TITLE_FONT_HEIGHT + CATEGORY_TITLE_MARGIN + SCROLL_ITEM_HEIGHT)

#define KEY_CATEGORY_TITLE      @"CATEGORY_TITLE"
#define KEY_CATEGORY_ITEMS      @"CATEGORY_ITEMS"

#define SCREEN_WIDTH                ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)

#define VERTICAL_SCROLL_VIEW_BOUNCE_SIZE (50.0)

#define TOOL_BAR_HEIGHT             (44.0)
#define NAVIGATION_BAR_HEIGHT       (44.0)
#define TAB_BAR_HEIGHT              (50.0)
#define STATUS_BAR_HEIGHT           (20.0)
#define TEXT_VIEW_MARGE_HEIGHT      (20.0)
// The height of the screen user could use. (Whole screen height minus navigation bar and tab bar)
#define USER_WINDOW_HEIGHT          (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT)

#define APPDELEGATE ((AppDelegate*)([UIApplication sharedApplication].delegate))

#define APPDELEGATE_ROOTVIEW_CONTROLLER ((AppDelegate*)([UIApplication sharedApplication].delegate)).rootViewController

#define SYSTEM_VERSION_LESS_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

enum
{
    FRIEND_RELATIONSHIP_NONE = 0,
    FRIEND_RELATIONSHIP_MY_FOLLOW,
    FRIEND_RELATIONSHIP_MY_FANS,
    FRIEND_RELATIONSHIP_INTER_FOLLOW,
    FRIEND_RELATIONSHIP_BALCK_LIST,
} FRIEND_RELATIONSHIP_TYPE;

#define DEVELOPER_ENABLE NO

#define K_NOTIFICATION_SHOWWAITOVERLAY @"K_NOTIFICATION_SHOWWAITOVERLAY"
#define K_NOTIFICATION_HIDEWAITOVERLAY @"K_NOTIFICATION_HIDEWAITOVERLAY"
#define K_NOTIFICATION_LOGIN_SUCCESS @"K_NOTIFICATION_LOGIN_SUCCESS"
#define K_NOTIFICATION_SHOULD_LOGIN @"K_NOTIFICATION_SHOULD_LOGIN"

#define USERDEFAULT_LOCAL_ACCOUNT_INFO @"USERDEFAULT_LOCAL_ACCOUNT_INFO"
#define USERDEFAULT_ACCOUNT_USERNAME @"USERDEFAULT_ACCOUNT_USERNAME"
#define USERDEFAULT_ACCOUNT_PHONE_NUMBER @"USERDEFAULT_ACCOUNT_PHONE_NUMBER"
#define USERDEFAULT_ACCOUNT_EMAIL @"USERDEFAULT_ACCOUNT_EMAIL"
#define USERDEFAULT_ACCOUNT_USER_TYPE @"USERDEFAULT_ACCOUNT_USER_TYPE"
#define USERDEFAULT_ACCOUNT_GENDER @"USERDEFAULT_ACCOUNT_GENDER"
#define USERDEFAULT_ACCOUNT_CITY @"USERDEFAULT_ACCOUNT_CITY"
#define USERDEFAULT_ACCOUNT_ADDRESS @"USERDEFAULT_ACCOUNT_ADDRESS"
#define USERDEFAULT_ACCOUNT_ID @"USERDEFAULT_ACCOUNT_ID"
#define USERDEFAULT_ACCOUNT_IS_VERIFY @"USERDEFAULT_ACCOUNT_IS_VERIFY"
#define USERDEFAULT_ACCOUNT_LEVEL @"USERDEFAULT_ACCOUNT_LEVEL"
#define USERDEFAULT_ACCOUNT_POINT @"USERDEFAULT_ACCOUNT_POINT"
#define USERDEFAULT_ACCOUNT_INTRO @"USERDEFAULT_ACCOUNT_INTRO"
#define USERDEFAULT_ACCOUNT_PROV @"USERDEFAULT_ACCOUNT_PROV"
#define USERDEFAULT_ACCOUNT_CREATE_TIME @"USERDEFAULT_ACCOUNT_CREATE_TIME"
#define USERDEFAULT_ACCOUNT_FORWARD_COUNT @"USERDEFAULT_ACCOUNT_FORWARD_COUNT"
#define USERDEFAULT_ACCOUNT_FOLLOW_COUNT @"USERDEFAULT_ACCOUNT_FOLLOW_COUNT"
#define USERDEFAULT_ACCOUNT_BLACK_LIST_COUNT @"USERDEFAULT_ACCOUNT_BLACK_LIST_COUNT"
#define USERDEFAULT_ACCOUNT_WEIBO_COUNT @"USERDEFAULT_ACCOUNT_WEIBO_COUNT"
#define USERDEFAULT_ACCOUNT_BUYED_COUNT @"USERDEFAULT_ACCOUNT_BUYED_COUNT"
#define USERDEFAULT_ACCOUNT_COMMENT_COUNT @"USERDEFAULT_ACCOUNT_COMMENT_COUNT"
#define USERDEFAULT_ACCOUNT_FANS_COUNT @"USERDEFAULT_ACCOUNT_FANS_COUNT"
#define USERDEFAULT_ACCOUNT_FAVORITE_COUNT @"USERDEFAULT_ACCOUNT_FAVORITE_COUNT"
#define USERDEFAULT_ACCOUNT_PRIVATE_MSG_COUNT @"USERDEFAULT_ACCOUNT_PRIVATE_MSG_COUNT"
#define USERDEFAULT_ACCOUNT_TOPIC_COUNT @"USERDEFAULT_ACCOUNT_TOPIC_COUNT"

#define USERDEFAULT_CATEGORY @"USERDEFAULT_CATEGORY"



#define KEY_ACCOUNT_USER_NAME           @"UserName"
#define KEY_ACCOUNT_LEVEL               @"Levels"
#define KEY_ACCOUNT_ID                  @"id"
#define KEY_ACCOUNT_USER_ID             @"UserId"
#define KEY_ACCOUNT_POINT               @"Points"
#define KEY_ACCOUNT_CITY                @"City"
#define KEY_ACCOUNT_PHONE               @"Tel"
#define KEY_ACCOUNT_Address             @"Address"
#define KEY_ACCOUNT_GENDER              @"Sex"
#define KEY_ACCOUNT_INTRO               @"Intro"
#define KEY_ACCOUNT_BLOG_COUNT          @"BlogNum"
#define KEY_ACCOUNT_FAVORITE_COUNT      @"FavNum"
#define KEY_ACCOUNT_FANS_COUNT          @"FansNum"
#define KEY_ACCOUNT_FOLLOW_COUNT        @"AttentionNum"
#define KEY_ACCOUNT_RELATIONSHIP        @"relationship"

#endif
