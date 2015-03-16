//
//  AddFriend.m
//  chatTest
//
//  Created by Simin Liu on 3/16/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "AddFriend.h"

@interface AddFriend ()
@property (weak, nonatomic) IBOutlet UITextField *addFriendTextField;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (nonatomic, assign) id currentResponder;

@end

@implementation AddFriend

- (void)viewDidLoad {
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
     NSLog(@"AddFriendPage");
    _addFriendTextField.delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;
    //[self setUserInteractionEnabled:YES];
    //[iv addGestureRecognizer:singleTap];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendRequest:(id)sender {
    NSString* testUserId = @"2174180160";
    NSString* response = [NSString stringWithFormat:@"addfriend:%@#%@",testUserId,_addFriendTextField.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
    Friend* people = nil;
    people = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:[(AppDelegate*) [[UIApplication sharedApplication]delegate] managedObjectContext]];
    //people.userName =[key obje]
    //people.unique = unique;
    [people setValue: _addFriendTextField.text forKey :@"userName"];
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"testImageApple.jpeg"],0.0);
    [people setValue: imageData forKey :@"userPic"];
    _addFriendTextField.text =@"";
    
    
    
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    typedef enum {
        NSStreamEventNone = 0,
        NSStreamEventOpenCompleted = 1 << 0,
        NSStreamEventHasBytesAvailable = 1 << 1,
        NSStreamEventHasSpaceAvailable = 1 << 2,
        NSStreamEventErrorOccurred = 1 << 3,
        NSStreamEventEndEncountered = 1 << 4
    }NSStringEvent;
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        NSLog(@"This return string from server %@",output);
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                    // NSLog(@"trigger segue");
                                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"LogInNotification" object:self];
                                    //[self performSegueWithIdentifier:@"login" sender:nil];
                                    
                                    break;
                                    
                                default:
                                    NSLog(@"output int val %d", output.intValue);
                                    break;
                            }
                            NSLog(@"server said: %@", output);
                            
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}
- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
