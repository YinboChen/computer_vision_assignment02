function [outImg] = warp1(inputH,input01,input02)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW2 due 2/9 2020
% Purpose: For better understanding of image warping 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  load('outputH.mat');
%   H = outputH
    H = inputH;
 disp('outputH has been loaded!!!')
 Htest  =inv(H);
%  inImg1 = imread('Square0.jpg');
%  inImg2 = imread('Square1.jpg');
%   inImg1 = imread('case1_1.jpg');
%   inImg2 = imread('case1_2.jpg');
   inImg1 = input01;
   inImg2 = input02;
inImg1 = double(inImg1);
inImg2 = double(inImg2);
R1 = size(inImg1,1);
C1 = size(inImg1,2);

R2 = size(inImg2,1);
C2 = size(inImg2,2);

x_inImg1 = 1:C1;
y_inImg1 = 1:R1;

x_inImg2 = 1:C2;
y_inImg2 = 1:R2;
% built vector x and y to save each coordinates


corner_inImg1 = [
    x_inImg1(1),y_inImg1(1),1;
    x_inImg1(C1),y_inImg1(1),1;
    x_inImg1(1),y_inImg1(R1),1;
    x_inImg1(C1),y_inImg1(R1),1];
% find 4 corners of inImg1,saved as a 4*3 matrix and each row notes as[x,y,1]
% [upleft;upright;downleft;downright]
corner_inImg2 = [
    x_inImg2(1),y_inImg2(1),1;
    x_inImg2(C2),y_inImg2(1),1;
    x_inImg2(1),y_inImg2(R2),1;
    x_inImg2(C2),y_inImg1(R2),1];
% find 4 corners of inImg2,saved as a 4*3 matrix and each row notes as[x,y,1]

for i = 1 : 4
    
      temp_inImg1 = corner_inImg1(i,:)*H;
      project_corner_inImg1(i,:) = round(temp_inImg1/temp_inImg1(3));
%       let z = 1
      temp_inImg2 = corner_inImg2(i,:)*inv(H);
%       Attention: from inImg2 project to inImg1 needs inverse H
      project_corner_inImg2(i,:) = round(temp_inImg2/temp_inImg2(3));
%       let z = 1     
end
x_array =[x_inImg2(1),x_inImg2(1),x_inImg2(1),x_inImg2(C2),project_corner_inImg2(1,1),project_corner_inImg2(2,1),project_corner_inImg2(3,1),project_corner_inImg2(4,1)];
y_array =[y_inImg2(1),y_inImg2(1),y_inImg2(R2),y_inImg1(R2),project_corner_inImg2(1,2),project_corner_inImg2(2,2),project_corner_inImg2(3,2),project_corner_inImg2(4,2)];
% save all 8 x and y coordinates in this array
Min_x = min(x_array);
% this's the min C num from "blank final image"
Max_x = max(x_array);
% this's the max C num from "blank final image"
final_C = abs(Min_x) + Max_x -1
% define the final C value
Min_y = min(y_array);
Max_y = max(y_array);
% same as C
final_R = abs(Min_y) + Max_y -1
% define the final R value

final_output_inImg = zeros(final_R,final_C,3);

% built a bounding box
project_corner_inImg1;
project_corner_inImg2;
%bounding box four corners

[X,Y] = meshgrid(x_inImg2,y_inImg2);
% setup a original coordinates mapping for inImg2


final_output_inImg(1+abs(Min_y)+1:R2+abs(Min_y)+1,1:C2,:)=inImg1(1:R1,1:C1,:);
% mapping inImg1 into final_output_img


 for m = 1: R2
    for n= 1: C2
 
         tempXYZ = [n,m,1]*inv(H);
         new_coord = (tempXYZ/tempXYZ(3));
           final_r = ceil(new_coord(2)); 
%           final_r = new_coord(2);
          
         final_R(m,:)= final_r;
%           save y coordinates after transfored by H matrix as a R2*1
%           vector
          final_c = ceil(new_coord(1)); 
%           final_c = new_coord(1); 
        final_C(n,:)= final_c;
%           save x coordinates after transfored by H matrix as a C2*1
%           vector    
   end
 end
%  after I finished, I found I used the forward warping and lots of
%  holes on the final output image!!!!!!!! For warning myself, I
%  decided to keep this loop block.

mesh_R_warp = Min_y:Max_y;
mesh_C_warp = Min_x:Max_x;

% [XW,YW]= meshgrid(final_C,final_R);
[XW,YW]= meshgrid(mesh_C_warp,mesh_R_warp);
% setup a warped coordinates mapping for inImg2
G1 = interp2(X,Y,inImg2(:,:,1),XW,YW,'linear');
G2 = interp2(X,Y,inImg2(:,:,2),XW,YW,'linear');
G3 = interp2(X,Y,inImg2(:,:,3),XW,YW,'linear');

G(:,:,1)=G1;
G(:,:,2)=G2;
G(:,:,3)=G3;

%  checkpoints 
% imshow(uint8(G));

for i = 1: Max_y
    for j= 1: Max_x
    
        temp_source_x_y =[j,i,1]*H;
        source_x_y = temp_source_x_y/temp_source_x_y(3);
        source_x_y = floor(source_x_y);
        cu = source_x_y(1);
        rv = source_x_y(2);
%         Cu(j,:)=cu;        
%         Rv(i,:)=rv;
%         Min_cu =min(Cu);
%         Max_cu =max(Cu);
%         Min_rv =min(Rv);
%         Max_rv =max(Rv);
%          cu(find(cu<1))= nan;
%          cu(find(cu>C2))=nan;
%          rv(find(rv<1))= nan;
%          rv(find(rv>R2))=nan;
        if cu < 1 || cu> C2 || rv < 1 || rv > R2
            final_output_inImg(i,j,:) = 0;
        else
            final_output_inImg(i,j,:)= G(rv,cu,:);
        end
%         remove points coordinates which less than 1 and more than C2 and
%         R2 and replace with black (0).
    end
end

final_output_inImg(1+abs(Min_y)+1:R2+abs(Min_y)+1,1:C2,:)=inImg1(1:R1,1:C1,:);
% adjust the first image's position in the final coordinate system
imshow(uint8(final_output_inImg));
outImg = uint8(final_output_inImg);
end