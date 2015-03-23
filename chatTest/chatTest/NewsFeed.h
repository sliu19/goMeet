//
//  NewsFeed.h
//  chatTest
//
//  Created by Simin Liu on 3/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#ifndef chatTest_NewsFeed_h
#define chatTest_NewsFeed_h
@interface NewsFeed: NSObject

@property(strong,nonatomic)NSString* userID;
@property(strong,nonatomic)NSString* contentText;
@property(strong,nonatomic)NSData* contentImage;
@property(strong,nonatomic)NSString* newsFeedUUID;
@property(strong,nonatomic)NSMutableArray* comments;


-(void)SampleInit:(NSData*) testImage;

-(NSString*)getUserID:(NewsFeed*)myNewsFeed;
-(void)setUserID:(NewsFeed*)myNewsFeed :(NSString*) myUserName;

-(NSString*)getContentText:(NewsFeed*)myNewsFeed;
-(void)setContentText:(NewsFeed*)myNewsFeed :(NSString*) myContentText;

-(NSData*)getContentImage:(NewsFeed*)myNewsFeed;
-(void)setContentImage:(NewsFeed*)myNewsFeed :(NSData*) myContentImage;

-(NSMutableArray*)getComment:(NewsFeed*)myNewsFeed;
-(void)addComment:(NewsFeed*)myNewsFeed :(NSString*) newComment;


@end

#endif
