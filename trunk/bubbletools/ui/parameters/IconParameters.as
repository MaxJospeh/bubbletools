﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.parameters {	import flash.display.BitmapData;	import flash.display.Sprite;	import bubbletools.util.Pointdata;	import bubbletools.ui.parameters.InterfaceParameters;	public class IconParameters extends InterfaceParameters {		private var isIconDroppable:Boolean = true;			//	default option is to not allow dropping icons		private var iconImage:String;		private var iconExternal:String;		private var useCache:Boolean = true;				// for external icons, use bitmap library cache (default) or just load image		public function IconParameters() {			super();			componentType = "Icon";			isDraggable = true;			backgroundColor = 0x00000000;					//	default color is transparent; icon image overlays		}		// Icon image (for UIML defined files)		public function setIcon(iconImage:String):void {			this.iconImage = iconImage;		}		public function getIcon():String {			return iconImage;		}		// Icon external url image (for run-time load files)		public function setIconExternal(iconExternal:String):void {			this.iconExternal = iconExternal;		}		public function getIconExternal():String {			return iconExternal;		}		// Use cache		public function setUseCache(useCache:Boolean):void {			this.useCache = useCache;		}		public function getUseCache():Boolean {			return useCache;		}		// Icon allowed to be dropped on or not		public function setDroppable(isIconDroppable:Boolean):void {			this.isIconDroppable = isIconDroppable;		}		public function getDroppable():Boolean {			return (isIconDroppable);		}	}}