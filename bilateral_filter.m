%% Stephen Xu BME/ECE
% BME 544
% Farsiu

function filtered_image = bilateral_filter(image, k_size, sigma_d, sigma_r)
    if size(image, 3) == 3
        is_rgb = true;
    else
        is_rgb = false;
    end
    
    % pre-allocate
    N = size(image, 1); M = size(image, 2);
    if is_rgb
        filtered_image = zeros(N, M, 3);
    else
        filtered_image = zeros(N, M);
    end
    
    
    for i = 1:N
       for j = 1:M
           pixel_value = apply_window(...
               image, k_size, i, j, sigma_d, sigma_r, is_rgb);
           filtered_image(i, j, :) = pixel_value;
           % fprintf('%d, %d | ', i, j);
       end
    end
    
    filtered_image = uint8(filtered_image);
end

function pixel_value = apply_window(image, k_size, x, y, sigma_d, sigma_r, is_rgb)
    if is_rgb
        pixel_value = zeros(1, 3);
    else
        pixel_value = 0;
    end
    
    N = size(image, 1); M = size(image, 2);
    bound = ceil(k_size/2);
    total_weight = 0;
    
    % essentially loop through the kernel with respect to x,y
    for i = -bound : bound
       for j = -bound : bound 
          neigh_x = x + i;
          neigh_y = y + j;
          
          % check bounds, reflect if necessary
          if neigh_x > N
             neigh_x = neigh_x - N;
          elseif neigh_x <= 0
             neigh_x = abs(neigh_x) + 1; 
          end
          if neigh_y > M
             neigh_y = neigh_y - M;
          elseif neigh_y <= 0
             neigh_y = abs(neigh_y) + 1;
          end
          
          % range distance based on number of parameters
          % i don't like having these ifs in a loop, but w/e
          if is_rgb
              n_pixel = image(neigh_x, neigh_y, :); n_pixel = n_pixel(:);
              i_pixel = image(x, y, :); i_pixel = i_pixel(:);
              n_lab = rgb2lab([n_pixel(1), n_pixel(2), n_pixel(3)]);
              i_lab = rgb2lab([i_pixel(1), i_pixel(2), i_pixel(3)]);
              r_m = pdist([n_lab; i_lab], 'euclidean');
          else
              r_m = pdist([image(neigh_x, neigh_y); image(x, y)], 'euclidean');
          end
         
          % spatial distance
          d_m = pdist([neigh_x, neigh_y; x, y], 'euclidean');
          
          % casting because stupid
          d_m = single(d_m);
          r_m = single(r_m);
          sigma_d = single(sigma_d);
          sigma_r = single(sigma_r);
          
          % weight calculations
          g_d = normpdf(d_m, 0, sigma_d);
          g_r = normpdf(r_m, 0, sigma_r);
          
          pixel_weight = double(g_d .* g_r);
          total_weight = double(total_weight + pixel_weight);
          current_pixel = image(neigh_x, neigh_y, :); 
          current_pixel = current_pixel(:)';
         
          pixel_value(:) = double(pixel_value) + ...
              double(double(current_pixel) .* pixel_weight);
       end
    end
    
    pixel_value = uint8(pixel_value/total_weight);
end