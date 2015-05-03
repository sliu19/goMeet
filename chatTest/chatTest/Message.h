//
//  Message.h
//  chatTest
//
//  Created by Simin Liu on 5/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#ifndef chatTest_Message_h
#define chatTest_Message_h

@interface Message: NSObject

@property(strong,nonatomic)NSString* userID;
@property(strong,nonatomic)NSString* bodyText;
-(Message*)init:(NSString*)body name:(NSString*)userName;
-(BOOL)isSelf;

@end

#endif
