//
//  ErrorHandler.m
//  Party Skiper
//
//  Created by AJ Pereira on 8/9/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+ (void) parseError:(NSDictionary *)error
{
    //Create string to store important part of error info
    NSString *fullErrMessage = error[@"NSLocalizedRecoverySuggestion"];
    
    //Check each error, output a specific message from server for each
    if([fullErrMessage rangeOfString:@"IncorrectContentTypeError"].location != NSNotFound)
    {
        //This block of code does not work for some unknown reason, but it's far more efficient
#if 0
        //Create substring to find  "message" : "  in error string
        NSRange range = [fullErrMessage rangeOfString:@"\"message\" : \""];
        NSString *errMessage = [fullErrMessage substringFromIndex:NSMaxRange(range)];

        //Output the server's error message
        NSLog(@"%@", errMessage);
#endif
        
        //Copy the server's error message to display to user
        NSLog(@"Request not in application/json format!");
    }
    else if([fullErrMessage rangeOfString:@"NoJSONDataError"].location != NSNotFound)
    {
        NSLog(@"No valid JSON data provided!");
    }
    else if([fullErrMessage rangeOfString:@"MissingInformationError"].location != NSNotFound)
    {
        NSLog(@"Missing required data!");
    }
    else if([fullErrMessage rangeOfString:@"NotFoundInDatabaseError"].location != NSNotFound)
    {
        NSLog(@"Resource not found in database!");
    }
    else if([fullErrMessage rangeOfString:@"BadCredentialsError"].location != NSNotFound)
    {
        NSLog(@"User credentials incorrect/missing!");
    }
    else if([fullErrMessage rangeOfString:@"UserNotInPartyError"].location != NSNotFound)
    {
        NSLog(@"User is not in the specified party!");
    }
    else if([fullErrMessage rangeOfString:@"DatabaseIntegrityError"].location != NSNotFound)
    {
        NSLog(@"The database failed to insert the data!");
    }
    else if([fullErrMessage rangeOfString:@"InvalidAttributeError"].location != NSNotFound)
    {
        NSLog(@"Illegal value entered!");
    }
    else if([fullErrMessage rangeOfString:@"OutOfSyncError"].location != NSNotFound)
    {
        NSLog(@"Your local party data is not up-to-date!");
    }
    else
    {
        NSLog(@"Unknown error - Try again!");
    }
}

@end
