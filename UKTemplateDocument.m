//
//  UKTemplateDocument.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright M. Uli Kusterer 2005 . All rights reserved.
//

// -----------------------------------------------------------------------------
//  Headers:
// -----------------------------------------------------------------------------

#import "UKTemplateDocument.h"
#import "UKTemplateField.h"
#import "NSOutlineView+ExpandAllItems.h"


@implementation UKTemplateDocument

// -----------------------------------------------------------------------------
//  * CONSTRUCTOR:
// -----------------------------------------------------------------------------

-(id)   init
{
    self = [super init];
    if( self )
    {
        fileData = [[NSMutableData alloc] init];
        fields = [[NSMutableArray alloc] init];
        fieldDefaults = [[NSMutableDictionary alloc] init];
        variables = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


// -----------------------------------------------------------------------------
//  * DESTRUCTOR:
// -----------------------------------------------------------------------------

-(void) dealloc
{
    [fileData release];
    [fields release];
    [fieldDefaults release];
    [variables release];
    
    [super dealloc];
}


// -----------------------------------------------------------------------------
//  windowNibName:
//      Make sure we load the right NIB file.
//
//  REVISIONS:
//      2004-01-19  UK  Documented.
// -----------------------------------------------------------------------------

-(NSString*) windowNibName
{
    return @"UKTemplateDocument";
}


// -----------------------------------------------------------------------------
//  windowControllerDidLoadNib:
//      Load the views for our template field.
//
//  REVISIONS:
//      2004-01-19  UK  Documented.
// -----------------------------------------------------------------------------

-(void) windowControllerDidLoadNib: (NSWindowController*)aController
{
    [super windowControllerDidLoadNib: aController];
    
    [fieldList reloadData];
	[fieldList expandAllItems];
}


// -----------------------------------------------------------------------------
//  dataRepresentationOfType:
//      Save the template data to our file.
//
//  REVISIONS:
//      2004-01-19  UK  Documented.
// -----------------------------------------------------------------------------

-(NSData*)  dataRepresentationOfType: (NSString*)aType
{
    NSEnumerator*       enny = [fields objectEnumerator];
    UKTemplateField*    field;
    int                 offset = 0;

    [fileData setLength: 0];
    
    // Write each field to file:
    while( (field = [enny nextObject]) )
    {
        [field writeToData: fileData offset: &offset];
    }
    
    return fileData;
}


// -----------------------------------------------------------------------------
//  readFromFile:ofType:
//      Load a template and read data from our file into it.
//
//  REVISIONS:
//      2004-01-19  UK  Documented.
// -----------------------------------------------------------------------------

-(BOOL) readFromFile: (NSString*)fileName ofType: (NSString*)type
{
    // Replace current data with new data:
    if( fileData )
    {
        [fileData release];
        fileData = nil;
    }
    fileData = [[NSMutableData alloc] initWithContentsOfFile: fileName];
    
    // Find & read template:
    NSString*       ext = [fileName pathExtension];
    NSString*       tmplName = [NSString stringWithFormat: @"/Library/Application Support/AngelTemplate/Templates/%@.fileTemplate",ext];
    NSString*       tmplPath = [[@"~" stringByAppendingString: tmplName] stringByExpandingTildeInPath];
    if( ![[NSFileManager defaultManager] fileExistsAtPath: tmplPath] )
        tmplPath = tmplName;
    if( ![[NSFileManager defaultManager] fileExistsAtPath: tmplPath] )
        tmplPath = [[NSBundle mainBundle] pathForResource: ext ofType: @"fileTemplate" inDirectory: @"Templates"];
    NSDictionary*   template = [NSDictionary dictionaryWithContentsOfFile: tmplPath];
    
    if( !template )
    {
        NSAlert*    alr = [NSAlert alertWithMessageText: @"No such template." defaultButton:@"OK" alternateButton:@"" otherButton:@""
                            informativeTextWithFormat: @"No valid template for displaying files of type \"%@\" could be found.", ext];
        [alr runModal];
        return NO;
    }
    
    // Load template:
    if( ![self loadFieldsFromDictionary: template] )
        return NO;
    
	[self reloadTemplateFields];
    
    return YES;
}


// -----------------------------------------------------------------------------
//  loadOneFieldFromDictionary:
//      Main bottleneck for loading fields from the template. Takes a
//      dictionary containing field type and other settings for the field and
//      returns the appropriate object based on the specified type.
//
//      Displays an error message and returns NIL on errors.
//
//  REVISIONS:
//      2004-01-19  UK  Documented.
// -----------------------------------------------------------------------------

-(UKTemplateField*) loadOneFieldFromDictionary: (NSDictionary*)template
{
    UKTemplateField*    field = nil;
    
    field = [UKTemplateField fieldWithSettingsDictionary: template];
    
    if( !field )
    {
        NSAlert*    alrt = [NSAlert alertWithMessageText: @"Invalid Template Entry!" defaultButton:@"OK" alternateButton:@"" otherButton:@""
                                        informativeTextWithFormat: @"Field type \"%@\" (for field \"%@\") not supported.",
                                        [template objectForKey: @"type"], [template objectForKey: @"label"]];
        [alrt runModal];
        return nil;
    }
    
    [field setOwningDocument: self];
    
    return field;
}


// -----------------------------------------------------------------------------
//  loadFieldsFromDictionary:
//      Takes a whole template dictionary, loads the fields for it using
//      loadOneFieldFromDictionary:.
//
//  REVISIONS:
//      2004-01-19  UK  Documented.
// -----------------------------------------------------------------------------

-(BOOL) loadFieldsFromDictionary: (NSDictionary*)template
{
    int     version = [[template objectForKey: @"templateVersion"] intValue];
    if( version == 1 )
    {
		[fields release];
		fields = [[NSMutableArray alloc] init];
		
        NSString*   type = [template objectForKey: @"templateType"];
        if( [type isEqualToString: @"fieldList"] )
        {
            NSEnumerator*       enny = [[template objectForKey: @"fieldList"] objectEnumerator];
            NSDictionary*       fieldTemplate;
            
            while( (fieldTemplate = [enny nextObject]) )
            {
                UKTemplateField*    field = [self loadOneFieldFromDictionary: fieldTemplate];
                if( !field )
                    return NO;
                
                [fields addObject: field];
            }
			
			if( fieldDefaults )
				[fieldDefaults release];
			fieldDefaults = [[template objectForKey: @"fieldDefaults"] mutableCopy];
        }
        else
        {
            NSAlert*    alr = [NSAlert alertWithMessageText: @"Invalid Template!" defaultButton:@"OK" alternateButton:@"" otherButton:@""
                                            informativeTextWithFormat: @"Template type \"%@\" not supported.", type];
            [alr runModal];
            return NO;
        }
    }
    else
    {
        NSAlert*    errw = [NSAlert alertWithMessageText: @"Invalid Template!" defaultButton:@"OK" alternateButton:@"" otherButton:@""
                                        informativeTextWithFormat: @"Template version %d not supported.", version];
        [errw runModal];
        return NO;
    }
    
    return YES;
}


// -----------------------------------------------------------------------------
//  loadDataForField:offset:
//      Loads data from the fileData member variable into the specified field.
//      If we're out of data, this just lets the field use its default value.
//
//  REVISIONS:
//		2006-10-21	UK	Changed to use outline view instead of views.
//      2004-01-19  UK  Documented.
// -----------------------------------------------------------------------------

-(void) loadDataForField: (UKTemplateField*)field offset: (int*)offset
{
    if( (*offset) < [fileData length] )
        [field readFromData: fileData offset: offset];
    else
    {
        [field loadDefaults];
        (*offset)++;   // Just so it's larger than the size and we can check it below and notify user we added data.
    }
	NSString*	varName = [field objectForSettingsKey: @"setVariable"];
	if( varName )
		[variables setObject: [field fieldValue] forKey: varName];
}


-(void) reloadTemplateFields
{
    NSEnumerator*       enny = [fields objectEnumerator];
    UKTemplateField*    field;
    int                 offset = 0;
    NSPoint             pos = { 0, 0 };
    NSRect              box;
    float               width = 0;
    
    // Load data into fields:
    while( (field = [enny nextObject]) )
        [self loadDataForField: field offset: &offset];
    
    // Check size:
    if( offset > [fileData length] )
    {
        [self updateChangeCount: NSChangeDone];
        NSAlert*    alrt = [NSAlert alertWithMessageText: @"Not enough data in file!" defaultButton:@"OK" alternateButton:@"" otherButton:@""
                            informativeTextWithFormat: @"The file contains less data than expected. The template has been padded out with default values."];
        [[fieldList window] makeKeyAndOrderFront: self];
        [alrt beginSheetModalForWindow: [fieldList window] modalDelegate: self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo: nil];
    }
    else if( offset < [fileData length] )
    {
        [self updateChangeCount: NSChangeDone];
        NSAlert*    alr = [NSAlert alertWithMessageText: @"File too long!" defaultButton:@"OK" alternateButton:@"" otherButton:@""
                            informativeTextWithFormat: @"The file contains %lu bytes more data than the template can cope with. If you save, this data will be discarded.",
							([fileData length] -offset)];
        [[fieldList window] makeKeyAndOrderFront: self];
        [alr beginSheetModalForWindow: [fieldList window] modalDelegate: self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo: nil];
    }
	
	[fieldList reloadData];
	[fieldList expandAllItems];
}


-(void)		updateGUI
{
	[fieldList reloadItem: nil reloadChildren: YES];
	[fieldList noteNumberOfRowsChanged];
	[fieldList expandAllItems];
}


-(void)	fieldChanged: (UKTemplateField*)itm
{
	[fieldList reloadItem: itm reloadChildren: YES];
    [self updateChangeCount: NSChangeDone];
}


-(void) alertDidEnd: (NSAlert*)alert returnCode: (int)returnCode contextInfo: (void*)contextInfo
{
    
}


-(void) copyFileAsPList: (id)sender
{
    NSEnumerator*           enny = [fields objectEnumerator];
    UKTemplateField*        field;
    NSMutableArray*         plistArr = [NSMutableArray array];
    
    // Load data into fields:
    while( (field = [enny nextObject]) )
        [field addToArray: plistArr];
    
    NSString*       errorString = nil;
    NSData*         plist = [NSPropertyListSerialization dataFromPropertyList: plistArr format: NSPropertyListXMLFormat_v1_0 errorDescription: &errorString];

    if( errorString != nil || plist == nil )
    {
        NSLog(@"Error copying template as property list: %@", errorString);
        [errorString release];
    }
    else
    {
        NSString*       str = [[[NSString alloc] initWithData: plist encoding: NSUTF8StringEncoding] autorelease];
        NSPasteboard*   pb = [NSPasteboard generalPasteboard];
        [pb declareTypes: [NSArray arrayWithObjects: NSStringPboardType, nil] owner: self];
        [pb setString: str forType: NSStringPboardType];
    }
}


-(id)	outlineView: (NSOutlineView*)outlineView child: (int)index ofItem: (id)item
{
	if( item == nil )
		return [fields objectAtIndex: index];
	else
		return [item subFieldAtIndex: index];
}


-(BOOL)	outlineView: (NSOutlineView*)outlineView isItemExpandable: (id)item
{
	if( item == nil )
		return YES;
	else
		return [item canHaveSubFields];
}


- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if( item == nil )
		return [fields count];
	else
		return [item countSubFields];
}


-(id)	outlineView: (NSOutlineView*)outlineView objectValueForTableColumn: (NSTableColumn*)tableColumn byItem: (id)item
{
	return [item fieldValueForKey: [tableColumn identifier]];
}


-(void)	outlineView: (NSOutlineView*)outlineView setObjectValue: (id)object forTableColumn: (NSTableColumn*)tableColumn byItem: (id)item
{
	if( [item respondsToSelector: @selector(setFieldValue:forKey:)] )
	{
		NSString*		keyName = [tableColumn identifier];
		[item setFieldValue: object forKey: keyName];
		if( [keyName isEqualToString: @"value"] )
		{
			NSString*	varName = [item objectForSettingsKey: @"setVariable"];
			if( varName )
				[variables setObject: [item fieldValueForKey: keyName] forKey: varName];
		}
	}
}


-(BOOL)	outlineView: (NSOutlineView*)outlineView shouldEditTableColumn: (NSTableColumn*)tableColumn item: (id)item
{
	if( item == nil )
		return YES;
	else
		return [item fieldValueIsEditableForKey: [tableColumn identifier]];
}


-(BOOL)	outlineView: (NSOutlineView*)outlineView shouldSelectItem: (id)item
{
	if( item == nil )
		return YES;
	else
		return [item isSelectable];
}



-(void)				field: (UKTemplateField*)fld gotUnknownValueKey: (NSString*)key
{
	NSAlert*    alr = [NSAlert alertWithMessageText: @"You can't change this!" defaultButton:@"Acknowledged" alternateButton:@"" otherButton:@""
						informativeTextWithFormat: @"This attribute of the field can't be changed. Your change has been reverted."];
	[[fieldList window] makeKeyAndOrderFront: self];
	[alr beginSheetModalForWindow: [fieldList window] modalDelegate: self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo: nil];
}


-(id)	objectForSettingsKey: (NSString*)key
{
	return [fieldDefaults objectForKey: key];
}


-(BOOL)	respondsToSelector: (SEL)theMethod
{
	if( [super respondsToSelector: theMethod] )
		return YES;
	
	// If we can't handle it, see if the selected item can:
	int		selRow = [fieldList selectedRow];
	if( selRow == -1 )
		return NO;
	UKTemplateField*	item = [fieldList itemAtRow: selRow];
	
	return [item respondsToSelector: theMethod];
}


-(void)	forwardInvocation: (NSInvocation*)anInvocation
{
	int		selRow = [fieldList selectedRow];
	if( selRow == -1 )
		[self doesNotRecognizeSelector: [anInvocation selector]];
	UKTemplateField*	item = [fieldList itemAtRow: selRow];
	
	if( [item respondsToSelector: [anInvocation selector]] )
		[anInvocation invokeWithTarget: item];
	else
		[self doesNotRecognizeSelector: [anInvocation selector]];
}


-(NSMethodSignature*)	methodSignatureForSelector: (SEL)theMethod
{
	NSMethodSignature*	sig = [super methodSignatureForSelector: theMethod];
	if( sig )
		return sig;
	
	// If we can't handle it, see if the selected item can:
	int		selRow = [fieldList selectedRow];
	if( selRow == -1 )
		return nil;
	UKTemplateField*	item = [fieldList itemAtRow: selRow];
	
	return [item methodSignatureForSelector: theMethod];
}


@end
