%% Creating the TCPIP connection with the client 
tcpipServer = tcpip('0.0.0.0', 30000, 'NetworkRole', 'Server');
set(tcpipServer,'InputBufferSize',300000);
set(tcpipServer,'Timeout',5); 
fopen(tcpipServer);
get(tcpipServer, 'BytesAvailable');
tcpipServer.BytesAvailable; 
Received_Data =[];
pause(0.1);
 
%% Obtaining the received data from the client side 
while (get(tcpipServer, 'BytesAvailable') > 0) 
    
    tcpipServer.BytesAvailable;
    rawData = fread(tcpipServer,300000/8,'double');
    Received_Data = [Received_Data; rawData];
    pause(0.1);
    size(rawData,1); 
   
end

fclose(tcpipServer);
delete(tcpipServer); 
clear tcpipServer 

%% Adjustments done for inverse Run Length Coding
%% Dividing the receievd data in two vectors of similar required length
l = length(Received_Data);
reshapeddata= reshape(Received_Data,[l/2,2]);

% Seperating the data and value into seperate vectors
c = reshapeddata(:,1);
d = reshapeddata(:,2);

% Converting the column matrix into row vectors
c = c.';
d = d.';

%% Stage 1 - Decompression: Applying RLC dencoding
x=rlc_decoding(c,d);

%% Stage 2 - Decompression: Inverse zig zag scanning
I4 = inverse_zigzag_scan(x,256,256);
I4 = reshape(I4,256,256,1);

%% Stage 3: Decompression - Inverse DCT
T = dctmtx(8);
invdct = @(block_struct) T' * block_struct.data * T;
K = blockproc(I4,[8 8],invdct);

%% Reading the image before compression 
I = imread('SampleImage.tif');
[height,width,ch] = size(I);

%% Displaying the final decompressed image
class(K);
class(I);
I = double(I);
imshow(K)

%% Calculating mean-squared error between the image before compression(I) and
%% the one after decompression(K)
msq = immse(I, K);
fprintf('\n The mean-squared error is %0.4f\n', msq)

%% Function Defintion of Performing Inverse RLC
function x=rlc_decoding(d,c); 

if nargin<2
    error('not enough number of inputs')
end
x=[];
for i=1:length(d)
x=[x d(i)*ones(1,c(i))];
end
end

%% Function Definition of inverse zig zag
function out=inverse_zigzag_scan(input,rows_count,columns_count)

tot_elem=length(input);
if nargin>3
	error('Too many input arguments');
elseif nargin<3
	error('Too few input arguments');
end
if tot_elem~=rows_count*columns_count
	error('Matrix dimensions do not coincide');
end

% Initializing the output matrix that outputs matrix after inverse zig zag
out=zeros(rows_count,columns_count);
cur_row=1;	cur_col=1;	cur_index=1;

while cur_index<=tot_elem
	if cur_row==1 & mod(cur_row+cur_col,2)==0 & cur_col~=columns_count
        %move right at the top
		out(cur_row,cur_col)=input(cur_index);
		cur_col=cur_col+1;							
		cur_index=cur_index+1;
		
	elseif cur_row==rows_count & mod(cur_row+cur_col,2)~=0 & cur_col~=columns_count
        %move right at the bottom
		out(cur_row,cur_col)=input(cur_index);
		cur_col=cur_col+1;							
		cur_index=cur_index+1;
		
	elseif cur_col==1 & mod(cur_row+cur_col,2)~=0 & cur_row~=rows_count
        %move down at the left
		out(cur_row,cur_col)=input(cur_index);
		cur_row=cur_row+1;							
		cur_index=cur_index+1;
		
	elseif cur_col==columns_count & mod(cur_row+cur_col,2)==0 & cur_row~=rows_count
        %move down at the right
		out(cur_row,cur_col)=input(cur_index);
		cur_row=cur_row+1;							
		cur_index=cur_index+1;
		
	elseif cur_col~=1 & cur_row~=rows_count & mod(cur_row+cur_col,2)~=0
        %move diagonally left down
		out(cur_row,cur_col)=input(cur_index);
		cur_row=cur_row+1;		cur_col=cur_col-1;	
		cur_index=cur_index+1;
		
	elseif cur_row~=1 & cur_col~=columns_count & mod(cur_row+cur_col,2)==0
        %move diagonally right up
		out(cur_row,cur_col)=input(cur_index);
		cur_row=cur_row-1;		cur_col=cur_col+1;	
		cur_index=cur_index+1;
		
	elseif cur_index==tot_elem
        %input the bottom right element
        out(end)=input(end);							
		break										
    end
end
end