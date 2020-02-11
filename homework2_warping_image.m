% This script creates a menu driven application

%%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW2 due 2/9 2020
% Purpose: For better understanding of image warping 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

% Display a menu and get a choice
choice = menu('Choose an option', 'Exit Program', 'Load First Image','Load Second Image','Display images','Load H_homography');  
% as you develop functions, add buttons for them here
 
% Choice 1 is to exit the program
while choice ~= 1
   switch choice
       case 0
           disp('Error - please choose one of the options.')
           % Display a menu and get a choice
           choice = menu('Choose an option', 'Exit Program', 'Load First Image','Load Second Image','Display images'...
               ,'Load H_homography','Image Mosaics','frameImg');  % as you develop functions, add buttons for them here
        case 2
           % Load the first image
           image_choice = menu('Choose an image', 'Square0', 'case1_1', 'case2_1','becca');
           switch image_choice
               case 1
                   filename = 'Square0.jpg';
               case 2
                   filename = 'case1_1.jpg';
               case 3
                   filename = 'case2_1.jpg';
               case 4
                   filename = 'becca.jpg';
               
               % fill in cases for the first image which you want to use
           end
           inImg1 = imread(filename);
           
           case 3
           % Load the second image
           image_choice = menu('Choose an image', 'Square1', 'case1_2', 'case2_2','billboard');
           switch image_choice
               case 1
                   filename = 'Square1.jpg';
               case 2
                   filename = 'case1_2.jpg';
               case 3
                   filename = 'case2_2.jpg';
               case 4
                   filename = 'billboard.jpg';
               
               % fill in cases for the second images you plan to use
           end
           inImg2 = imread(filename);
       case 4
           % Display image
           figure
           imagesc(inImg1);
           if size(inImg1,3) == 1
               colormap gray
           end
           figure
           imagesc(inImg2);
           if size(inImg2,3) == 1
               colormap gray
           end
           
           
       case 5
           load('outputH.mat');
            H = outputH
            disp('outputH has been loaded!!!')
%           Load the existed homography matrix and named as H
            flag = 1;
%            To judge whether the H have ready had or not,if exsited than
%            pass getpoints and computH function
          
           
              
       case 6
%            Processeing Image Mosaics
            if flag == 1
                mosaicsed_output_image = warp1(H,inImg1,inImg2);
                flage =0;
                figure,
                subplot(1,3,1),imshow(inImg1),title('The original first image')
                subplot(1,3,2),imshow(inImg2),title('The original second image')
                subplot(1,3,3),imshow(mosaicsed_output_image),title('mosaicsed image');
            else
                
            getPoints(inImg1,inImg2);
%             run getPoints function to get cooresponding point pairs 
            H = computeH();
%             To compute the homography by two input images(inImg1 and inImg2)
    
            mosaicsed_output_image = warp1(H,inImg1,inImg2);
            figure,
            subplot(1,3,1),imshow(inImg1),title('The original first image')
            subplot(1,3,2),imshow(inImg2),title('The original second image')
            subplot(1,3,3),imshow(mosaicsed_output_image),title('mosaicsed image');
            end
            
       case 7
%            Warp one image into a "frame" region in the second image
            frameImg(inImg1,inImg2);
            

            
           

   end
   % Display menu again and get user's choice
%    choice = menu('Choose an option', 'Exit Program', 'Load Image', ...
%     'Display Image', 'Mean Filter');  % as you develop functions, add buttons for them here
    choice = menu('Choose an option', 'Exit Program', 'Load First Image','Load Second Image','Display images'...
               ,'Load H_homography','Image Mosaics','frameImg');  % as you develop functions, add buttons for them here
end
  