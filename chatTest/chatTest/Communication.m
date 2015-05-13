//
//  Communication.m
//  chatTest
//
//  Created by Simin Liu on 3/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import "Communication.h"

@implementation Communication

+(void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"54.69.204.42", 80, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

+ (void)send:(NSData *)myData{
    NSLog(@"The length of input %lu",(unsigned long)[myData length]);
    [outputStream write:[myData bytes] maxLength:[myData length]];
}

//Resize Image
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size1
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0


//scale view for all sizes
+(CGFloat)cornerScaleFactor:(UIView*) thisView {
    return thisView.bounds.size.height/CORNER_FONT_STANDARD_HEIGHT;
}

# pragma mark -Drawing
+(CGFloat)cornerRadius:(UIView*) thisView{
    return CORNER_RADIUS*[Communication cornerScaleFactor:thisView];
}

+(CGFloat)cornerOffset:(UIView*) thisView{
    return [Communication cornerRadius:thisView]/3.0;
}

+(UIImage*)compressToSmallSquare:(UIImage*)oldImage{
    CGSize newSize = CGSizeMake(200.0f, 200.0f);
    UIGraphicsBeginImageContext(newSize);
    [oldImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSString*)parseIntoJson:(NSDictionary*)dict{
    
    NSError *error = nil;
    NSData *json;
    
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        // Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        // If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON: %@", jsonString);
            return jsonString;
        }
    }
    return @"ERROR_PARSE_INTO_JSON";
}


+(NSDictionary*)parseFromJson:(NSData*)json{
    NSError *error = nil;
   NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&error];
    return dictionary;
}
//Test HTTP Request


@end
