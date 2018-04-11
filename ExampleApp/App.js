import Gallery from 'MissionFuse/Gallery';

export default class App{
    constructor(){
        this.images = [];
    }

    updateImages(images){
        this.images = images.slice();
    }

    get images_count(){
        return this.images.length;
    }

    async selectImages(){
        try{
            let response = await Gallery.getImages();

            this.updateImages( response.map( image => Object.assign({}, {url: image}) ) );
        }catch(err){
            console.log("getting error when trying to select images", err.toString());
        }
    }
}