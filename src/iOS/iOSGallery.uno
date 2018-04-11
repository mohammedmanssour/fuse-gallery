using Uno.Threading;
using Uno;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse.ImageTools;

using Fuse;
using Fuse.Scripting;

namespace MissionFuse.Gallery
{

	[Require("Source.Include", "iOS/MissionXImagePicker.h")]
	[Require("Cocoapods.Podfile.Target", "pod 'TZImagePickerController'")]
	public extern(iOS) class iOSGallery{

		public ObjC.Object Picker;

		public iOSGallery(Action<string> onComplete, Action<string>onFailure)
		{
			InitPicker(onComplete, onFailure);
		}

		[Foreign(Language.ObjC)]
		public void InitPicker(Action<string> onComplete, Action<string>onFailure)
		@{
			MissionXImagePicker* missionxPicker = [[MissionXImagePicker alloc] initWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
			missionxPicker.onCompleteHandler = onComplete;
			missionxPicker.onFailureHandler = onFailure;
			@{iOSGallery:Of(_this).Picker:Set(missionxPicker)};
		@}

		[Foreign(Language.ObjC)]
		public void GetImages()
		@{
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

				MissionXImagePicker* missionxPicker = @{iOSGallery:Of(_this).Picker:Get()};
				[missionxPicker launchPicker];

			});
		@}
	}
}