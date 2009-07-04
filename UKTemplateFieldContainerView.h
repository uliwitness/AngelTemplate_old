//
//  UKTemplateFieldContainerView.h
//  AngelTemplate
//
//  Created by Uli Kusterer on 12.10.06.
//  Copyright 2006 M. Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/* Container view for all our template field views. You can click one of these
	to select it and maybe in the future do some other fun stuff with it.
	You can also specify a delegate for this class to handle events while it
	is selected. */

@class UKTemplateFieldContainerView;

@protocol UKTemplateFieldContainerViewDelegate <NSObject>

-(BOOL)	templateFieldShouldChangeSelection: (UKTemplateFieldContainerView*)tmplContainer;

@end


@interface UKTemplateFieldContainerView : NSView
{
	id<UKTemplateFieldContainerViewDelegate>	delegate;
	BOOL										selected;
	BOOL										flipped;
	void*										reserved1;
	void*										reserved2;
	void*										reserved3;
	void*										reserved4;
	void*										reserved5;
	void*										reserved6;
	void*										reserved7;
	void*										reserved8;
}

-(BOOL)	isSelected;
-(void)	setSelected: (BOOL)state;

-(id)	delegate;
-(void)	setDelegate: (id)dele;

-(BOOL)	isFlipped;
-(void)	setFlipped: (BOOL)state;

@end