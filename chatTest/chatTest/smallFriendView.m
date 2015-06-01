//
//  inviteFriendView.m
//  赢家
//
//  Created by Simin Liu on 5/31/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "smallFriendView.h"
#define LENGTH 30.0
#define OFFSET 5.0
@implementation smallFriendView
@synthesize inviteList;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    CGPoint startPoint;
    startPoint.x = OFFSET;
    startPoint.y=OFFSET;
    for (NSMutableData*friends in inviteList){
        UIImage* faceImage = [UIImage imageWithData:friends];
        CGRect frame = CGRectMake(startPoint.x, startPoint.y, LENGTH, LENGTH);
        [self addOneCircle:frame image:faceImage];
        if (startPoint.x +2*LENGTH > self.frame.size.width) {
            startPoint.y+=(LENGTH+2*OFFSET);
            startPoint.x = OFFSET;
            self.contentSize = CGSizeMake(self.frame.size.width, startPoint.y+ LENGTH+2*OFFSET);
        }else{
            startPoint.x+=(LENGTH+OFFSET);
        }
    }
}

-(void)awakeFromNib
{
    [self setup];
}

-(void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    self.contentSize = self.frame.size;
    
}

-(void)addOneCircle:(CGRect)frame image:(UIImage*)faceImage{
    UIImageView* faceImageView = [[UIImageView alloc]initWithFrame:frame];
    faceImageView.image = faceImage;
    faceImageView.layer.cornerRadius = faceImageView.frame.size.width / 2;
    faceImageView.clipsToBounds = YES;
    [self addSubview: faceImageView];
}

@end
