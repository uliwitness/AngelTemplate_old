//
//  UKArrayTemplateField.h
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

// -----------------------------------------------------------------------------
//	Headers:
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>
#import "UKTemplateField.h"


// -----------------------------------------------------------------------------
//	Forwards:
// -----------------------------------------------------------------------------

@class UKArrayItemTemplateField;


// -----------------------------------------------------------------------------
//	Classes:
// -----------------------------------------------------------------------------

@interface UKArrayTemplateField : UKTemplateField
{
    NSMutableArray*				fields;         // Array fields we've loaded.
}

-(void)	addNewFieldAfterField: (UKArrayItemTemplateField*)afterItem;
-(void)	deleteField: (UKArrayItemTemplateField*)theItem;

-(void) load: (int)num fieldsFromData: (NSData*)data offset: (int*)offs afterField: (UKArrayItemTemplateField*)afterField;

@end
