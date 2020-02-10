function[output] = getPoints(input_img1,input_img2)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW2 due 2/9 2020
% Purpose: For better understanding of image warping 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inImg1 = imread('Square0.jpg');
% inImg2 = imread('Square1.jpg');
inImg1 = input_img1;
inImg2 = input_img2;
% read two original images from local files
Temp1st = zeros(10,2);
% defined the first image's coordinates 10*2 matrix
Temp2nd = zeros(10,2);
% the 2nd image's coordinates 10*2 matrix

figure(1),imshow(inImg1),title('1st image');
% Performing the first image
for i = 1 :10
    [c1,r1] = ginput(1);
    Temp1st(i,:)= [r1,c1];
    display = [num2str(i),' times'];
%     display index of coordinate
    disp(display);
end
% use a loop to select 10 points one by one from the 1st image
% record into a 10*2 matrix - Temp1st

imshow(inImg2),title('2nd image');
% Performing the second image

for j = 1 :10
    [c2,r2] = ginput(1);
    Temp2nd(j,:)= [r2,c2];
    display = [num2str(j),' times'];
%     display index of coordinate
    disp(display);
end
% use a loop to select 10 points one by one from the 2nd image
% record into a 10*2 matrix - Temp2nd


output = [Temp1st,Temp2nd];
% combine twe matrix(Temp1st & Temp2nd) to a 10*4 matrix as an output
save('output.mat','output')
disp('Save output matrix to file output.mat!!!')
end