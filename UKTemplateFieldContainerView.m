//
//  UKTemplateFieldContainerView.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 12.10.06.
//  Copyright 2006 M. Uli Kusterer. All rights reserved.
//

#import "UKTemplateFieldContainerView.h"


@implementation UKTemplateFieldContainerView

-(id)	initWithFrame: (NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code here.
    }
	
    return self;
}

-(void)	drawRect: (NSRect)rect
{
	if( [self isSelected] )
	{
		[[NSColor selectedControlColor] set];
		//[NSBezierPath setDefaultLineWidth: 4.0];
		[NSBezierPath fillRect: [self bounds]];
	}
}


-(void)	mouseDown: (NSEvent*)theEvent
{
	if( delegate && [delegate respondsToSelector: @selector(templateFieldShouldChangeSelection:)]
		&& [delegate templateFieldShouldChangeSelection: self] )
	{
		selected = !selected;
		[self setNeedsDisplay: YES];
	}
}


-(BOOL)	isSelected
{
	return selected;
}

-(void)	setSelected: (BOOL)state
{
	selected = state;
}

-(id)	delegate
{
	return delegate;
}


-(void)	setDelegate: (id)dele
{
	delegate = dele;
}


-(BOOL)	isFlipped
{
	return flipped;
}


-(void)	setFlipped: (BOOL)state
{
	flipped = state;
}


@end
