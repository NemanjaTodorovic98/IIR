
b = [2 1 3];
a = [1 -0.75 0.5];
zeros = roots (b); 
poles = roots (a);
if abs (poles) < 1
	disp ('Stable');
else
	disp ('Unstable');
end

fs = 22050; %System sampling frequency
Ts = 1/fs; %System sampling period

%Signal details
f = [1000 0 0]; %Signal frequency
A = [1 0 0];  %Signal magnitude
phase = [0 0 0]; 
Tmax = 1 / min(f(f>0)); %Show 1 period of the slowest component in signal

%Quantization details
WordLength = 64;
FractionLength = 40;

struct.mode = 'fixed';
struct.roundmode = 'round';
struct.overflowmode = 'saturate';
struct.format = [WordLength FractionLength];
q = quantizer(struct);

N = 100;

for k = 1:N
    nT = k * Ts;
    SystemInput(k) = A(1) * sin(2*pi*f(1)*nT + phase(1)) + A(2) * sin(2*pi*f(2)*nT + phase(2)) + A(3) * sin(2*pi*f(3)*nT + phase(3)); % store it
end

SystemOutput = filter (b, a, quantize(q,SystemInput));

figure
stem (0: length(SystemOutput)-1, SystemOutput);

file = fopen('SystemInput.txt','w');
for i = 1 : length(SystemInput)
    fprintf(file,'%s\n',num2bin(q,SystemInput(i)));
end
fclose(file);

%Write output signal to file
file = fopen('SystemOutput.txt','w');
for i = 1 : length(SystemOutput)
    fprintf(file,'%s\n',num2bin(q,SystemOutput(i)));
end
fclose(file);

%Write filter order and coefficients of the filter
file = fopen('FilterParams.txt','w');
fprintf(file,'%d\n',FilterOrder);
fprintf(file,'\n');
fprintf(file,'%s\n',num2bin(q,a(1)));
for i = 2 : length(a)
    fprintf(file,'%s\n',num2bin(q,(-1)*a(i)));
end
fprintf(file,'\n');
for i = 1 : length(b)
    fprintf(file,'%s\n',num2bin(q,b(i)));
end
fclose(file);