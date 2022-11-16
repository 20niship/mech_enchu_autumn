function [ad, bd] = myc2d(a, b, t)
%%% Conversion of state space models from continuous to discrete time. 
%%% [Ad, Bd] = MYC2D(A,B,T)
%%% converts the continuous-time system : x = Ax + Bu 
%%% to the discrete-time state-space system : x[n+1] = Ad*x[n] + Bd*u[n] 
%%% assuming a zero-order hold on the inputs and sample time T. 
%%% See also: MYC2DM. 
%%%
%%% Date : 2011/10/05
%%% Author : yusuke GOUTSU

error(nargchk(3,3,nargin));
error(myabcdchk(a, b));

[m,n] = size(a);
[m,nb] = size(b);
s = expm([[a b]*t; zeros(nb,n+nb)]);
ad = s(1:n,1:n);
bd = s(1:n,n+1:n+nb);

%nargin
%a
%b
%s