//
//  Friend.m
//  chatTest
//
//  Created by Simin Liu on 3/21/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "Friend.h"


@implementation Friend

@dynamic userName;
@dynamic userPic;
@dynamic userImageUUID;


+(Friend*)photoWithInfo:(NSDictionary*) FriendDictionary
 inManagedObjectContext:(NSManagedObjectContext* ) context{
    Friend* people = nil;
    
    NSString *unique = FriendDictionary[@"testImage"];
    NSFetchRequest* request =[NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || error || [matches count]>1){
        //handle error
        NSLog(@"Error message in Friend.m");
    }else if([matches count]){
        people = [matches firstObject];
    }else{
        people = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
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
