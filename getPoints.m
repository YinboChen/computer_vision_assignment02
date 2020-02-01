function[output] = getPoints()

inImg1 = imread('Square0.jpg');
inImg2 = imread('Square1.jpg');
% read two original images from local files
Temp1st = zeros(10,2);
% defined the first image's coordinates 10*2 matrix
Temp2nd = zeros(10,2);
% the 2nd image's coordinates 10*2 matrix

figure(1),imshow(inImg1),title('1st image');

for i = 1 :10
    [c1,r1] = ginput(1);
    Temp1st(i,:)= [r1,c1];
    display = [num2str(i),'times'];
%     display index of coordinate
    disp(display);
end
% use a loop to select 10 points one by one
Temp1st


imshow(inImg2),title('2nd image');
% shows two images with both axes

for j = 1 :10
    [c2,r2] = ginput(1);
    Temp2nd(j,:)= [r2,c2];
    display = [num2str(j),'times'];
%     display index of coordinate
    disp(display);
end

Temp2nd
for m =1:10
    output(m,:)
end
output
end