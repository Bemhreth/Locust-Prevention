


const express = require('express');
const fileUpload = require('express-fileupload');
const path = require('path');
const { google } = require('googleapis');
const app = express();
const { Readable } = require('stream');
const imageminJpegtran = require('imagemin-jpegtran');
const mongoose = require('mongoose')
const imageminPngquant = require('imagemin-pngquant');
const imageminMozjpeg = require('imagemin-mozjpeg');
const { loadFunc } = require('./drivecode')
const imagemin = require('imagemin')
const fs = require('fs')
const isJpg = require('is-jpg')
const sharp = require('sharp')
const tf = require('@tensorflow/tfjs')
const jpeg = require('jpeg-js')

const {user , report } = require('./schema')

const tfnode = require('@tensorflow/tfjs-node')
var getPixels = require('get-pixels') 
const   bodyParser = require('body-parser');

// support parsing of application/json type post data
app.use(bodyParser.json());

//support parsing of application/x-www-form-urlencoded post data
app.use(bodyParser.urlencoded({ extended: true }));

mongoose.connect('mongodb://localhost/testaa', {useNewUrlParser: true});



require('@tensorflow/tfjs-node')
//require('@tensorflow/tfjd-node-gpu')
app.use(fileUpload({
    useTempFiles : true,
    tempFileDir : path.join(__dirname,'tmp'),
}));


const modelpath = "file://model.json"
const imagepath = "/home/degagawolde/Locvest/upload/haaa.jpg"

async function convertModel(path){
    let model = await tf.loadLayersModel(path)
    return model
}



async function preprocess(img)
{

	const imageBuffer = fs.readFileSync(img)
    //convert the image data to a tensor 
   // let tensor = tf.from.Pixels(imageBuffer)
	let tensor = tfnode.node.decodeImage(imageBuffer , 3);    
//resize to 50 X 50
    const resized = tf.image.resizeBilinear(tensor, [32, 32]).toFloat()
    // Normalize the image 
    const offset = tf.scalar(255.0);
    const normalized = tf.scalar(1.0).sub(resized.div(offset));
    //We add a dimension to get a batch shape 
    const batched = normalized.expandDims(0)
   	
	 return batched
}



async function loadmodelt(){


const model1 = await tf.loadLayersModel(modelpath);
return model1





 // const handler = tfnode.io.fileSystem(modelpath);
   // const model = await tf.loadLayersModel(handler);
	
//	return model;
}

async function pread(){
	let imagepaths = "/home/degagawolde/Locvest/upload/haaa.jpg"
	let model = await loadmodelt()
	let img = await preprocess(imagepath)

	const pred = model.predict(img)

	console.log(pred)
}
pread()


function bufferToStream(binary) {

    const readableInstanceStream = new Readable({
            read() {
                    this.push(binary);
                    this.push(null);
            }
    });

    return readableInstanceStream;
}


const convertToJpg = async(input) => {

    if (isJpg(input)) {
            return input;
    }

    return sharp(input)
            .jpeg()
            .toBuffer();
};



app.post('/registeringinfo' , async ( req , res , next)=>{


    try
    {
        let userregister = new user({
            name : req.body.name,
            place : req.body.place,
            phone : req.body.phone,
        })
        
        const saved =  userregister.save();
        console.log("saved")
        res.send("saved success")
    }
    catch(err)
    {
        console.log(err)
        res.send("Error while saving")
    }


})


app.get('/', (req, res) => {
    res.send("Hello world");
});





app.post('/record' , async (req , res , next) => {
    try
    {
        let recordregister = new record({
            
            location : req.body.location,
            name : req.body.name,
            phone : req.body.phone,
            modeldata : data

        })
        
        const saved =  recordregister.save();
        console.log("saved")
        res.send("saved success")
    }
    catch(err)
    {
        console.log(err)
        res.send("Error while saving")
    }
})



const readFile = (name) => {
    return fs.readFileSync(name);
}

let load = async(name) => {
    let buffer = readFile(name)

    const miniBuffer = await imagemin.buffer(buffer, {
            plugins: [convertToJpg, imageminMozjpeg({ quality: 60 })]
    });
    return miniBuffer;

}


app.post('/uploadtodrive' , async  (req , res)=>{

    let drive = loadFunc()
    let FolderId = "1hVXE47fxTVUU9AuLo3znQRoHHy6I6noQ";
     async function uploadToFolder(auth) {
                                const drive = google.drive({ version: 'v3', auth })
                                // find the store here 
                                var folderId = FolderId;
                                var fileMetadata = {
                                        'name': 'photo.jpg',
                                        parents: [folderId]
                                };
                                //Use the name of the input field (i.e. "avatar") to retrieve the uploaded file
                                let avatar = req.files.file;
                                //Use the mv() method to place the file in upload directory (i.e. "uploads")
                                await avatar.mv('./uploads/' + avatar.name);

                                let data = await load('./uploads/' + avatar.name)



                                var media = {
                                        mimeType: 'image/jpeg',
                                        body: bufferToStream(data)
                                };

                                let file = await drive.files.create({
                                        resource: fileMetadata,
                                        media: media,
                                        fields: 'id'
                                });

                                return file.data.id
                        }
                        try{
                            let imageid = await uploadToFolder(drive);
                            //image uploaded
                            console.log("image uploaded")
                            console.log(imageid)
                        }
                        catch(err)
                        {
                            console.log(err)
                        }
                     

})
app.post('/uploadfile', (req, res) => {
    


    if (!req.files || Object.keys(req.files).length === 0) {
        return res.status(400).send('No files were uploaded.');
    }
    console.log(req.body)

    // Accessing the file by the <input> File name="target_file"
    let targetFile = req.files.file;
  

    //mv(path, CB function(err))
    targetFile.mv(path.join(__dirname + "/upload", targetFile.name), (err) => {
        if (err)
            return res.status(500).send(err);
        res.send('File uploaded!');
    });
  
});

app.get('/senddata' , function(req , res){

})


app.listen(3000, () => console.log('Your app listening on port 3000'));
