using Uno;
using Uno;
using Uno.UX;
using Uno.Graphics;
using Uno.Platform;
using Uno.Threading;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Scripting;
using Fuse.Controls;

namespace MissionFuse.Gallery
{

	[UXGlobalModule]
	public class Gallery : NativeModule
	{
		static readonly Gallery _instance;

		public static Promise<string> promise;

		public static object iosGalery;
		public static object androidGallery;

		public Gallery()
		{
			// Make sure we're only initializing the module once
			if (_instance != null) return;

			_instance = this;
			Resource.SetGlobalKey(_instance, "MissionFuse/Gallery");

			AddMember(new NativePromise<string, Fuse.Scripting.Array>("getImages", GetImages, Converter));
		}

		/*----------------------Class Helpers -------------------*/

		static Fuse.Scripting.Array Converter(Context context, string str)
		{
			return (Fuse.Scripting.Array)context.ParseJson(str);
		}

		public static void InitPicker(){
			promise = new Promise<string>();
			var cb = new ImagesCallback(promise);

			if defined(ANDROID) {
				androidGallery = new AndroidGallery(cb.Positive, cb.Negative);
			} else if defined(IOS) {
				iosGalery = new iOSGallery(cb.Positive, cb.Negative);
			}
		}

		public static Future<string> GetImages(object[] args)
		{
			InitPicker();

			if defined(ANDROID) {
				AndroidGallery gal = (AndroidGallery)androidGallery;
				gal.GetImages();
			} else if defined(IOS) {
				iOSGallery gal = (iOSGallery) iosGalery;
				gal.GetImages();
			}else {
				var cb = new ImagesCallback(promise);
				cb.Negative("platform not supported");
			}

			return promise;
		}

	}


	internal class ImagesCallback
	{
		Promise<string> _promise;

		public Action<string> Positive;

		public Action<string> Negative;

		public ImagesCallback(Promise<string> promise)
		{
			_promise = promise;

			Positive = (str) => _promise.Resolve(str);
			Negative = (str) => _promise.Reject(new Exception(str));
		}
	}
}