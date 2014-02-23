//
//  UKPluginTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 22.10.06.
//  Copyright 2006 M. Uli Kusterer. All rights reserved.
//

#import "UKPluginTemplateField.h"


@implementation UKPluginTemplateField

-(void)	dealloc
{
	[pluginController release];
	
	[super dealloc];
}

-(void)	setPluginController: (id<UKTemplateFieldPluginProtocol>)cont
{
	if( pluginController != cont )
	{
		[pluginController release];
		pluginController = [cont retain];
	}
}

-(void)	readFromData: (NSData*)data offset: (int*)offs
{
    [pluginController readFromData: data offset: offs];
}


-(void)	writeToData: (NSMutableData*)data offset: (int*)offs
{
    [pluginController writeToData: data offset: offs];
}


-(id)	plistRepresentation
{
    return [pluginController plistRepresentation];
}


-(id)	fieldValue
{
	if( [pluginController respondsToSelector: @selector(fieldValue)] )
		return [pluginController fieldValue];
	else
		return @"???";
}


-(id)	fieldValueForKey: (NSString*)key
{
	if( [pluginController respondsToSelector: @selector(fieldValueForKey:)] )
		return [pluginController fieldValueForKey: key];
	else
		return [super fieldValueForKey: key];
}


-(void)	setFieldValue: (id)val forKey: (NSString*)key
{
	if( [pluginController respondsToSelector: @selector(setFieldValue:forKey:)] )
		[pluginController setFieldValue: val forKey: key];
	else
		[self reportChangeOfUnknownKey: key];
}


-(void) loadDefaults
{
	if( [pluginController respondsToSelector: @selector(loadDefaults)] )
		return [pluginController loadDefaults];
}


-(BOOL)				canHaveSubFields
{
	if( [pluginController respondsToSelector: @selector(canHaveSubFields)] )
		return [pluginController canHaveSubFields];
	else
		return NO;
}


-(int)				countSubFields
{
	if( [pluginController respondsToSelector: @selector(countSubFields)] )
		return [pluginController countSubFields];
	else
		return 0;
}


-(UKTemplateField*)	subFieldAtIndex: (int)index
{
	if( [pluginController respondsToSelector: @selector(subFieldAtIndex:)] )
		return [pluginController subFieldAtIndex: index];
	else
		[NSException raise: @"UKPluginTemplateFieldSubFieldAtIndexUnimplemented" format: @"Error: Plugin controller %@ doesn't correctly implement -subFieldAtIndex.", NSStringFromClass([pluginController class])];
	return nil;
}


-(BOOL)				fieldValueIsEditableForKey: (NSString*)key
{
	if( [pluginController respondsToSelector: @selector(fieldValueIsEditableForKey:)] )
		return [pluginController fieldValueIsEditableForKey: key];
	else
		return [super fieldValueIsEditableForKey: key];
}


-(BOOL)				isSelectable
{
	if( [pluginController respondsToSelector: @selector(isSelectable)] )
		return [pluginController isSelectable];
	else
		return [super isSelectable];
}


@end
