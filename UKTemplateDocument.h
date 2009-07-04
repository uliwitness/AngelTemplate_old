//
//  UKTemplateDocument.h
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright M. Uli Kusterer 2005 . All rights reserved.
//


// -----------------------------------------------------------------------------
//  Headers:
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>


// -----------------------------------------------------------------------------
//  Forwards:
// -----------------------------------------------------------------------------

@class UKTemplateField;


// -----------------------------------------------------------------------------
//  Classes:
// -----------------------------------------------------------------------------

@interface UKTemplateDocument : NSDocument
{
	IBOutlet NSOutlineView*	fieldList;		// View in which we list all our fields.
    NSMutableData*			fileData;		// The data we are currently editing.
    NSMutableArray*			fields;			// UKTemplateField objects used for editing document.
	NSMutableDictionary*	fieldDefaults;	// Default settings inherited by every field in this template.
	NSMutableDictionary*	variables;		// Variables in which a template can store a field for later retrieval, e.g. if a size is far away from the corresponding sized block or so.
}

-(BOOL)             loadFieldsFromDictionary: (NSDictionary*)template;
-(UKTemplateField*) loadOneFieldFromDictionary: (NSDictionary*)template;

-(void)				updateGUI;
-(void)				fieldChanged: (UKTemplateField*)itm;
-(void)             reloadTemplateFields;
-(void)             loadDataForField: (UKTemplateField*)field offset: (int*)offset;
-(void)             copyFileAsPList: (id)sender;

-(void)				field: (UKTemplateField*)fld gotUnknownValueKey: (NSString*)key;

-(id)				objectForSettingsKey: (NSString*)key;

@end
