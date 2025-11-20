function  HRF=HRFunction()  %血氧动力学函数

dt = 0.009;
t = 0:dt:dt*1000;
o = 0; 
d = 0.6;
p = 3;

g = (t-o)./d;

HRF = (g.^(2)) .* (( (exp(-1.*g)) ./ (d.*factorial(p-1)) ).^(p-1)) ;%阶乘函数是factorial，

end