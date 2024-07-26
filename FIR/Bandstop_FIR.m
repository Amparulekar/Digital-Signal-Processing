f_samp = 425e3;
fs1 = 92e3;
fp1 = 87e3;
fp2 = 137e3;
fs2 = 132e3;
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
end
N_min = ceil((A-7.95) / (2.285*2*0.0235*pi));       
n=N_min + 45 ;
bs_ideal =  ideal_lp(pi,n) -ideal_lp(0.63295*pi,n) + ideal_lp(0.42115*pi,n);
kaiser_win = (kaiser(n,beta))';
FIR_BandStop = bs_ideal .* kaiser_win;
[H,f] = freqz(FIR_BandStop,1,1024, f_samp);
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
fvtool(FIR_BandStop);