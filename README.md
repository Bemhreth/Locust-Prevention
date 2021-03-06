# LocVent
[![GitHub issues](https://img.shields.io/github/issues/Bemhreth/Locust-Prevention)](https://github.com/https://github.com/Bemhreth/Locust-Prevention/issues) 
[![GitHub forks](https://img.shields.io/github/forks/Bemhreth/Locust-Prevention)](https://github.com/https://github.com/Bemhreth/Locust-Prevention/network)
[![GitHub stars](https://img.shields.io/github/stars/Bemhreth/Locust-Prevention)](https://github.com/https://github.com/Bemhreth/Locust-Prevention/stargazers)


<p>
Locvent is a software that uses modern machine learning techniques and tools by leveraging TensorFlow and Google Cloud Platform to alert and prevent locust outbreak on different locations so that proactive measures could be taken and a comprehensive and coordinated early warning system could be established in the context of sustainable development.   
</p>

## Android Application

`Flutter application that helps in early detection of Locust outbreak.`

<p align="center">
<table border="1">
<tr><td><img src="Screenshot1.jpg" width="150" /></td>
<td><img src="Screenshot2.jpg" width="150" /></td>
<td><img src="Screenshot3.jpg" width="150" /></td>
<td><img src="Screenshot4.jpg" width="150" /></td>
<td><img src="Screenshot5.jpg" width="150" /></td></tr>
<tr>
<td><p align="center">Login</p></td>
<td><p align="center">sign up</p></td>
<td><p align="center">Taking picture of the locust</p></td>
<td><p align="center">Submiting the picture</p></td>
<td><p align="center">Viewing Result</p></td>
</tr>
</table></p>


* [X] Take a picture 
* [X] Submit picture
* [X] Get notified 


## Trained Model
<p>
  The Trained Model contains 2 models. <br/>
  
  - Classification of Locust Type <br/>
  - Surrounding Vegetation Satellite Image Analysis <br/>
  
Having these core functionality the trained model predicts next locust outbreak locations for proactive measures.
  
  - TensorFlow and Keras with Google Cloud Platform are the major technologies used here. 

</p>

## Web 

`The Web version of locvent is applicable for receiving locust outbreak notification and simply broadcasting the notification to the concern body accordingly.`

* [X] receive notification  
* [X] broadcast notification 

<img src="web/photo_2021-04-01_00-14-02.jpg" width="800" />

## How it works?

<p>
A user basically signs up to get started using locvent. Then a user logins into the application where there will be an authentication process to let the user use the application service. Next the user will take a photo using the camera and submits. On submission the image will be uploaded to Google Cloud Platform where the image uploaded gets classified based on the trained models. First classification will be the locust type followed by vegatation and predicts where the next outbreak will happen. Lastly, after the analysis is completed the user is notified of the catastrophic level of locust outbreak and whom to contact based on the specified location for an emergency and proactive measures. The concerned body will get a notification from the local user about the situation and act upon consequently. 
</p>

<p>
  Login/Register => Take Image => Submit => Classified on GCP => Report Result => Send Notification => Broadcast Notification
</p>

## Technologies Used 

<p>
  <img alt="HTML" src="https://img.shields.io/badge/HTML-E34F26?logo=html5&logoColor=white&style=for-the-badge"/>
  <img alt="CSS" src="https://img.shields.io/badge/CSS-1572B6?logo=css3&logoColor=white&style=for-the-badge"/>
  <img alt="JavaScript" src="https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=white&style=for-the-badge"/>
  <img alt="Node.js" src="https://img.shields.io/badge/Node.js-339933?logo=node.js&logoColor=white&style=for-the-badge"/>
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white&style=for-the-badge"/>
  <img alt="Google Cloud Platform" src="https://img.shields.io/badge/GoogleCloud-4285F4?logo=google-cloud&logoColor=white&style=for-the-badge"/>
  <img alt="Bootstrap4" src="https://img.shields.io/badge/Bootstrap-7952B3?logo=bootstrap&logoColor=white&style=for-the-badge"/>
  <img alt="TensorFlow" src="https://img.shields.io/badge/TensorFlow-FF6F00?logo=TensorFlow&logoColor=white&style=for-the-badge"/>

</p>


