//
//  UKBooleanTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

#import "UKBooleanTemplateField.h"
#import "UKTemplateDocument.h"


@implementation UKBooleanTemplateField

+(void)   load
{
    [self registerForDefaultName];
}


-(id)       initWithSettingsDictionary: (NSDictionary*)dict
{
    self = [super initWithSettingsDictionary: dict];
    if( self )
    {
        NSNumber*   b = [dict objectForKey: @"defaultValue"];
        if( b )
            booleanValue = [b boolValue];
    }
    
    return self;
}


-(void)     readFromData: (NSData*)data offset: (int*)offs
{
    if( ([data length] -(*offs)) >= sizeof(BOOL) )
        [data getBytes: &booleanValue range: NSMakeRange(*offs,sizeof(BOOL))];

    *offs += sizeof(BOOL);
}


-(void)     writeToData: (NSMutableData*)data offset: (int*)offs
{
    [data appendBytes: &booleanValue length: sizeof(BOOL)];
    *offs += sizeof(BOOL);
}


-(id)           plistRepresentation
{
    return [NSNumber numberWithBool: booleanValue];
}


-(id)				fieldValue
{
	return (booleanValue? @"YES" : @"NO");	
}


-(void)	setFieldValue: (id)val forKey: (NSString*)key
{
	if( [key isEqualToString: @"value"] )
	{
		booleanValue = [[val uppercaseString] isEqualToString: @"YES"];
		if( !booleanValue )
			booleanValue = [[val uppercaseString] isEqualToString: @"TRUE"];
		[self dataChanged: self];
	}
	else
		[self reportChangeOfUnknownKey: key];
}


@end
