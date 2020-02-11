function[output] = frameImg(inImg1,inImg2)
%%%%%%%%%%%%%%%%%%%%%%%%%%
% CSCI 5722 Computer Vision
% Name: Yinbo Chen
% Professor: Ioana Fleming
% Assignment: HW2 due 2/9 2020
% Purpose: For better understanding of image warping 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inImg1= imread('becca.jpg');
% inImg2 = imread('billboard.jpg');
% imshow(inImg1);
% imshow(inImg2);
inImg1 = double(inImg1);
inImg2 = double(inImg2);

R = size(inImg1,1);
C = size(inImg1,2);

R2 = size(inImg2,1);
C2 = size(inImg2,2);

temp_getPoints = zeros(4,2);
% use temp_getpoints 4*2 (r,c) to save the ginputed points from inImg2
% order is upleft,upright,downleft and downright(1:4)
temp_four_corners = [
    1,1;
    1,C;
    R,1;
    R,C];
% use temp_fourcorner 4*2(r,c) to save the four corners coordinates of
% inImg1

figure(1),imshow(uint8(inImg2)),title('billboard image');
% Performing the billboard image
for i = 1 :4
    [c1,r1] = ginput(1);
    temp_getPoints(i,:)= [r1,c1];
    display = [num2str(i),' times'];
%     display index of coordinate
    compute_four_corners(i,:) =[temp_four_corners(i,2),temp_four_corners(i,1),1];
%     conv corners to [x,y,1] is a 4*3 dims matrix
    disp(display);
end
%  compute_four_corners;
output4 = [temp_getPoints,temp_four_corners];
% combine twe matrix(temp_getPoints & temp_four_corners) to a 4*4 matrix as an output
save('output4.mat','output4')
disp('Save output matrix 4*4 to file output4.mat!!!')
H4 = computeH4(output4);

for j = 1:4
    temp_compute_corners = compute_four_corners(j,:)*inv(H4);
    project_corners_inImg1(j,:) = round(temp_compute_corners/temp_compute_corners(3));
end
project_corners_inImg1
 project_x_array = min(project_corners_inImg1(:,1)):max(project_corners_inImg1(:,1));
  project_y_array = min(project_corners_inImg1(:,2)):max(project_corners_inImg1(:,2));
x_array =[compute_four_corners(1,1),compute_four_corners(2,1),compute_four_corners(3,1),compute_four_corners(4,1),project_corners_inImg1(1,1),project_corners_inImg1(2,1),project_corners_inImg1(3,1),project_corners_inImg1(4,1)];
y_array =[compute_four_corners(1,2),compute_four_corners(2,2),compute_four_corners(3,2),compute_four_corners(4,2),project_corners_inImg1(1,2),project_corners_inImg1(2,2),project_corners_inImg1(3,2),project_corners_inImg1(4,2)];
% save all 8 x and y coordinates in this array,and retrieve min, max(x &
% y)for bounding box
Min_x = min(x_array);
% this's the min C num from "blank final image"
Max_x = max(x_array);
% this's the max C num from "blank final image"
% final_C = abs(Min_x) + Max_x -1
% define the final C value
Min_y = min(y_array);
Max_y = max(y_array);
% same as C
final_R = abs(Min_y) + Max_y -1
% define the final R value
final_output_inImg = zeros(R2,C2,3);
imshow(final_output_inImg);
[X,Y]=meshgrid(1:C,1:R);
[wx,wy]=meshgrid(project_x_array,project_y_array);
[WX,WY]= meshgrid(Min_x:Max_x,Min_y:Max_y);
 
 G(:,:,1)=interp2(X,Y,inImg1(:,:,1),WX,WY,'linear');
 G(:,:,2)=interp2(X,Y,inImg1(:,:,2),WX,WY,'linear');
 G(:,:,3)=interp2(X,Y,inImg1(:,:,3),WX,WY,'linear');
imshow(uint8(G));
 GR = size(G,1);
 GC = size(G,2);

 for m = 1: R2
    for n= 1: C2
    
        temp_source_x_y =[n,m,1]*H4;
        source_x_y = temp_source_x_y/temp_source_x_y(3);
        source_x_y = floor(source_x_y);
        cu = source_x_y(1);
        rv = source_x_y(2);

        if cu < 1 || cu> GC || rv < 1 || rv > GR
            final_output_inImg(m,n,:) = inImg2(m,n,:);
        else
            
            final_output_inImg(m,n,:)= G(rv,cu,:);
            
        end
%         remove points coordinates which less than 1 and more than GC and
%         GR and replace with black (0).
    end
end
%    inImg2(1:GR,1:GC,:)= final_output_inImg(1:GR,1:GC,:);
subplot(1,3,1),imshow(uint8(inImg1)),title('The original first image')
subplot(1,3,2),imshow(uint8(inImg2)),title('The original second image')
subplot(1,3,3),imshow(uint8(final_output_inImg)),title('Frame Image');
figure,imshow(uint8(final_output_inImg)),title('Frame Image');



end