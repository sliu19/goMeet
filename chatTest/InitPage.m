//
//  InitPage.m
//  chatTest
//
//  Copyright (c) 2015年 LPP. All rights reserved.
//

#import "InitPage.h"

@interface InitPage ()

@property (weak, nonatomic) IBOutlet UIButton *joinView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passCode;
@property (nonatomic, assign) id currentResponder;
@property (weak, nonatomic) IBOutlet UIButton *logIn;



@end

@implementation InitPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [Communication initNetworkCommunication];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    NSLog(@"InitPage");
    _phoneNum.delegate = self;
    _passCode.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLogInNotification:)
                                                 name:@"LogInNotification"
                                               object:nil];

    
    // Do any additional setup after loading the view from its nib.
}

- (void) receiveLogInNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"LogInNotification"])
        NSLog (@"Successfully received the login notification!");
        [self performSegueWithIdentifier:@"login" sender:nil];
}




- (IBAction)logIn:(id)sender {
    
    NSString *response  = [NSString stringWithFormat:@"log:%@;%@" , _phoneNum.text,_passCode.text];
    //NSString *imageHead = @"img:";
    //NSMutableData *imageHeadData =[[NSMutableData alloc] initWithData:[imageHead dataUsingEncoding:NSASCIIStringEncoding]];
    //UIImage *testImage = [UIImage imageNamed:@"testImage.jpeg"];
    //NSData * testImageData = UIImageJPEGRepresentation(testImage,testImage.scale);
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    //[imageHeadData appendData:testImageData];
    [Communication send:data];
    //[outputStream write:[imageHeadData bytes] maxLength:[imageHeadData length]];
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
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                    NSLog(@"trigger segue");
                                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"LogInNotification" object:self];
                                    [self performSegueWithIdentifier:@"login" sender:nil];
                                    
                                    break;
                                    
                                default:
                                    NSLog(@"output int val %@", output.intValue);
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



@end
