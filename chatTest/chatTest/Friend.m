//
//  Friend.m
//  chatTest
//
//  Created by Simin Liu on 3/7/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "Friend.h"


@implementation Friend

@dynamic userName;
@dynamic userPic;

+(Friend*)photoWithInfo:(NSDictionary*) FriendDictionary
 inManagedObjectContext:(NSManagedObjectContext* ) context{
    Friend* people = nil;
    
    NSString *unique = FriendDictionary[@"testImage"];
    NSFetchRequest* request =[NSFetchRequest fetchRequestWithEntityName:@"People"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || error || [matches count]>1){
        //handle error
        NSLog(@"Error message in people.m");
    }else if([matches count]){
        people = [matches firstObject];
    }else{
        people = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:context];
        //people.unique = unique;
        people.userName = [FriendDictionary valueForKeyPath:@"testUserName"];
        people.userPic = [FriendDictionary valueForKeyPath:@"testUserPic"];
        
    }
    return people;
}

+(void)loadPeopleArray:(NSArray*) Friend
intoManageObjectContext:(NSManagedObjectContext* )context{
    
}

@end
