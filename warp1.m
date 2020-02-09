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


final_output_inImg(1+abs(Min_y)+1:R2+abs(Min_y)+1,1:C2,:)=inImg1(1:R1,1:C1,:);
% mapping inImg1 into final_output_img




% G = interp2(X,Y,inImg2(:,:,1),XW,YW,'linear');

 for m = 1: R2
    for n= 1: C2
        
       
        
         tempXYZ = [n,m,1]*inv(H);
         new_coord = (tempXYZ/tempXYZ(3));
          final_r = ceil(new_coord(2));  
          
         final_R(m,:)= final_r;
%           save y coordinates after transfored by H matrix as a R2*1
%           vector
          final_c = ceil(new_coord(1)); 
        final_C(n,:)= final_c;
%           save x coordinates after transfored by H matrix as a C2*1
%           vector  
        
%         final_output_inImg(final_r+abs(Min_y)+1,final_c,:)= inImg2(m,n,:);
      
         
     end
 end
%  after I finished, I found I used the forward warping and had lots of
%  hole!!!!!!!!

mesh_R_warp = 1:Max_y;
mesh_C_warp = 1:Max_x;

[XW,YW]= meshgrid(mesh_C_warp,mesh_R_warp);
% setup a warped coordinates mapping for inImg2
G = interp2(inImg2(:,:,1),XW,YW);
% imshow(uint8(G));

for i = 1: Max_y
    for j= 1: Max_x
        
       
        temp_source_x_y =[j,i,1]*H;
        source_x_y = temp_source_x_y/temp_source_x_y(3);
        source_x_y = floor(source_x_y);
        cu = source_x_y(1);
        rv = source_x_y(2);
        Cu(j,:)=cu;        
        Rv(i,:)=rv;
        Min_cu =min(Cu);
        Max_cu =max(Cu);
        Min_rv =min(Rv);
        Max_rv =max(Rv);
       cu(find(cu<1))=1;
       cu(find(cu>C2))=C2;
       rv(find(rv<1))=1;
       rv(find(rv>R2))=R2;
         final_output_inImg(i,j,:)= inImg2(rv,cu,:);
    end
end

final_output_inImg(1+abs(Min_y)+1:R2+abs(Min_y)+1,1:C2,:)=inImg1(1:R1,1:C1,:);

 imshow(uint8(final_output_inImg));
end