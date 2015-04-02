//
//  NewsFeedView.m
//  chatTest
//
//  Created by Simin Liu on 3/1/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "NewsFeedView.h"

@interface NewsFeedView()

@property(strong,nonatomic) NSString* myContent;
@property(strong,nonatomic) NSData* imageData;

@end



@implementation NewsFeedView

//Display everytime set new user

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0


//scale view for all sizes
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
    
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}

-(void)drawContent:(NSString*)content{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *contentFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    contentFont = [contentFont fontWithSize:contentFont.pointSize *[self cornerScaleFactor]];
    
    //Draw context here!!!!!Use test content as sample
    
    NSAttributedString *contentText = [[NSAttributedString alloc] initWithString:_myContent attributes:@{ NSFontAttributeName :contentFont, NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [contentText size];
    [contentText drawInRect:textBounds];
    //UIImage *testImage = [UIImage imageNamed:@"testImage.jpeg"];
    //test = UIImageJPEGRepresentation(testImage,testImage.scale);
    
    
    
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
