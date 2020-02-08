function [outImg] = warp1(H,inImg1,inImg2)
% 
% 
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
project_corner_inImg1
project_corner_inImg2
%bounding box four corners

[X,Y] = meshgrid(x_inImg2,y_inImg2);
% setup a original coordinates mapping for inImg2



 for m = 1: R2
    for n= 1: C2
        
         tempXYZ = [n,m,1]*inv(H);
         new_coord = (tempXYZ/tempXYZ(3));
          final_r = round(new_coord(2));
          final_c = round(new_coord(1));
%          final_output_inImg(m,n,:)= inImg1(m,n,:);
         final_output_inImg(m+abs(Min_y)+1,n,:)=inImg1(m,n,:);
         final_output_inImg(final_r+abs(Min_y)+1,final_c,:)= inImg2(m,n,:);
         
     end
 end




imshow(uint8(final_output_inImg));
end