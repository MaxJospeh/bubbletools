﻿package bubbletools.util {	import flash.utils.getQualifiedClassName;		import bubbletools.util.Strings;	public class Debug {				private static var _instance:Debug;				public static function instance():Debug {			if (Debug._instance == null) {				Debug._instance = new Debug();			}			return Debug._instance;		}			public function Debug(){		}			public static function output(callingClass:Object, txt:String):void {			var showText:String = "["+getQualifiedClassName(callingClass)+"] "+txt;			showText = Strings.replaceInString(showText, "::", "] [");         						trace(showText);  					}		}	}