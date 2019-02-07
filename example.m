%% Stephen Xu
% BME 544
clear all; close all;
%% testing with image
image = imread('cameraman.png');
image_c = imread('onion.png');
image = imbilatfilt(image,50,50);
filtered_image = bilateral_filter(image, 1, 18, 100);
filtered_image_c = bilateral_filter(image_c, 1, 18, 100);

%% plot the things
figure(1)
subplot(2,2,1);
imagesc(image);
colormap(gray);
title('Original')
axis equal tight

subplot(2,2,2);
imagesc(filtered_image);
colormap(gray);
title('Filtered (w=1,\sigma_d=10,\sigma_r=100)')
axis equal tight

subplot(2,2,3);
imagesc(image_c);
title('Original Color')
axis equal tight

subplot(2,2,4);
imagesc(filtered_image_c);
title('Filtered Color(w=1,\sigma_d=10,\sigma_r=100)')
axis equal tight