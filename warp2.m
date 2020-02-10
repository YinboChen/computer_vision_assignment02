function [outImg] = warp2(H,inImg1,inImg2)
% 
% inverse warping
% 
 load('outputH.mat');
 H = outputH
 disp('outputH has been loaded!!!')
 Htest  =inv(H);
inImg1 = imread('Square0.jpg');
inImg2 = imread('Square1.jpg');
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
x_array =[x_inImg1(1),x_inImg1(1),x_inImg1(1),x_inImg1(C2),project_corner_inImg1(1,1),project_corner_inImg1(2,1),project_corner_inImg1(3,1),project_corner_inImg1(4,1)];
y_array =[y_inImg1(1),y_inImg1(1),y_inImg1(R2),y_inImg1(R2),project_corner_inImg1(1,2),project_corner_inImg1(2,2),project_corner_inImg1(3,2),project_corner_inImg1(4,2)];
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
project_corner_inImg1
project_corner_inImg2
%bounding box four corners

[X,Y] = meshgrid(x_inImg1,y_inImg1);
% setup a original coordinates mapping for inImg2


final_output_inImg(1+abs(Min_y)+1:R2+abs(Min_y)+1,1:C2,:)=inImg1(1:R2,1:C2,:);
% mapping inImg1 into final_output_img
% final_output_inImg()=inImg2(1:R2,1:C2,:);

mesh_R_warp = 1:Max_y-Min_y;
mesh_C_warp = 1:Max_x-Min_x;

[XW,YW]= meshgrid(mesh_C_warp,mesh_R_warp);
% setup a warped coordinates mapping for inImg2

% G = interp2(X,Y,inImg2(:,:,1),XW,YW,'linear');
 imshow(uint8(final_output_inImg));
 for m = 1: R1
    for n= 1: C1
        
         tempXYZ = [n,m,1]*(H);
         new_coord = (tempXYZ/tempXYZ(3));
         final_r = ceil(new_coord(2));  
%           save y coordinates after transfored by H matrix as a R2*1
%           vector
         final_c = round(new_coord(1)); 
%           save x coordinates after transfored by H matrix as a C2*1
%           vector          
         final_output_inImg(final_r+abs(Min_y)+1,final_c,:)= inImg1(m,n,:);
%          final_output_inImg(m+abs(Min_y)+1,n,:)=inImg1(m,n,:);
         
     end
 end
 

 imshow(uint8(final_output_inImg));
end