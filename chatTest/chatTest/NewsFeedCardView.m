//
//  NewsFeedCardView.m
//  chatTest
//
//  Created by Simin Liu on 4/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "NewsFeedCardView.h"
#import "Communication.h"
#import "MainTabBarViewController.h"
#import "NewsFeedViewController.h"

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
#define OFFSET_FROM_FRAME  OFFSET
#define OFFSET_FROM_TOP 20
#define OFFSET_BETWEEN_CARD 30


int OFFSET = 0;
@implementation NewsFeedCardView
@synthesize news;
@synthesize currentResponder;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//scale view for all sizes

-(NewsFeedCardView*)initWith:(CGRect)frame :(PublicEvent*)newsFeed{
    self = [super initWithFrame:frame];
    if(!self) return nil;
    news = newsFeed;
    if(frame.size.width < [[UIScreen mainScreen] bounds].size.width/2){
        OFFSET = 2;
    }
    else{
        OFFSET = 10;
    }
    
    return self;
}

-(CGFloat)cornerScaleFactor {
return self.bounds.size.height/CORNER_FONT_STANDARD_HEIGHT;
}

# pragma mark -Drawing
-(CGFloat)cornerRadius{
    return CORNER_RADIUS*[self cornerScaleFactor];
}

-(CGFloat)cornerOffset{
    return [self cornerRadius]/3.0;
}


- (void)drawRect:(CGRect)rect {
    CGPoint innerPoint;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *contentFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    contentFont = [contentFont fontWithSize:contentFont.pointSize *[self cornerScaleFactor]];
    
    //Draw context here!!!!!Use test content as sample
    
    // NSAttributedString *contentText = [[NSAttributedString alloc] initWithString:_myContent attributes:@{ NSFontAttributeName :contentFont, NSParagraphStyleAttributeName:paragraphStyle}];
    // CGRect textBounds;
    // textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    // textBounds.size = [contentText size];
    // [contentText drawInRect:textBounds];
    //UIImage *testImage = [UIImage imageNamed:@"testImage.jpeg"];
    //test = UIImageJPEGRepresentation(testImage,testImage.scale);
    
    //UIImage *contentImage = [[UIImage alloc] initWithData:[news getContentImage:news]];
    //contentImage = [Communication imageWithImage:contentImage scaledToSize:CGSizeMake(self.bounds.size.width-2*OFFSET_FROM_FRAME,self.bounds.size.width-2*OFFSET_FROM_FRAME)];
    //UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(OFFSET_FROM_FRAME, OFFSET_FROM_FRAME, contentImage.size.width,contentImage.size.height )];
    //iv.contentMode = UIViewContentModeScaleAspectFit;
    //iv.image = contentImage;
    //[iv setImage:contentImage];
    //innerPoint.x = OFFSET_FROM_FRAME;
   // innerPoint.y = OFFSET_FROM_FRAME +contentImage.size.height;
   // UILabel* contentString = [[UILabel alloc]initWithFrame:CGRectMake(innerPoint.x, innerPoint.y, self.bounds.size.width-2*OFFSET_FROM_FRAME,20)];
   // contentString.text = [news getContentText:news];
    //contentString.font=[UIFont boldSystemFontOfSize:15.0];
    //contentString.textColor=[UIColor blackColor];
    //contentString.backgroundColor=[UIColor clearColor];
    //if((self.bounds.size.height - innerPoint.y)> OFFSET_FROM_FRAME ){[self addSubview:contentString];}
   // [self addSubview:iv];
}

#pragma mark -Initialization

-(void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib
{
    [self setup];
}

@end
