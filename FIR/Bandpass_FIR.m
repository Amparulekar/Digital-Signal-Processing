f_samp = 600e3;
fs1 = 93e3;
fp1 = 98e3;
fp2 = 173e3;
fs2 = 178e3;
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
end
N_min = ceil((A-8) / (2*2.285*0.016667*pi));  
n=N_min + 65;
bp_ideal = ideal_lp(0.58485*pi,n) - ideal_lp(0.31835*pi,n);
kaiser_win = (kaiser(n,beta))';
FIR_BandPass = bp_ideal .* kaiser_win;
[H,f] = freqz(FIR_BandPass,1,1024, f_samp);
hold on
plot(f,abs(H));
title('Magnitude Response on an unnormalized frequency scale');
xlabel('Frequency');
ylabel('Magnitude Response');
xline(fs1);
xline(fs2);
xline(fp1);
xline(fp2);
yline(0.85);
yline(0.15);
grid
hold off
fvtool(FIR_BandPass);