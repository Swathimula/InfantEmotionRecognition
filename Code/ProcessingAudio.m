clear all; clc;
format long;

current_folder = pwd;

import_folder = '/Users/swathi/Documents/Projects/2018_DataIncubator/Raw data';
export_folder = '/Users/swathi/Documents/Projects/2018_DataIncubator/Results/Figures';

cd(import_folder);

%%%%%Reading the audio signal
[Y,Fs] = audioread('babylaugh.wav');

%[Y,Fs] = audioread('babycry.wav');

T = 1/Fs*size(Y(:,1),1);%Seconds
dt = 1/Fs;
t = (1:size(Y(:,1),1))*dt;

y = sgolayfilt(Y(:,1),3,41);
return
%%Determining the admissibility constant of Morlet wavelet
fun =@(x) 2*pi^(0.5)*exp(-(2*pi*x - 6).^2)./x;
Cpsi = integral(fun,0,Inf);

for s = 1:1
%sig{1} = pprimeM2(:,i);
sig{1} = y(:,s);
sig{2} = dt; %%Sampling interval
    
%%%%%Wavelet tranform : Morlet wavelet
cwtS1 = cwtft(sig);

%%Scales of the signal 
%%Initial default spacing s0 = 2*dt
%%s = s0*2^((0:Nb-1)*ds))
%%ds = 0.4875
%%Nb = fix(log2(length(sig))/ds)+1 %%Number of scales
scales = cwtS1.scales;

%%%Wavelet Coefficients
Coef = cwtS1.cfs;

%%%Morlet Fourier frequency factor or the characteristic frequency
MFF = 4*pi/(6+sqrt(2+6^2));

%%%%%%Frequency in Hz
freq(:,s) = 1./(scales.*MFF); 

%%Wavelet energy density function
E = (Coef.*conj(Coef))/MFF/Cpsi;   

%%%%Wavelet Power spectra in frequency domain
PS(:,s) = sum(E,2)*dt/T/Cpsi;
end

return
figure;loglog(freq,(PS),'r')

cd(export_folder)

figure;hold on; contourf(t',(freq(:,1)),log10(E),5,'edgecolor','none');
set(gca, 'yscale','log'); colorbar; caxis([-4 -2]);
set(gca,'FontName','Times New Roman','FontSize',25);
set(gca, 'YTick', [1 10 100 1000 10000]);
set(gca, 'Xtick', [0 4 8 12 16 20]);
xlabel('Time (seconds)')
ylabel('Frequency (Hz)')
title('Laughing')
%savefig('Crying.fig')

cd(current_folder)