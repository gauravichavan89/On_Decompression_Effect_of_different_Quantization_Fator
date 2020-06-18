# Decompression Effect of different Quantization Fator 'L' on an image compared to the ones before Compression Techniques (DCT, quantization, RLC)


Analyzing the results demonstrated by the images after decompression on applying different values of quantization factor ‘L’ and comparing them to the original images before compression. Using a client-server setup compression techniques (DCT, quantization, RLC) are performed at the client side, then a compressed image is sent to server through TCP-IP and finally decompression is performed on the server side.

Through this short assignment, I intend to compress the image at the client side and send it to the server
side for decompression, mean square error evaluation, displaying decompressed image and
computing received bytes.


##  Getting Started


The following instructions shall ensure that the assignment is up and running on your local
machine for testing purposes. See ‘Running the tests’ section to know how to run the assignment.


## Prerequisites Software Required


MATLAB (R2018b 64 bit) for Windows 10 as IDE
For testing the output: Two instances of MATLAB on a single stand alone system(one for client
and another for sever are needed)


## Installation


[1] Follow https://www.mathworks.com/downloads/ for downloading MATLAB R2018b for
Windows Installer.


## Running the tests


Upon launching the matlab application, copy paste the code from server_code.m and
client_code.m files and save it on your local machine. Both these files are provided in the zip file
of the submitted assignment. Now run the server_code.m file first in one MATLAB instance
and client_code.m file in another MATLAB instance.


## Expected results to be checked


After running server_code.m followed by client_code.m, wait for a few seconds until you see the
printed mean square error in the console and the decompressed image at the server side. You
may see how many bytes were transferred after compression in the client side as I had written
that section of the code there.


Important Note: There is a global variable ‘L’ which has been declared for the quantization
factor in the client_code.m. you may have to assign it any value from 1 to 8 to see the changes
each time. I have saved the decompressed images in the
‘ Received_Images_for_all_L_Values’ folder. You may check that if you do not wish to check for all values of ‘L’.


## Please Note


* Since the image file is in the same directory as the server_code.m and client_code files I did
not have to separately specify the directory; and just entered the image name in the program; you
may do the same.
* I have written a few comments in my program to help you understand the written code.


## Documents included in this repository


* Received_Images_for_all_L_Values is a folder that has the decompressed images from L=1
to L=8.
* Received_Images_for_all_L_Values is a folder that has the graphs and table demonstrating
the relation between the ‘L Factor’, ‘Mean square Error’ and the ‘Received Bytes at the server
side’
* This README file for clear instructions on how to execute the code to get the desired
results.
* A report that explains the workflow and functional operations of the program in details.
* sever_code.m file and client_code.m program files
* The input image SampleImage.tiff


## Acknowledgements


[1] MATLAB Documentation: https://www.mathworks.com/help/
I have taken clues from mathworks documentation and have reconstructed the code to suit the
requirements of the question
