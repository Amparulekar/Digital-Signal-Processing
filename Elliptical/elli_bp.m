close all;clearvars;clc;
%Specifications
fp1 = 98;fs1 = 93;fs2 = 178;fp2 = 173;f_samp = 600;
B1=0.7118;W0=0.8478;
Ws=1.139;Wp=1;
Gp = 0.85;Gs = 0.15;
%Calculating N
ep = sqrt(1/Gp^2 - 1); es = sqrt(1/Gs^2 - 1);
k = Wp/Ws ;k1 = ep/es;
[K,Kp] = ellipk(k);[K1,K1p] = ellipk(k1);
Nexact = (K1p/K1)/(Kp/K);N = ceil(Nexact); 
%Elliptical approximation
Ap=1.4116;As=16.4782;
[z,p,H0,B,A] = ellipap2(N,Ap,As);
[y1,~] = size(B);
num = B(1,:);den = A(1,:);
if y1>1
    for i=2:y1
        num=conv(num,B(i,:));
        den=conv(den,A(i,:));
    end
end
syms s z;
%Analog LPF
analog_lpf(s) = poly2sym(num,s)/poly2sym(den,s);  
[ns, ds] = numden(analog_lpf(s));                                        
ns = sym2poly(expand(ns));
ds = sym2poly(expand(ds));                             
kd = ds(1);kn = ns(1);    
ds = ds/k;ns = ns/k;
fvtool(ns,ds,'Analysis','freq');                       
[zs,ps,]=tf2zp(ns,ds);
%Analog BPF
analog_bpf(s) = analog_lpf((B1*s)/(s*s + W0*W0));   
[nsb, dsb] = numden(analog_bpf(s));                                        
nsb = sym2poly(expand(nsb));
dsb = sym2poly(expand(dsb));                             
kd = dsb(1);kn = nsb(1);    
dsb = dsb/k;nsb = nsb/k;
fvtool(nsb,dsb,'Analysis','freq');                       
[zsb,psb,]=tf2zp(nsb,dsb);
k=kn/kd;
%Discrete BPF
discrete_bpf(z) = analog_bpf((z-1)/(z+1));              
[nz, dz] = numden(discrete_bpf(z));                                        
nz = sym2poly(expand(nz));
dz = sym2poly(expand(dz));                             
k = dz(1);    
dz = dz/k;nz = nz/k;
fvtool(nz,dz,'Analysis','freq');                       
[z,p,]=tf2zp(nz,dz);
%Pole zero plot
figure;
plot(real(p),imag(p),'rX');
hold on
plot(real(z),imag(z),'bO');
title("Poles and roots of the transfer function")
xlabel("Real")
ylabel("Imaginary")
axis equal
grid on
t = linspace(0,2*pi,1000);
hold on
plot(cos(t),sin(t),'b-') 
%Magnitude and phase plot
[H,f] = freqz(nz,dz,1024*1024, f_samp);
figure;
plot(f,abs(H),'LineWidth',1);
hold on;
title("Magnitude Response vs unnormalized frquency")
xlabel("1000 Hz")
ylabel("Response")
xline(fs1);xline(fp1);xline(fp2);xline(fs2);
yline(0.85);yline(0.15);
grid