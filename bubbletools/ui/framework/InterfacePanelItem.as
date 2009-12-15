﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.framework {        	import flash.display.Sprite; 		import bubbletools.util.Pointdata;	import bubbletools.util.MouseEventCapture;	import bubbletools.ui.interfaces.IParameters;	import bubbletools.ui.eventing.*	import bubbletools.ui.framework.*	import bubbletools.ui.parameters.*	import bubbletools.ui.framework.ComponentView;	import bubbletools.ui.interfaces.Reporter; 	import bubbletools.util.Debug;	public class InterfacePanelItem extends InterfaceComponent implements Reporter {				public static var DESCRIPTION:String = "Layout element containing an loadable image and text element with an overlay button";			//  =====================================================================================================		//  Component parameters		//		private var parameters:PanelItemParameters;			//  =====================================================================================================		// 	Nested components and parameters		//			private var itemText:InterfaceTextDisplay;		private var t:TextDisplayParameters;   				private var itemImage:InterfaceImageDisplay;		private var i:ImageDisplayParameters;				private var button:InterfaceButton;		private var b:ButtonParameters;			public function InterfacePanelItem(parentComponent:InterfaceComponent){			super(parentComponent);			componentType = "PanelItem";			allowSubcomponents = true;		}				//  =====================================================================================================		//  Reporter Implementation		//				public function makeEvent(eventType:String):UIEvent {			var newEvent:UIEvent = UIEventManager.instance().createUIEvent(id, componentType, eventType);			return(newEvent);		}	                                                                      		//  =====================================================================================================		//  Custom Methods		//				public function itemId():String {			return parameters.getItemId();		}        				public function listId():int {			return getParameters().getListId();		}				public function updatePanelImage(URL:String):void {			Debug.output(this, "Update image to "+URL);			itemImage.updateImage(URL);  		}			//  =====================================================================================================		//  Required Override Methods		//		public override function setParameters(newParameters:IParameters):void {       						globalParameters = newParameters;			parameters = PanelItemParameters(newParameters);			// Image for the PanelItem						i = new ImageDisplayParameters();			i.setSize(new Pointdata(getParameters().getSize().X, getParameters().getSize().Y));  			i.setLocation(new Pointdata(0,0));			i.setOutline(0);			i.setScaleImage(true);			i.setImageURL("");					itemImage = InterfaceImageDisplay(this.addComponent("ImageDisplay", i));  					  	// Text for the PanelItem			t = new TextDisplayParameters();		   	t.setText(getParameters().getText());		   	t.setSize(new Pointdata(parameters.getTextDisplaySize().X, parameters.getTextDisplaySize().Y));  			t.setTextDisplayBold(parameters.getItemTextDisplayBold());			t.setTextColor(getParameters().getTextColor());			t.setFont(getParameters().getFont());			t.setFontSize(getParameters().getFontSize());			t.setLocation(new Pointdata(parameters.getTextPosition().X, parameters.getTextPosition().Y));			t.setTextDisplayAlign("left");				t.setTextSelectable(false);				   	//itemText = InterfaceTextDisplay(this.addComponent("TextDisplay", t));                                                                   						// Button for the PanelItem			b = new ButtonParameters();			b.setSize(new Pointdata(getParameters().getSize().X, getParameters().getSize().Y));			b.setLocation(new Pointdata(0,0));			b.setColor(0x00000000);			b.setOutline(0);			b.setColorOver(getParameters().getColorOver());			b.setColorDown(getParameters().getColorDown()); 			b.setDefaultState(parameters.getButtonDefaultStateId());			b.setOverState(parameters.getButtonOverStateId());			b.setDownState(parameters.getButtonDownStateId());			b.setIsToggle(parameters.getButtonIsToggle());   									button = InterfaceButton(this.addComponent("Button", b));					}	 				public override function handleMouseEvent(clickType:String):void {			switch(clickType) {				case "release" :					bubbleEvent(UIEventType.PANEL_ITEM_RELEASE);					break;   				case "over" :					updateMouseState("over");					bubbleEvent(UIEventType.PANEL_ITEM_OVER);					break;				case "out" :					updateMouseState("out");					bubbleEvent(UIEventType.PANEL_ITEM_OUT);					break; 				case "press" :					updateMouseState("down");					bubbleEvent(UIEventType.PANEL_ITEM_PRESS);					break;               				}		}			public override function registerInternal(reporter:InterfaceComponent, interfaceEvent:UIEvent):void {						switch (interfaceEvent.info.eventType) {				case UIEventType.BUTTON_RELEASE :					bubbleEvent(UIEventType.PANEL_ITEM_RELEASE);					break;			}				}		}}