clc;
clear;
addpath('codes\')
input = imread('comparison_test/17.jpg'); 
output = underwater(input);
underwaterimage2(input);
figure,imshow(input), title('original image');
figure,imshow(output),title('enhanced image');