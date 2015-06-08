//
//  Notification.h
//  chatTest
//  还在等服务器传回数据的格式
//  Created by Simin Liu on 5/24/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#ifndef chatTest_Notification_h
#define chatTest_Notification_h
#import "EventList.h"
@interface Notification: NSObject
@property(strong,nonatomic) EventList* event;

@end

#endif
