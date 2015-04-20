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


@end

@implementation NewsFeed

@synthesize userID;
@synthesize contentText;
@synthesize contentImage;
@synthesize newsFeedUUID;
@synthesize comments;
@synthesize date;

-(void)SampleInit:(NSData*) testImage{
    
    userID = @"Simin Liu";
    contentText=@"This is a Test Content String Test";
    contentImage = testImage;
    comments = [[NSMutableArray alloc]init];
    [comments  addObject:@"this is a good test commet"];
    [comments  addObject:@"this is a bad test commet"];
}


-(NewsFeed*)initWithOwnerNewsFeed:(OwnerNewsFeed*) ownerNewsFeed{
    self = [super init];
    if(!self) return nil;
    userID = ownerNewsFeed.userID;
    contentText = ownerNewsFeed.bodyTextField;
    contentImage = ownerNewsFeed.image;
    newsFeedUUID = ownerNewsFeed.uuid;
    comments = [[NSMutableArray alloc]initWithArray:@[@"test comment 1 ",@"test commment 2"]];
    date = ownerNewsFeed.date;
    return self;
}


-(NewsFeed*)initWithNewsFeedList:(NewsFeedList*) newsFeedList{
    self = [super init];
    if(!self) return nil;
    userID = newsFeedList.userID;
    contentText = newsFeedList.bodyTextField;
    contentImage = newsFeedList.image;
    newsFeedUUID = newsFeedList.uuid;
    comments = [[NSMutableArray alloc]initWithArray:@[@"test comment 1 ",@"test commment 2"]];
    date = newsFeedList.date;
    return self;
}


#pragma mark -getter&setter
-(NSString*)getUserID:(NewsFeed*)myNewsFeed{
    return userID;
}
-(void)setUserID:(NewsFeed*)myNewsFeed :(NSString*) myUserID{
    userID = myUserID;
}

-(NSString*)getContentText:(NewsFeed*)myNewsFeed{
    return contentText;
    
}
-(void)setContentText:(NewsFeed*)myNewsFeed :(NSString*) myContentText{
    contentText = myContentText;
}

-(NSData*)getContentImage:(NewsFeed*)myNewsFeed{
    return contentImage;
}
-(void)setContentImage:(NewsFeed*)myNewsFeed :(NSData*) myContentImage{
    contentImage = myContentImage;
}

-(NSMutableArray*)getComment:(NewsFeed*)myNewsFeed{
    return comments;
}
-(void)addComment:(NewsFeed*)myNewsFeed :(NSString*) newComment{
    if (comments==nil) {
        comments = [[NSMutableArray alloc] init];
    }
    [comments addObject:newComment];
}


@end