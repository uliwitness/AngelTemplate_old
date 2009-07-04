//
//  UKCommentTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

#import "UKCommentTemplateField.h"


@implementation UKCommentTemplateField

+(void)   load
{
    [self registerForDefaultName];
}


-(id)       initWithSettingsDictionary: (NSDictionary*)dict
{
    self = [super initWithSettingsDictionary: dict];
    if( self )
    {
	
    }
    
    return self;
}


-(void)     readFromData: (NSData*)data offset: (int*)offs
{
    // Do nothing, this is only for template viewing.
}


-(void)     writeToData: (NSMutableData*)data offset: (int*)offs
{
    // Do nothing, this is only for template viewing.
}


-(id)           plistRepresentation
{
    return nil;
}


-(id)				fieldValueForKey: (NSString*)key
{
	if( [key isEqualToString: @"label"] )
		return @"";
	else if( [key isEqualToString: @"value"] )
	{
		NSDictionary*	attrs = [NSDictionary dictionaryWithObject: [NSColor redColor] forKey: NSForegroundColorAttributeName];
		
		return [[[NSAttributedString alloc] initWithString: [settings objectForKey: @"label"] attributes: attrs] autorelease];
	}
	else
		return [super fieldValueForKey: key];
}


-(BOOL)	fieldValueIsEditableForKey: (NSString*)key
{
	return NO;
}


@end
