//
//  UKArrayTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

#import "UKArrayTemplateField.h"
#import "UKTemplateDocument.h"
#import "UKArrayItemTemplateField.h"


@implementation UKArrayTemplateField

+(void)   load
{
    [self registerForDefaultName];
    [self registerTemplateFieldClass: [self class] forType: @"TwoByteArray"];
}

-(id)       initWithSettingsDictionary: (NSDictionary*)dict
{
    self = [super initWithSettingsDictionary: dict];
    if( self )
	{
        fields = [[NSMutableArray alloc] init];
    }
    
    return self;
}


-(void) dealloc
{
    [fields release];
    fields = nil;
	
    [super dealloc];
}


-(void)     readFromData: (NSData*)data offset: (int*)offs
{
    int     num = 0, x;
    
    if( [[settings objectForKey: @"type"] isEqualToString: @"TwoByteArray"] )
    {
        short n;
        if( ([data length] -(*offs)) >= sizeof(short) )
            [data getBytes: &n range: NSMakeRange(*offs,sizeof(short))];
			if( [self isBigEndian] )
				num = EndianS16_BtoN(n);
			else
				num = EndianS16_LtoN(n);
        *offs += sizeof(short);
    }
    else
    {
        if( ([data length] -(*offs)) >= sizeof(int) )
            [data getBytes: &num range: NSMakeRange(*offs,sizeof(int))];
		if( [self isBigEndian] )
			num = EndianS32_BtoN(num);
		else
			num = EndianS32_LtoN(num);
        *offs += sizeof(int);
    }
    
    // Load fields:
    [self load: num fieldsFromData: data offset: offs afterField: nil];
}


-(void) loadDefaults
{
    int     offs = 0;
    [self load: 0 fieldsFromData: [NSData data] offset: &offs afterField: nil];
}


// -----------------------------------------------------------------------------
//	load:fieldsFromData:offset:afterField:
//		Insert new items at a particular spot in the array. Used by our array
//		item fields to create new items, and to load our initial set of items.
//		Specify NIL for afterField to add items at the top.
// -----------------------------------------------------------------------------

-(void) load: (int)num fieldsFromData: (NSData*)data offset: (int*)offs afterField: (UKArrayItemTemplateField*)afterField
{
    NSArray*    fieldsTemplate = [settings objectForKey: @"fieldList"];
    int         x;
	int			afterIndex = -1;
	if( afterField )
		afterIndex = [fields indexOfObject: afterField];
    
    // Read that many array items:
    for( x = 0; x < num; x++ )
    {
        NSEnumerator*				enny = [fieldsTemplate objectEnumerator];
        NSDictionary*				fieldTmpl;
        UKArrayItemTemplateField*	itemFields = [[[UKArrayItemTemplateField alloc] initWithSettingsDictionary: [NSDictionary dictionary] owner: self] autorelease];
		[itemFields setOwningDocument: [self owningDocument]];
		
        // Loop over fields of this item and load each one:
        while( (fieldTmpl = [enny nextObject]) )
        {
            UKTemplateField* fld = [[self owningDocument] loadOneFieldFromDictionary: fieldTmpl];
            [itemFields addSubField: fld];
            [[self owningDocument] loadDataForField: fld offset: offs];
        }
        
		// Add item with several fields in it to list of items:
		//	This prefix-++es the index. This takes care that -1 gets turned
		//	into 0 and thus our item is inserted right at the top, and it also
		//	takes care that when inserting several items they maintain their
		//	order and the 2nd item isn't inserted *before* the first.
        [fields insertObject: itemFields atIndex: ++afterIndex];
    }
}


-(void)	addNewFieldAfterField: (UKArrayItemTemplateField*)afterItem
{
	int					offs = 0;
	
	[self load: 1 fieldsFromData: [NSData data] offset: &offs afterField: afterItem];
	[[self owningDocument] fieldChanged: self];
}


-(void)	deleteField: (UKArrayItemTemplateField*)theItem
{
	[fields removeObject: theItem];
	[[self owningDocument] fieldChanged: self];
}


-(void)     writeToData: (NSMutableData*)data offset: (int*)offs
{
    int     num = [fields count];
    
    if( [[settings objectForKey: @"type"] isEqualToString: @"TwoByteInteger"] )
    {
		short	n = 0;
		if( [self isBigEndian] )
			n = EndianS16_NtoB(num);
		else
			n = EndianS16_NtoL(num);
        [data appendBytes: &n length: sizeof(short)];
        *offs += sizeof(n);
    }
    else
    {
		int		i = 0;
		if( [self isBigEndian] )
			i = EndianS32_NtoB(num);
		else
			i = EndianS32_NtoL(num);
        [data appendBytes: &i length: sizeof(int)];
        *offs += sizeof(i);
    }
    
    NSEnumerator*				itemEnny = [fields objectEnumerator];
	UKArrayItemTemplateField*    field;
    
    while( (field = [itemEnny nextObject]) )
    {
		[field writeToData: data offset: offs];
    }
}


-(id)           plistRepresentation
{
    NSMutableArray*				arr = [NSMutableArray array];
    NSEnumerator*				itemEnny = [fields objectEnumerator];
	UKArrayItemTemplateField*    field;
    
    while( (field = [itemEnny nextObject]) )
    {
		id  plr = [field plistRepresentation];
		if( plr )
			[arr addObject: plr];
    }
    
    return arr;
}


-(id)				fieldValue
{
	return [NSNumber numberWithInt: [fields count]];	
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


-(BOOL)	fieldValueIsEditableForKey: (NSString*)key
{
	return NO;
}


-(BOOL)	isSelectable
{
	return YES;
}


-(void)	addNewField: (id)sender
{
	[self addNewFieldAfterField: nil];	// Insert a new field at the top.
}


@end
