//
//  Lib.m
//  chatTest
//
//  Created by Simin Liu on 3/1/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lib.h"

@implementation Lib

/*
//getting bytes from an image

 NSDate *imageData = UIImageJPEGRepresentation(image,imageQuality);
 
//getting image from bytes
 UIImage *image = [UIImage imageWithDate:imageData];
 
 
*/



/*
 //In sender class
 - (void) someMethod
 {
 
 // All instances of TestClass will be notified
 [[NSNotificationCenter defaultCenter]
 postNotificationName:@"TestNotification"
 object:self];
 
 }
 
 //In receiver class
 - (void) dealloc
 {
 // If you don't remove yourself as an observer, the Notification Center
 // will continue to try and send notification objects to the deallocated
 // object.
 [[NSNotificationCenter defaultCenter] removeObserver:self];
 [super dealloc];
 }
 
 - (id) init
 {
 self = [super init];
 if (!self) return nil;
 
 // Add this instance of TestClass as an observer of the TestNotification.
 // We tell the notification center to inform us of "TestNotification"
 // notifications using the receiveTestNotification: selector. By
 // specifying object:nil, we tell the notification center that we are not
 // interested in who posted the notification. If you provided an actual
 // object rather than nil, the notification center will only notify you
 // when the notification was posted by that particular object.
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(receiveTestNotification:)
 name:@"TestNotification"
 object:nil];
 
 return self;
 }
 
 - (void) receiveTestNotification:(NSNotification *) notification
 {
 // [notification name] should always be @"TestNotification"
 // unless you use this method for observation of other notifications
 // as well.
 
 if ([[notification name] isEqualToString:@"TestNotification"])
 NSLog (@"Successfully received the test notification!");
 }

 
 */



//Gesture
/*
// Inside viewDidLoad{
 
 UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
 [singleTap setNumberOfTapsRequired:1];
 [singleTap setNumberOfTouchesRequired:1];
 [self.view addGestureRecognizer:singleTap];
}
 
 //Implement resignOnTap:
 
 - (void)resignOnTap:(id)iSender {
 [self.currentResponder resignFirstResponder];
 }

 
 */


@end
