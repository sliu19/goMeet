//
//  ModifyProfileViewController.m
//  chatTest
//
//  Created by Simin Liu on 5/12/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "ModifyProfileViewController.h"
#import "Communication.h"
#import "MainTabBarViewController.h"

@interface ModifyProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *intro;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (nonatomic, assign) id currentResponder;
@end

@implementation ModifyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    _nickName.delegate = self;
    _intro.delegate =self;
    _email.delegate = self;
    _location.delegate = self;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _nickName.text = [prefs objectForKey:@"nickName"];
    _intro.text = [prefs objectForKey:@"intro"];
    _email.text = [prefs objectForKey:@"email"];
    _location.text = [prefs objectForKey:@"location"];
    _userPic.image = [[UIImage alloc]initWithData:[prefs dataForKey:@"userPic"]];
    _userID.text = [prefs objectForKey:@"userID"];
    _gender.text = @"男";
    if ([[prefs stringForKey:@"gender"] isEqualToString:@"F"]){
        _gender.text = @"女";
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    singleTap.numberOfTapsRequired = 1;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePic:(id)sender {
}
- (IBAction)confirm:(id)sender {
    //profile:{"phone":6505758649,"nick":"mynickname","intro":"password","location":"mylocation","pass":"mypassword","email":"myemail"} only phoneNumberrequired
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = @{@"phone":[prefs objectForKey:@"userID"],@"intro":_intro.text,@"nick":_nickName.text,@"location":_location.text,@"email":_email.text};
    NSString *response  = [NSString stringWithFormat:@"profile:%@",[Communication parseIntoJson:dict]];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
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
                        
                        if (nil != output) {
                            switch (output.intValue) {
                                case 1:
                                {
                                    NSLog(@"successful modifile");
                                    //6505758649,"nick":"mynickname","intro":"password","location":"mylocation","pass":"mypassword","email":"myemail"} only phoneNumberrequired
            
                                    // Create instances of NSData
                                    UIImage *contactImage = [UIImage imageNamed:@"testImage.jpeg"];
                                    NSData *imageData = UIImageJPEGRepresentation(contactImage, 100);
                                    
                                    
                                    // Store the data
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    
                                    [defaults setObject:[_nickName text] forKey:@"nickName"];
                                    [defaults setObject:[_intro text] forKey:@"intro"];
                                    [defaults setObject:[_location text] forKey:@"location"];
                                    [defaults setObject:[_email text]forKey:@"email"];
                                    [defaults setObject:imageData forKey:@"userPic"];
                                    [defaults synchronize];
                                    
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    MainTabBarViewController *viewController = (MainTabBarViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoMeet"];
                                    [viewController setSelectedIndex:0];
                                    [self presentViewController:viewController animated:YES completion:nil];                                    break;
                                }
                                    
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
