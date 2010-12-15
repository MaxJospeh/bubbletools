﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.main {	import flash.system.Capabilities;	import bubbletools.ui.framework.*;	import bubbletools.ui.main.ComponentType;	import bubbletools.ui.parameters.*;	public class ComponentTypes {		// TODO : use statics for all component type strings		public static var ABSTRACT:String = "Abstract";		public static var WINDOW:String = "Window";		private static var _instance:ComponentTypes = null;		private var typesArray:Array;		public static function instance():ComponentTypes {			if (ComponentTypes._instance == null) {				ComponentTypes._instance = new ComponentTypes();			}			return ComponentTypes._instance;		}		public function ComponentTypes() {			// Create types for all base components.			// More component types may be registered using the addCustomComponentType methond.			// In order to create a valid component you need to create the following :			// 		- A component that extends BTComponent			//		- A set of parameters that extends InerfaceParameters			// To add a component at run time, there are two steps required :			//		- Register the ComponentType with this class			//		- Register a group of ParameterBindings with the ParameterBindingList.			typesArray = new Array();			typesArray["Abstract"] = new ComponentType("Abstract", BTComponent, InterfaceParameters);			typesArray["Window"] = new ComponentType("Window", BTWindow, WindowParameters);			typesArray["Menu"] = new ComponentType("Menu", BTMenu, MenuParameters);			typesArray["MenuItem"] = new ComponentType("MenuItem", BTMenuItem, MenuItemParameters);			typesArray["TitleBar"] = new ComponentType("TitleBar", BTTitleBar, TitleBarParameters);			typesArray["TabBar"] = new ComponentType("TabBar", BTTabBar, TabBarParameters);			typesArray["Button"] = new ComponentType("Button", BTButton, ButtonParameters);			typesArray["PanelItem"] = new ComponentType("PanelItem", BTPanelItem, PanelItemParameters);			typesArray["TextDisplay"] = new ComponentType("TextDisplay", BTTextDisplay, TextDisplayParameters);			typesArray["ImageDisplay"] = new ComponentType("ImageDisplay", BTImageDisplay, ImageDisplayParameters);			typesArray["SWFDisplay"] = new ComponentType("SWFDisplay", BTSWFDisplay, SWFDisplayParameters);			typesArray["Icon"] = new ComponentType("Icon", BTIcon, IconParameters);			typesArray["SlideControl"] = new ComponentType("SlideControl", BTSlideControl, SlideControlParameters);			typesArray["Scrollable"] = new ComponentType("Scrollable", BTScrollable, ScrollableParameters);			typesArray["ScrollBar"] = new ComponentType("ScrollBar", BTScrollBar, ScrollBarParameters);			typesArray["ListBox"] = new ComponentType("ListBox", BTListBox, ListBoxParameters);			typesArray["ListItem"] = new ComponentType("ListItem", BTListItem, ListItemParameters);			typesArray["TitleBar"] = new ComponentType("TitleBar", BTTitleBar, TitleBarParameters);			typesArray["VideoDisplay"] = new ComponentType("VideoDisplay", BTVideoDisplay, VideoDisplayParameters);			typesArray["VideoSeek"] = new ComponentType("VideoSeek", BTVideoSeek, VideoSeekParameters);		}		public function addCustomComponentType(id:String, newComponentType:ComponentType):void {			typesArray[id] = newComponentType;		}		public function hasType(componentTypeName:String):Boolean {			if (typesArray[componentTypeName] is ComponentType) {				return (true);			} else {				return (false);			}		}		public function getType(componentTypeName:String):ComponentType {			return (typesArray[componentTypeName]);		}		public function listAll():Array {			return (typesArray);		}	}}