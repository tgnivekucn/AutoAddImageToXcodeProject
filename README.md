# AutoAddImageToXcodeProject
## Auto add images with different resolutions to your project without drag many times!!!

## Usage:
* Step 1: Choose the parent  directory of 1x 2x 3x image folders
* Step 2: Choose the directory of Assets.xcassets in your project
* Step 3: Press "execute" button, auto add images to your project 

##  Restrict:

1. Your 1x 2x 3x images at "1x","2x","3x" folders

2. Your image's filename format should follow the naming rule described below: 
- The format of a image is "png", and "1x","2x","3x" are after '@' character,
such as:
* testImage@1x.png
* testImage@2x.png
* testImage@3x.png

3. The content of your "Contents.json" at "Assets.xcassets" is:
<pre><code>
{
     "info" : {
      "version" : 1,
      "author" : "xcode"
     }
}
</code></pre>

note: If the content of your "Contents.json" is not the same as describe above,
you can change corresponding code in "Contants.swift". Then you can use this
app to add images to your project


## License

This project is distributed under the terms and conditions of the Apache License, Version 2.0         
