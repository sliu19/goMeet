//
//  ChatClientViewController.h
//  chatTest
//
//  Created by Luyao Huang on 15/2/4.
//  Copyright (c) 2015年 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinViewController.h"

@interface ChatClientViewController : UIViewController<NSStreamDelegate>


@end

NSInputStream *inputStream;
NSOutputStream *outputStream;