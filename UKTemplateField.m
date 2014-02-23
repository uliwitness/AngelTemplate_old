//
//  UKTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

#import "UKTemplateField.h"
#import "UKPluginTemplateField.h"
#import "UKTemplateDocument.h"


@implementation UKTemplateField

static NSMutableDictionary*        gTemplateFieldTypeToClass = nil;

+(void) registerTemplateFieldClass: (Class)cl forType: (NSString*)type
{
    if( !gTemplateFieldTypeToClass )
        gTemplateFieldTypeToClass = [[NSMutableDictionary alloc] init];
    [gTemplateFieldTypeToClass setObject: cl forKey: type];
}

+(void) registerForDefaultName
{
    NSAutoreleasePool*  pool = [[NSAutoreleasePool alloc] init];
    NSString*   nm = NSStringFromClass([self class]);
    if( [nm hasPrefix: @"UK"] )
        nm = [nm substringFromIndex: 2];
    NSRange endPart = [nm rangeOfString: @"TemplateField"];
    if( endPart.location != NSNotFound && (endPart.location +endPart.length) == [nm length] )
        nm = [nm substringToIndex: endPart.location];
    [[self class] registerTemplateFieldClass: [self class] forType: nm];
    [pool release];
}


+(id)   fieldWithSettingsDictionary: (NSDictionary*)dict
{
    Class theClass = [gTemplateFieldTypeToClass objectForKey: [dict objectForKey: @"type"]];
    
	if( [theClass instancesRespondToSelector: @selector(initWithTemplateField:)] )	// Plugin class?
	{
		UKPluginTemplateField*				fld = [[[UKPluginTemplateField alloc] initWithSettingsDictionary: dict] autorelease];
		id<UKTemplateFieldPluginProtocol>	plug = [[[theClass alloc] initWithTemplateField: fld] autorelease];
		[fld setPluginController: plug];
		
		return fld;
	}
	else
		return [[[theClass alloc] initWithSettingsDictionary: dict] autorelease];
}


-(id)       initWithSettingsDictionary: (NSDictionary*)dict
{
    self = [super init];
    if( self )
    {
        settings = [dict retain];
    }
    
    return self;
}


-(void) dealloc
{
    [settings release];
    
    [super dealloc];
}


-(void)     readFromData: (NSData*)data offset: (int*)offs
{
    NSLog(@"Error: need to implement %@ readFromData:.",NSStringFromClass([self class]));
}


-(void) loadDefaults
{
    
}


-(void)     writeToData: (NSMutableData*)data offset: (int*)offs
{
    NSLog(@"Error: need to implement %@ writeToData:.",NSStringFromClass([self class]));
}


-(void)         addToArray: (NSMutableArray*)arr
{
    NSString*       key = [settings objectForKey: @"label"];
    id              plr = [self plistRepresentation];
    if( plr )
    {
        if( key )
            [arr addObject: [NSDictionary dictionaryWithObjectsAndKeys: plr, key, nil]];
        else
            [arr addObject: plr];
    }
}


-(id)           plistRepresentation
{
    return [NSString stringWithFormat: @" *** Need to implement %@ plistRepresentation *** ", NSStringFromClass([self class])];
}


-(void) controlTextDidChange: (NSNotification*)obj
{
    [owningDocument updateChangeCount: NSChangeDone];
}


-(void) dataChanged: (id)sender
{
    [owningDocument updateChangeCount: NSChangeDone];
}


-(void) setOwningDocument: (NSDocument*)doc
{
    owningDocument = doc;
}


-(UKTemplateDocument*)  owningDocument
{
    return (UKTemplateDocument*) owningDocument;
}


-(id)				fieldValueForKey: (NSString*)key
{
	if( [key isEqualToString: @"value"] )
		return [self fieldValue];
	else if( [key isEqualToString: @"label"] )
	{
		NSDictionary*	attrs = [NSDictionary dictionaryWithObject: [NSFont boldSystemFontOfSize: [NSFont systemFontSize]] forKey: NSFontAttributeName];
		
		return [[[NSAttributedString alloc] initWithString: [settings objectForKey: @"label"] attributes: attrs] autorelease];
	}
	else
		return [self objectForSettingsKey: key];	// By default, fall back on template's values. You should at least provide a value here.
}


-(id)				fieldValue
{
	return @"??? VALUE MISSING ???";	
}


-(BOOL)				canHaveSubFields
{
	return NO;
}


-(int)				countSubFields
{
	return 0;
}


-(UKTemplateField*)	subFieldAtIndex: (int)index
{
	return nil;
}


// Gives you either a property of this field, or if it's not set also
//	tries to inherit a property from the document:
-(id)	objectForSettingsKey: (NSString*)key
{
	id		obj = [settings objectForKey: key];
	if( !obj )
		obj = [[self owningDocument] objectForSettingsKey: key];
	return obj;
}


-(BOOL)	isBigEndian
{
	return [[[self objectForSettingsKey: @"endianness"] lowercaseString] isEqualToString: @"big"];
}

-(BOOL)	isLittleEndian
{
	return ![self isBigEndian];
}


-(void)			updateDocumentGUI
{
	[[self owningDocument] updateGUI];
}


-(void)		reportChangeOfUnknownKey: (NSString*)key
{
	[self reportChangeOfUnknownKey: key];
}


-(BOOL)				fieldValueIsEditableForKey: (NSString*)key
{
	return [key isEqualToString: @"value"];
}


-(BOOL)				isSelectable
{
	return [self fieldValueIsEditableForKey: @"value"];
}

@end
