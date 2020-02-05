function[outputH]=computeH()
% 1. write an random func to retrieve four points' coordinates from getPoints(load)
% 2.built a matrix to compute H?9*1?
% 3.reshape H to(3*3)
% 4.compute the mini error using distance between two points|AB|=
% sqrt((x1-x2)^2+(y1-y2)^2)for 20 times
testImg = imread('Square0.jpg');
load('output.mat');
% [r,c,rp,cp]/compare[y x] each row
disp('Output matrix has been loaded!!!')
% Load the 10*4 points' coordinate matrix 
% size(output) %checkpoint
R = size(output,1);

compare_avg_error = 1000;
% defined a far more large value, then descent for finding the mini error
for i = 1:20
%     repeat 20 times for mini error and H values
B = randperm(R,4);
% generate 4(1*4) elements from 1 to 10(R) without same value 
r1 = output(B(1),1);
c1 = output(B(1),2);
rp1 = output(B(1),3);
cp1 = output(B(1),4);
% 1 corresponding point pairs
r2 = output(B(2),1);
c2 = output(B(2),2);
rp2 = output(B(2),3);
cp2 = output(B(2),4);
% 2 corresponding point pairs
r3 = output(B(3),1);
c3 = output(B(3),2);
rp3 = output(B(3),3);
cp3 = output(B(3),4);
% 3 corresponding point pairs
r4 = output(B(4),1);
c4 = output(B(4),2);
rp4 = output(B(4),3);
cp4 = output(B(4),4);
% 4 corresponding point pairs

A=[    
0  , 0 , 0 , c1 , r1 , 1 , -rp1*c1 , -rp1*r1 , -rp1;
c1 , r1, 1 ,  0 ,  0 , 0 , -cp1*c1 , -cp1*r1 , -cp1;
0  , 0 , 0 , c2 , r2 , 1 , -rp2*c2 , -rp2*r2 , -rp2;
c2 , r2, 1 ,  0 ,  0 , 0 , -cp2*c2 , -cp2*r2 , -cp2;
0  , 0 , 0 , c3 , r3 , 1 , -rp3*c3 , -rp3*r3 , -rp3;
c3 , r3, 1 ,  0 ,  0 , 0 , -cp3*c3 , -cp3*r3 , -cp3;
0  , 0 , 0 , c4 , r4 , 1 , -rp4*c4 , -rp4*r4 , -rp4;
c4 , r4, 1 ,  0 ,  0 , 0 , -cp4*c4 , -cp4*r4 , -cp4];
% Estimating a Homography
[U,S,V] = svd(A);
% Singular value decompositio
Htemp = V(:,end);
H = reshape(Htemp,[3,3]);
% compute H matrix
% temp =[c1 r1 1]*H
% p1 = temp /temp(3)
% P2 =[cp1 rp1 1]
% testing whether p1 equ p2 or not

distance = zeros(R,1);
%initial distance vector for compute the average repojection error
for j =1:R
%     project all points from 1 to R(10)
    project_temp = [output(j,2),output(j,1),1]*H;
    project_image = project_temp/project_temp(3);
    %divide 3rd value to get new coordinates[x,y,1]
    AB = sqrt((project_image(1)-output(j,4))^2+(project_image(2)-output(j,3))^2);
%     compute the distance between project points and expected points
    distance(j,:)= AB;
end
     avg_error = sum(distance)/size(distance,1);
%      compute the avg error value by comparing project points and expected points
          
      if compare_avg_error < avg_error 
%           save the mini avg error and H value
          outputH = H;
          output_error = compare_avg_error;
      else
          compare_avg_error = avg_error;
      end
      
end
   outputH
  Htest = outputH.*(1/outputH(9))
   output_error
    
end