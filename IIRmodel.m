fs = 22050; %System sampling frequency
Ts = 1/fs; %System sampling period

%Signal details
f = [1000 0 0]; %Signal frequency
A = [1 0 0];  %Signal magnitude
phase = [0 0 0]; 
Tmax = 1 / min(f(f>0)); %Show 1 period of the slowest component in signal

%Quantization details
WordLength = 32;
FractionLength = 20;

struct.mode = 'fixed';
struct.roundmode = 'round';
struct.overflowmode = 'saturate';
struct.format = [WordLength FractionLength];
q = quantizer(struct);

% nT = 0:Ts:Tmax; 
% 
% signal = A(1) * sin(2*pi*f(1)*nT + phase(1)) + A(2) * sin(2*pi*f(2)*nT + phase(2)) + A(3) * sin(2*pi*f(3)*nT + phase(3));

% figure
% stem(nT, signal)
% grid on
% xlabel('Time (sec)')
% ylabel('Amplitude')


%Filter details
fpass = 4000;
fstop = 5000;
ap = 1;
as = 40;

[FilterOrder, Wn] = cheb1ord(fpass/(fs/2), fstop/(fs/2), ap, as);
[b, a] = cheby1(FilterOrder, ap, Wn, 'low');

disp('Filter order:')
FilterOrder
disp('A coeff:')
a
disp('B coeff:')
b

freqz(b,a,1024,fs); %Magnitude and phase diagram

%Creation of discrete signal
N = 100; %Number of samples

for k = 1:N
    nT = k * Ts;
    SystemInput(k) = A(1) * sin(2*pi*f(1)*nT + phase(1)) + A(2) * sin(2*pi*f(2)*nT + phase(2)) + A(3) * sin(2*pi*f(3)*nT + phase(3)); % store it
end

%stem(1:1:N, SystemInput);
quantizedSystemInput = quantize(q,SystemInput);

%Generate system output based on previously defined filter
SystemOutput = filter(b,a,quantizedSystemInput);
%stem(1:1:N,SystemOutput);

% outputC = [3.55020645330171e-05 0.000516937376870753 0.00364214720111092 0.0165731190960907 0.0548299009772893 0.140694467855421 0.291534633464168 0.501210211815572 0.728822697011604 0.909668897541611 0.987105674272660 0.943497999862483 0.805027222413545 0.616061816526071 0.405868350664084 0.176819560348346 -0.0782702583558558 -0.350198135039838 -0.605908904323956 -0.805982163718807 -0.928085748492281 -0.973302367637865 -0.951979892548043 -0.866969219444199 -0.712624142768327 -0.489088581832247 -0.214810488871207 0.0767508300793976 0.352617494075878 0.592204549217674 0.785513248539641 0.923060561168128 0.990832578324884 0.976120452027714 0.877183607108801 0.705961046267425 0.481571387738408 0.222375693749209 -0.0553558072491780 -0.332882644002104 -0.586224482626205 -0.790278496048173 -0.926510390483471 -0.986772904724055 -0.970414709440125 -0.879342333417771 -0.717307532523958 -0.493934681749111 -0.227946245633689 0.0552860786483879 0.330399437435046 0.576938037187471 0.778898013608086 0.921543909810006 0.990928379052708 0.977925620282550 0.882971847191945 0.716575612300051 0.495113488174039 0.236209407849376 -0.0422427365434931 -0.320038492956887 -0.573831568054300 -0.780263139132130 -0.921184555579303 -0.986699959347779 -0.974133976872613 -0.885267327176097 -0.725462226332008 -0.505416475897760 -0.242770836373197 0.0393382022584656 0.316469759861418 0.566721132664093 0.771847186629712 0.916459050589355 0.988022555688668 0.978982436944018 0.889436330745311 0.727761711687031 0.508524510001996 0.249561851210905 -0.0295449360202562 -0.307489267077501 -0.561608500149307 -0.770079124041157 -0.915240510385960 -0.985944680546126 -0.977739869395633 -0.891779178791758 -0.734220041698637 -0.516676881865195 -0.256533543093744 0.0243336612704270 0.302391894721078 0.555339923069283 0.763706597820109 0.911327972813480 0.985948040755689 0.980661154216005];
% figure
% stem(1:1:N,outputC.')
% 
% figure
% stem(1:1:N,SystemOutput)

%Write quantized input signal to file
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


%Multiplier and adder test
fileOp1 = fopen('Operand1.txt','w');
fileOp2 = fopen('Operand2.txt','w');
fileResultMult = fopen('ResultMultiplication.txt','w');
fileResultAdd = fopen('ResultAddition.txt','w');

operand1 = [2 3.5 -10 22 -17 500 -1357 -17.849 3425 -54];
operand2 = [-8 18.37 5 -33 5 15 -23 68 -1.68954 1.98654 17];
for i = 1 : length(operand1)
    resultMult(i) = operand1(i) * operand2(i);
    resultAdd(i) = operand1(i) + operand2(i);
    fprintf(fileOp1,'%s\n',num2bin(q,operand1(i)));
    fprintf(fileOp2,'%s\n',num2bin(q,operand2(i)));
    fprintf(fileResultMult,'%s\n',num2bin(q,resultMult(i)));
    fprintf(fileResultAdd,'%s\n',num2bin(q,resultAdd(i)));
end
fclose(fileOp1);
fclose(fileOp2);
fclose(fileResultMult);
fclose(fileResultAdd);
