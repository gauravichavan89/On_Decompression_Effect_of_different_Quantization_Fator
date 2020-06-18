%% Note: Please change the value of L to get a different mean square error and 
%% the number of bytes received by the sever each time, which are dependent on the value of L
%% L factor which will consist of L*L 1's in the quantization matrix
% say here I enter L as 4; in the report I have copied all mean square
% errors, received bytes and resultant images in the report
L= 8;

% Reading the input image
I= imread('SampleImage.tif');

%% Stage 1 Compression - Performing DCT Transformation
I = im2double(I);
T = dctmtx(8);
dct = @(block_struct) T * block_struct.data * T';
B = blockproc(I,[8 8],dct);
mask = zeros(8,8);
mask(1:L,1:L) = 1;

%% Stage 2 Compression - Quantization    
I2 = blockproc(B,[8 8],@(block_struct) mask .* block_struct.data);

%% Stage 3 Compression - Perfroming zigzag scan
% Zig Zag scan does not itself do compression it just converts a matrix in
% a vector following a zig zag pattern; it is a prerequisite for Run Length
% Coding which does the actual compression and accepts this zig zag vector
% as its input
I3 = zigzag_scan(I2);

%% Stage 4 Compression - Applying RLC encoding
[d,c]=Run_Length_Coding(I3);
data = [d c];

%% The final Compressed Image which will be sent to the sever side 
s = whos('data')
s.size;
s.bytes;

%% Create the TCPIP connection with the server
tcpipClient = tcpip('localhost', 30000, 'NetworkRole', 'client');
set(tcpipClient, 'OutputBufferSize', s.bytes);
fopen(tcpipClient);
    fwrite(tcpipClient, data(:), 'double');
fclose(tcpipClient);

%% Function Definition of Run Length Coding

function [d,c]=Run_Length_Coding(input_vector);
% x is an input vector.
% element values are stored in 'd' vector while their number of apperance is in 'c' vector.
if nargin~=1
    error('A single 1-D stream must be used as an input')
end
ind=1;
d(ind)=input_vector(1);
c(ind)=1;
for i=2 :length(input_vector)
    if input_vector(i-1)==input_vector(i)
       c(ind)=c(ind)+1;
    else ind=ind+1;
         d(ind)=input_vector(i);
         c(ind)=1;
    end
end
end

function output = zigzag_scan(input_matrix)
% initializing the variables
h = 1;
v = 1;
vmin = 1;
hmin = 1;
vmax = size(input_matrix, 1);
hmax = size(input_matrix, 2);
i = 1;
output = zeros(1, vmax * hmax);
while ((v <= vmax) && (h <= hmax))
    % going up
    if (mod(h + v, 2) == 0)                 
        if (v == vmin)       
            % if we get to the first line
            output(i) = input_matrix(v, h);        
            if (h == hmax)
	      v = v + 1;
	    else
              h = h + 1;
            end
            i = i + 1;
        elseif ((h == hmax) && (v < vmax))  
            % if we got to the last column
            output(i) = input_matrix(v, h);
            v = v + 1;
            i = i + 1;
        elseif ((v > vmin) && (h < hmax))    
            % for all remaining cases
            output(i) = input_matrix(v, h);
            v = v - 1;
            h = h + 1;
            i = i + 1;
        end
        
    else
       % going down
       if ((v == vmax) && (h <= hmax))       
           % if we got to the last line
            output(i) = input_matrix(v, h);
            h = h + 1;
            i = i + 1;
        
       elseif (h == hmin)                   
           % if we got to the first column
            output(i) = input_matrix(v, h);
            if (v == vmax)
	      h = h + 1;
	    else
              v = v + 1;
            end
            i = i + 1;
       elseif ((v < vmax) && (h > hmin))     
           % all other cases
            output(i) = input_matrix(v, h);
            v = v + 1;
            h = h - 1;
            i = i + 1;
       end
    end
    if ((v == vmax) && (h == hmax))          
        % bottom right element
        output(i) = input_matrix(v, h);
        break
    end
end
end
