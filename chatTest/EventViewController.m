//
//  EventViewController.m
//  chatTest
//
//  Created by Simin Liu on 2/18/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()
@property (strong, nonatomic) IBOutlet UIView *Pull;
@property (weak, nonatomic) IBOutlet UIButton *Send;
@property (weak, nonatomic) IBOutlet UIButton *friendRequest;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Communication initNetworkCommunication];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    NSLog(@"ViewEventPage");

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SendNewsFeed:(id)sender {
    //[UIImage imageNamed:@"testImage"].
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"testImage.jpeg"],0.0);
    NSString* testId = @"2174180160";
    NSString* testBody = @"This is a test content";
    //NSLog(@"This is test image before encode %@",imageData);
    //NSString* testImage = [UIImageJPEGRepresentation([UIImage imageNamed:@"testImage.jpeg"],0.0) base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
  // NSString *imageOne = [ encodeBase64WithData:imageData];
   // NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    //NSString* testImage = [Communication base64forData:imageData];
    //NSLog(@"This is test image %@",testImage);
    NSString *response  = [NSString stringWithFormat:@"newstatus:{\"id\":%@,\"body\":\"%@\",\"photo\":\"", testId,testBody];
    //NSString *response  = [NSString stringWithFormat:@"newstatus:{\"id\":%@,\"body\":\"%@\"}",testId,testBody];
    //NSLog(@"This is format string %@",response);
        //NSString *imageHead = @"img:";
    //NSMutableData *imageHeadData =[[NSMutableData alloc] initWithData:[imageHead dataUsingEncoding:NSASCIIStringEncoding]];
    //UIImage *testImage = [UIImage imageNamed:@"testImage.jpeg"];
    //NSData * testImageData = UIImageJPEGRepresentation(testImage,testImage.scale);
    NSMutableData *data = [[NSMutableData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"This is format string %@",data);
    //[imageHeadData appendData:testImageData];
    [data appendData:imageData];
    NSString* secondPart = @"\"}";
    NSMutableData *seconddata = [[NSMutableData alloc] initWithData:[secondPart dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:seconddata];

    [Communication send:data];

    
    
}
- (IBAction)PullNews:(id)sender {
    NSString* testUser = @"2174180160";
    NSLog(@"lengh of testuser %lu", (unsigned long)[testUser length]);
    NSString* response = [NSString stringWithFormat:@"pollnews:%@",testUser];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [Communication send:data];
}
- (IBAction)sendFriendRequest:(id)sender {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    NSLog(@"Inside send FR");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    NSData* result = nil;
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    int statusCode = 0;
    NSURL* requestURL = [NSURL URLWithString:@"http://54.69.204.42:8000/form"];
    NSData* bodyimage =UIImageJPEGRepresentation([UIImage imageNamed:@"testLargeImage.jpeg"],1.0);
    NSString* testImage = [bodyimage base64EncodedStringWithOptions:0];
    //NSLog(@"{\"%@\":\"%@\"}", uuidString,testImage);
    NSMutableData* body  =[[NSString stringWithFormat:@"{\"%@\":\"%@\"}", uuidString,testImage] dataUsingEncoding:NSUTF8StringEncoding];
    //[body appendData:bodyimage];
    //[body appendData:[[NSString stringWithFormat:@"\"}"] dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=this is test boundary"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    NSLog(@"%@", [request allHTTPHeaderFields]);
    
    result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog( @"NSURLConnection result %ld %@ %@", (long)[response statusCode], [request description], [error description] );
    statusCode = [response statusCode];
    if ( (statusCode == 0) || (!result && statusCode == 200) ) {
        statusCode = 500;}
   // [Communication send:data];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
