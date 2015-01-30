//
//  newContactViewController.h
//  goMeet
//
//  Created by Simin on 1/29/15.
//  Copyright (c) 2015 Simin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface newContactViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

- (IBAction)showPicker:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *firstName;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;

@end
