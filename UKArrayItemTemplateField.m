//
//  UKArrayItemTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 21.10.06.
//  Copyright 2006 M. Uli Kusterer. All rights reserved.
//

#import "UKArrayItemTemplateField.h"
#import "UKArrayTemplateField.h"
#import "UKTemplateDocument.h"


@implementation UKArrayItemTemplateField

+(void)   load
{

}


-(id)       initWithSettingsDictionary: (NSDictionary*)dict owner: (UKArrayTemplateField*)owner
{
    self = [super initWithSettingsDictionary: dict];
    if( self )
    {
		fields = [[NSMutableArray alloc] init];
		owningArray = owner;
    }
    
    return self;
}


-(void)	dealloc
{
	[fields release];
	
	[super dealloc];
}


-(void)     readFromData: (NSData*)data offset: (int*)offs
{
    NSEnumerator*		enny = [fields objectEnumerator];
	UKTemplateField*	currField;
	
	while( (currField = [enny nextObject]) )
		[currField readFromData: data offset: offs];
}


-(void)     writeToData: (NSMutableData*)data offset: (int*)offs
{
    NSEnumerator*		enny = [fields objectEnumerator];
	UKTemplateField*	currField;
	
	while( (currField = [enny nextObject]) )
		[currField writeToData: data offset: offs];
}


-(id)           plistRepresentation
{
    NSMutableArray*		arr = [NSMutableArray array];
    NSEnumerator*		fieldEnny = [fields objectEnumerator];
	UKTemplateField*    field;
    
    while( (field = [fieldEnny nextObject]) )
    {
		id  plr = [field plistRepresentation];
		if( plr )
			[arr addObject: plr];
    }
    
    return arr;
}


-(id)				fieldValueForKey: (NSString*)key
{
	if( [key isEqualToString: @"label"] )
		return @"-----";
	else if( [key isEqualToString: @"value"] )
		return @"";
	else
		return nil;
}


-(BOOL)				canHaveSubFields
{
	return YES;
}


-(int)				countSubFields
{
	return [fields count];
}


-(UKTemplateField*)	subFieldAtIndex: (int)index
{
	return [fields objectAtIndex: index];
}


-(void)	addSubField: (UKTemplateField*)fld
{
	[fields addObject: fld];
}


-(BOOL)	isSelectable
{
	return YES;
}


-(void)	delete: (id)sender
{
	[owningArray deleteField: self];
}


-(void)	addNewField: (id)sender
{
	[owningArray addNewFieldAfterField: self];
}


@end
