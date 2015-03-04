//
//  NewsFeed.m
//  chatTest
//
//  Created by Simin Liu on 3/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeed.h"
@interface NewsFeed()

@property(strong,nonatomic)NSString* userID;
@property(strong,nonatomic)NSString* contentText;
@property(strong,nonatomic)NSData* contentImage;
@property(strong,nonatomic)NSMutableArray* comments;

@end

@implementation NewsFeed

-(void)SampleInit:(NSData*) testImage{
    
    _userID = @"Simin Liu";
    _contentText=@"This is a Test Content String Test";
    _contentImage = testImage;
    _comments = [[NSMutableArray alloc]init];
    [_comments  addObject:@"this is a good test commet"];
    [_comments  addObject:@"this is a bad test commet"];
}

#pragma mark -getter&setter
-(NSString*)getUserID:(NewsFeed*)myNewsFeed{
    return _userID;
}
-(void)setUserID:(NewsFeed*)myNewsFeed :(NSString*) myUserID{
    _userID = myUserID;
}

-(NSString*)getContentText:(NewsFeed*)myNewsFeed{
    return _contentText;
    
}
-(void)setContentText:(NewsFeed*)myNewsFeed :(NSString*) myContentText{
    _contentText = myContentText;
}

-(NSData*)getContentImage:(NewsFeed*)myNewsFeed{
    return _contentImage;
}
-(void)setContentImage:(NewsFeed*)myNewsFeed :(NSData*) myContentImage{
    _contentImage = myContentImage;
}

-(NSMutableArray*)getComment:(NewsFeed*)myNewsFeed{
    return _comments;
}
-(void)addComment:(NewsFeed*)myNewsFeed :(NSString*) newComment{
    if (_comments==nil) {
        _comments = [[NSMutableArray alloc] init];
    }
    [_comments addObject:newComment];
}


@end