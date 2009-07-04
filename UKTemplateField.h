//
//  UKTemplateField.h
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

// -----------------------------------------------------------------------------
//	Headers:
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>
#import "UKTemplateFieldProtocol.h"


// -----------------------------------------------------------------------------
//	Forwards:
// -----------------------------------------------------------------------------

@class UKTemplateDocument;


// -----------------------------------------------------------------------------
//	Classes:
// -----------------------------------------------------------------------------

@interface UKTemplateField : NSObject <UKTemplateFieldProtocol,UKTemplateFieldOverridableMethods>
{
    NSDictionary*		settings;       // Settings dictionary from template.
    NSDocument*			owningDocument; // Document this field belongs to.
}

+(void)         registerForDefaultName;
+(void)         registerTemplateFieldClass: (Class)cl forType: (NSString*)type; // Call this from your subclasses' +initialize method if you need to register your class for additional types. By default it takes the name of your class, removing "TemplateField" at the end, if present.

-(id)					initWithSettingsDictionary: (NSDictionary*)dict;    // Designated initializer. 

-(void)                 setOwningDocument: (NSDocument*)doc;    // Doesn't retain doc to avoid circles.
-(UKTemplateDocument*)  owningDocument;

-(id)					fieldValue;								// Override this to show your value. Called by fieldValueForKey: to provide the actual value (as opposed to label etc., which we can pull from the template).
-(id)					fieldValueForKey: (NSString*)key;		// Value/Label etc. of this field to display in the document's outline view.
-(BOOL)					fieldValueIsEditableForKey: (NSString*)key;
-(BOOL)					isSelectable;
-(void)					loadDefaults;							// When we run out of data, this is called instead of read...

-(void)					addToArray: (NSMutableArray*)arr;		// Add this field to a plist-array for writing to a plist file or copying to clipboard in plist format.

@end
