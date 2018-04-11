using Uno.Threading;
using Uno;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Uno.Permissions;
using Android;

using Fuse;
using Fuse.ImageTools;
using Fuse.Scripting;

namespace MissionFuse.Gallery
{
	[ForeignInclude(Language.Java,
								"com.fuse.Activity",
								"android.content.Intent",
								"android.content.ClipData",
								"android.net.Uri",
								"org.json.JSONArray",
								"java.util.ArrayList",
								"com.fusetools.camera.Image",
								"com.fusetools.camera.ImageStorageTools"
								)]
	public extern(Android) class AndroidGallery{

		public Action<string> onCompleteHandler;
		public Action<string> onFailureHandler;

		public AndroidGallery(Action<string> onComplete, Action<string>onFailure)
		{
			onCompleteHandler = onComplete;
			onFailureHandler = onFailure;
		}

		public void GetImages()
		{
			Permissions.Request(new PlatformPermission[] { Permissions.Android.WRITE_EXTERNAL_STORAGE, Permissions.Android.READ_EXTERNAL_STORAGE })
						.Then(OnPermissions, OnRejected);
		}

		void OnPermissions(PlatformPermission[] grantedPermissions)
		{
			if(grantedPermissions.Length != 2)
			{
				onFailureHandler("Permission was not granted");

			}else{

				var intent = CreateIntent();
				if(intent==null){
					onFailureHandler("Couldn't create valid intent");

				}else{
					ActivityUtils.StartActivity(intent, OnActivityResult);
				}

			}
		}

		void OnRejected(Exception e)
		{
			onFailureHandler(e.Message);
		}

		public void OnActivityResult(int resultCode, Java.Object intent, object info)
		{
			HandleIntent(resultCode, intent, onCompleteHandler, onFailureHandler);
		}

		[Foreign(Language.Java)]
		public Java.Object CreateIntent()
		@{
			Intent intent = new Intent();
			intent.setType("image/*");
			intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
			intent.setAction(Intent.ACTION_GET_CONTENT);

			return intent;
		@}

		[Foreign(Language.Java)]
		public void HandleIntent(int resultCode, Java.Object intent, Action<string> onComplete, Action<string> onFailure)
		@{
			if(intent != null){

				Intent i = (Intent)intent;
				if(resultCode == android.app.Activity.RESULT_OK){
					JSONArray paths = new JSONArray();
					if(i.getData() != null)
					{

						Uri mUri = i.getData();
						String filePath = @{AndroidGallery:Of(_this).getFilePath(Java.Object):Call(mUri)};
						paths.put(filePath);
						onComplete.run(paths.toString());
					}else if(i.getClipData()!=null)
					{

						ClipData mClipData = i.getClipData();
						ArrayList<Uri> mArrayUri=new ArrayList<Uri>();
						for(int j=0; j<mClipData.getItemCount(); j++){

							ClipData.Item item = mClipData.getItemAt(j);
							Uri uri = item.getUri();

							String filePath = @{AndroidGallery:Of(_this).getFilePath(Java.Object):Call(uri)};
							paths.put(filePath);
						}
						onComplete.run(paths.toString());
					}


				}else if(resultCode == android.app.Activity.RESULT_CANCELED){
					onFailure.run("got canceled by user");
				}
			}else{
				onFailure.run("some error happened that made data equals to null");
			}

		@}

		[Foreign(Language.Java)]
		public string getFilePath(Java.Object imageUri)
		@{
			String filePath = "";
			Uri mImageUri = (Uri)imageUri;
			try {
				Image scratch = ImageStorageTools.createScratchFromUri(mImageUri);
				String ext = scratch.getExtension().toLowerCase();
				if(ext.equals("jpg") || ext.equals("jpeg") || ext.equals("raw"))
					scratch.correctOrientationFromExif();

				filePath = scratch.getFilePath();

			} catch (Exception e) {

			}

			return filePath;
		@}
	}
}