function h = bp_prj(filename)

%backprop try
%define input and desired out

load(filename);

epochs = 2500;
%cue = [0 1]; %exp
cue = [1 0]; %control
%x = [0 0; 0 1; 1 0; 1 1];

xo = input_o;
num_hid = 50;
%setup the input matrix 
%this is an srn with inputs(38), bias(1), cue unit(1) and context
%units with outputs from the hidden unit activations

%setup context and cue units
context = zeros(size(xo,1), num_hid);
context = [context(1,:)+0.5; context(2:end,:)];
cues = zeros(size(xo,1),2);


       %Cue units  Input  Context units  Bias
x = [ cue         xo      context        ones(size(xo,1),1)];

%the output should be a shifted version of the input since were
%doing prediction one time step ahead
Y = x;

%define # nodes in topology
num_input = size(x,2);
num_out = size(Y,2);

%setup random initial weights
W  = 0.1*(1-2*rand(num_input, num_hid)); %input to hidden weights
Wh = 0.1*(1-2*rand(num_hid+1, num_out)); %hidden to output weights


eta = 0.2;



for ep = 1:epochs
  deltaWbak = zeros(num_input, num_hid); %input to hidden weights
  deltaWhbak = zeros(num_hid+1, num_out); %hidden to output weights
  
  h_copy = zeros(1,num_hid)+0.5;
  for t = 1:size(x,1)-1 %present the data step wise
    
%    keyboard
  in = [ x(t,1:40) h_copy x(t,91)];  
  in_to_hid = in*W; %sum inputs into hidden units
  h = logsig(in_to_hid); %activate the input with a sigmoid
  h_copy = h; %save activations and copy to context for t+1   
  h_bias = [h 1]; %  add bias weights
 
%  keyboard
  %now compute the same for the output layer
  hid_to_out = h_bias*Wh;
  y = logsig(hid_to_out);

  
  %find error signal for backprop
  
  error_y =  (Y(t+1,:)-y);
  error_h = error_y*Wh'; 
  error_h(:,end) = [];%remove bias nodes
 
  
  deltaW  =  x(t,:)'*(error_h.*h.*(1-h));
  deltaWh =  h_bias'*(error_y.*y.*(1-y)); 

  deltaWbak = deltaWbak + deltaW;
  deltaWhbak = deltaWhbak + deltaWh;
  end
  
  
  W = W + eta*deltaWbak;
  Wh = Wh + eta*deltaWhbak;

end
%  disp(t)
x
h
y

W
Wh

keyboard
