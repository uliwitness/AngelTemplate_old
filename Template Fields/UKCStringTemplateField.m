//
//  UKCStringTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

#import "UKCStringTemplateField.h"
#import "UKTextUtilities.h"
#import "UKTemplateDocument.h"


@implementation UKCStringTemplateField

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
    NSMutableData*    str = [NSMutableData data];
    char              theCh;
    
    while( ([data length] -(*offs)) >= 1 )
    {
        // Read length byte:
        [data getBytes: &theCh range: NSMakeRange(*offs,1)];
        ++(*offs);
        
        if( theCh == 0 )
            break;
        
        [str appendBytes: &theCh length: 1];
    }
        
    // Convert read text to NSString and assign it to our field:
   stringValue = [[NSString alloc] initWithData: str encoding: StringEncodingFromName([settings objectForKey: @"encoding"])];
}


-(void)     writeToData: (NSMutableData*)data offset: (int*)offs
{
	unsigned char   terminatorChar = 0;
	int				len = 0;
	
	if( stringValue != nil )
	{
		NSData*         strdata = [stringValue dataUsingEncoding: StringEncodingFromName([settings objectForKey: @"encoding"])
										allowLossyConversion: YES];
		[data appendData: strdata];
		len = [data length];
	}
    [data appendBytes: &terminatorChar length: 1]; // Terminate string.
    
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
