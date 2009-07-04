//
//  UKArrayItemTemplateField.h
//  AngelTemplate
//
//  Created by Uli Kusterer on 21.10.06.
//  Copyright 2006 M. Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UKTemplateField.h"

@class UKArrayTemplateField;


@interface UKArrayItemTemplateField : UKTemplateField
{
	NSMutableArray*			fields;
	UKArrayTemplateField*	owningArray;
}

// Designated initialiser:
-(id)	initWithSettingsDictionary: (NSDictionary*)dict owner: (UKArrayTemplateField*)owner;

-(void)	addSubField: (UKTemplateField*)fld;

@end
