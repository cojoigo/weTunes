//
//  ErrorHandler.m
//  weTunes
//
//  Created by AJ Pereira on 8/9/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+ (NSString*) parseError:(NSDictionary *)error
{
    //Create string to store important part of error info
    NSString *fullErrMessage = error[@"NSLocalizedRecoverySuggestion"];
    
    //Check each error, output a specific message from server for each
    if([fullErrMessage rangeOfString:@"IncorrectContentTypeError"].location != NSNotFound)
    {
        //Copy the server's error message to display to user
        return(@"Request not in application/json format!");
    }
    else if([fullErrMessage rangeOfString:@"NoJSONDataError"].location != NSNotFound)
    {
        return(@"No valid JSON data provided!");
    }
    else if([fullErrMessage rangeOfString:@"MissingInformationError"].location != NSNotFound)
    {
        return(@"Missing required data!");
    }
    else if([fullErrMessage rangeOfString:@"NotFoundInDatabaseError"].location != NSNotFound)
    {
        return(@"Resource not found in database!");
    }
    else if([fullErrMessage rangeOfString:@"BadCredentialsError"].location != NSNotFound)
    {
        return(@"User credentials incorrect/missing!");
    }
    else if([fullErrMessage rangeOfString:@"UserNotInPartyError"].location != NSNotFound)
    {
        return(@"User is not in the specified party!");
    }
    else if([fullErrMessage rangeOfString:@"DatabaseIntegrityError"].location != NSNotFound)
    {
        return(@"The database failed to insert the data!");
    }
    else if([fullErrMessage rangeOfString:@"InvalidAttributeError"].location != NSNotFound)
    {
        return(@"Illegal value entered!");
    }
    else if([fullErrMessage rangeOfString:@"OutOfSyncError"].location != NSNotFound)
    {
        return(@"Your local party data is not up-to-date!");
    }
    else
    {
        return(@"Unknown error - Try again!");
    }
}

@end
