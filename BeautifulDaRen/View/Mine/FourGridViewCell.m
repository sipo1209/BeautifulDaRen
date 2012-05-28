//
//  FourGridViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FourGridViewCell.h"

@implementation FourGridViewCell
@synthesize firstLabel;
@synthesize secondLabel;
@synthesize thirdLabel;
@synthesize fourthLabel;
@synthesize fifthLabel;
@synthesize sixthLabel;

@synthesize leftTopButton;
@synthesize leftButtomButton;
@synthesize rightTopButton;
@synthesize rightButtomButton;
@synthesize thirdLeftButton;
@synthesize thirdRightButton;

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonPressed:(id)sender
{
    NSAssert([sender isKindOfClass:[UIButton class]], @"sender is not a ");
    [self.delegate didButtonPressed:sender inView:self];
}

@end
