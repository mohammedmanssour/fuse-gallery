# FuseGallery
A Simple [fusetool](https://www.fusetools.com/) that lets you select multiple images from gallery

### Why Bother
the default behavior of `CameraRoll` package provided with FuseTools lets you select only one image from gallery without the ability to select multiple images. So accordingly we in [MissionX](https://missionx.co) decided to build a package to provide the ability to select multiple images from gallery

### Installation

1. git clone package to your app.
2. add reference to the package in your app `.unoproj` file like the following
```
{
  "RootNamespace":"co.missionx.someapp",
  .
  .
  .
  "Projects": [
    "Packages/fuse-gallery/src/fuse-gallery.unoproj"
  ]
}
```

### Usage

1. import Gallery in your app like `import Gallery from 'MissionFuse/Gallery'`
2. use `Gallery.getImages()` function to open gallery and select images. it will resolves with an array of images paths on success and it will reject with error otherwise