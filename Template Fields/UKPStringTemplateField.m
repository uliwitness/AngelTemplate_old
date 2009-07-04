//
//  UKPStringTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

#import "UKPStringTemplateField.h"
#import "UKTextUtilities.h"
#import "UKTemplateDocument.h"


@implementation UKPStringTemplateField

+(void)   load
{
    [self registerForDefaultName];
}


-(id)       initWithSettingsDictionary: (NSDictionary*)dict
{
    self = [super initWithSettingsDictionary: dict];
    if( self )
    {
        stringValue = [[dict objectForKey: @"defaultValue"] retain];
    }
    
    return self;
}


-(void)	dealloc
{
	[stringValue release];
	stringValue = nil;
	
	[super dealloc];
}


-(void)     readFromData: (NSData*)data offset: (int*)offs
{
    char        str[256] = { 0 };
    int         lengthWithLengthByte = 0;
    
    if( ([data length] -(*offs)) >= 1 ) // Get length byte, if enough data:
    {
        // Read length byte:
        [data getBytes: str range: NSMakeRange(*offs,1)];
        lengthWithLengthByte = str[0] +1;
        
        // Check whether enough data for this string exists, if not, read as much as is left:
        if( ([data length] -(*offs)) < lengthWithLengthByte )
            lengthWithLengthByte = [data length] -(*offs);
        if( lengthWithLengthByte > 0 )
        {
            [data getBytes: str range: NSMakeRange(*offs,lengthWithLengthByte)];
            str[0] = lengthWithLengthByte -1;
        }
        else
            str[0] = 0;
        
        // Convert read text to NSString and assign it to our field:
       stringValue = [[NSString alloc] initWithBytes: str +1 length: str[0] encoding: StringEncodingFromName([settings objectForKey: @"encoding"])];
    }
    else
        stringValue = [@"" retain];
    *offs += lengthWithLengthByte;
}


-(void)     writeToData: (NSMutableData*)data offset: (int*)offs
{
    NSData*         strdata = [stringValue dataUsingEncoding: StringEncodingFromName([settings objectForKey: @"encoding"])
                                    allowLossyConversion: YES];
    unsigned char   len = [strdata length];
    [data appendBytes: &len length: 1];
    [data appendData: strdata];
    
    *offs += len +1;
}


-(id)           plistRepresentation
{
    return stringValue;
}


-(id)		fieldValue
{
	return stringValue;
}


-(void)	setFieldValue: (id)val forKey: (NSString*)key
{
	if( [key isEqualToString: @"value"] )
	{
		stringValue = [val retain];
		[self dataChanged: self];
	}
	else
		[self reportChangeOfUnknownKey: key];
}


@end
