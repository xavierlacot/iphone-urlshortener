//
//  BEStatusHUD.h
//  PasteUrl
//
//  Created by Steve Hernandez on 5/16/09.
//  Copyright 2009 BinaryImplosion.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BEStatusHUD : UIView {
		
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	bool useAnimation;
		
	float width;
	float height;

	UIImageView *imageView;
	UILabel *label;
	UILabel *detailsLabel;
		
	id delegate;
	NSString *labelText;
	NSString *detailsLabelText;
	float opacity;
	UIFont *labelFont;
	UIFont *detailsLabelFont;
	
}

/**
 * A convenience constructor tat initializes the HUD with the window's bounds.
 * Calls the designated constructor with window.bounds as the parameter. 
 */
- (id)initWithWindow:(UIWindow *)window;

/** 
 * The HUD delegate object. If set the delegate will receive hudWasHidden callbacks when the hud was hidden.  
 * The delegate should conform to the MBProgressHUDDelegate protocol and implement the hudWasHidden method. 
 */
@property (assign) id delegate;

/**
 * An optional short message to be displayed below the activity indicator. 
 * The HUD is automatically resized to fit the entire text. If the text is too long it will get clipped by displaying "..." at the end.
 * If left unchanged or set to @"", then no message is displayed. 
 */
@property (copy) NSString *labelText;

/**
 * An optional details message displayed below the labelText message.
 * This message is displayed only if the labelText property is also set and is different from an empty string (@"").
 */
@property (copy) NSString *detailsLabelText;

/**
 * The opacity of the hud window. 
 * Defaults to 0.9 (90% opacity).
 */
@property (assign) float opacity;

/**
 * Font to be used for the main label.
 * Set this property if the default is not adequate. 
 */
@property (assign) UIFont *labelFont;

/**
 * Font to be used for the details label.
 * Set this property if the default is not adequate. 
 */
@property (assign) UIFont *detailsLabelFont;

/**
 * Shows the HUD while a background task is executing in a new thread, then hides the HUD.
 * 
 * This method also takes care of NSAutoreleasePools so your method does not have to be concerned with setting up a pool.
 *
 * @param method The method to be executed while the HUD is shown. This method will be executed in a new thread. 
 * @param target The object that the target method belongs to. 
 * @param object An optional object to be passed to the method.
 * @param animated If set to YES the HUD will appear and disappear using a fade animation. 
 *        If set to NO the HUD will not use animations while appearing and disappearing. 
 */
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(bool)animated;

@end


/**
 * Defines callback methods for MBProgressHUD delegates.
 */
@protocol BEStatusHUDDelegate 

/**
 * A callback function that is called after the hud was fully hidden from the screen.
 */
- (void)statusHudWasHidden;

@end
