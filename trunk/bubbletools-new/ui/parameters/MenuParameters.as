﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.parameters {		import flash.display.Sprite;	import flash.display.BitmapData;		import bubbletools.core.library.BitmapFile;	import bubbletools.util.Pointdata;	import bubbletools.ui.parameters.InterfaceParameters;	import bubbletools.ui.interfaces.IParameters;	import bubbletools.ui.main.ComponentTypes;	import bubbletools.ui.main.ComponentType;	import bubbletools.ui.framework.UI;	public class MenuParameters extends InterfaceParameters {			private var listedType:ComponentType;		private var listedTypeParameters:InterfaceParameters;				private var itemList:Array;		private var spacing:Number = 0;								//	default option is items flush next to each other		private var direction:String = "down";						//	default is a downward menu		private var alignment:String = "left";						//  default is a menu that aligns to the left, expanding to the right		private var dataSource:Array;		private var menuData:Array;		private var menuTitle:String;		private var menuTitleImageId:String;		private var menuTitleHeight:Number;		private var menuTitleWidth:Number;		private var menuTitleTextColor:Number = 0xFF000000;		private var menuTitleFontSize:Number = 12;		private var menuTitleFont:String = "Arial";				public function MenuParameters(){			super();			setListedType("MenuItem", new InterfaceParameters());	//  default listed item is a InterfaceMenuItem			componentType = "Menu";			backgroundColor = 0x00000000;							//	menu background must be transparent			outline = 0;											//	menu must have no outline		}		// Data source to construct the menu		public function setDataSource(dataSource:Array):void {			this.dataSource = dataSource;		}		public function getDataSource():Array {			return(dataSource);		}		// Change the type listed in the menu		public function setListedType(listedTypeName:String, listedTypeParameters:IParameters):void {			if(ComponentTypes.instance().hasType(listedTypeName)) {				this.listedType = ComponentTypes.instance().getType(listedTypeName);				this.listedTypeParameters = InterfaceParameters(listedTypeParameters);			} else {				trace("WARNING : Listed type for a Menu does not exist");			}		}		public function getListedType():ComponentType {			return(listedType);		}		public function getListedParameters():InterfaceParameters {			return(listedTypeParameters)		}		// Direction		public function setDirection(direction:String):void {			this.direction = direction;		}		public function getDirection():String {			return(direction);		}		// Alignment		public function setAlignment(alignment:String):void {			this.alignment = alignment;		}		public function getAlignment():String {			return(alignment);		}		// Spacing		public function setListSpacing(spacing:Number):void {			this.spacing = spacing;		}		public function getListSpacing():Number {			return(spacing);		}		// Array for listed components 		public function setItemList(itemList:Array):void {			this.itemList = itemList;		}		public function getItemList():Array {			return(itemList);		}		// menu title		public function setMenuTitle(menuTitle:String):void {			this.menuTitle = menuTitle;		}		public function getMenuTitle():String {			return(menuTitle);		}		// menu title font		public function setMenuTitleFont(menuTitleFont:String):void {			this.menuTitleFont = menuTitleFont;		}		public function getMenuTitleFont():String {			return(menuTitleFont);		}		// menu title font size		public function setMenuTitleFontSize(menuTitleFontSize:Number):void {			this.menuTitleFontSize = menuTitleFontSize;		}		public function getMenuTitleFontSize():Number {			return(menuTitleFontSize);		}		// menu title		public function setMenuTitleTextColor(menuTitleTextColor:Number):void {			this.menuTitleTextColor = menuTitleTextColor;		}		public function getMenuTitleTextColor():Number {			return(menuTitleTextColor);		}		// menu title background		public function setMenuTitleImage(menuTitleImageId:String):void {			this.menuTitleImageId = menuTitleImageId;		}		public function getMenuTitleImage():String {			return(menuTitleImageId);		}		// menu title height		public function setMenuTitleHeight(menuTitleHeight:Number):void {			this.menuTitleHeight = menuTitleHeight;		}		public function getMenuTitleHeight():Number {			return(menuTitleHeight);		}		// menu title width		public function setMenuTitleWidth(menuTitleWidth:Number):void {			this.menuTitleWidth = menuTitleWidth;		}		public function getMenuTitleWidth():Number {			return(menuTitleWidth);		}		}}