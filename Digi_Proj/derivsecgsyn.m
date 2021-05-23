function dxdt = derivsecgsyn(t,x,flag,rr,sfint,ti,ai,bi)
    dxdt = derivsecgsyn(t,x,flag,rr,sfint,ti,ai,bi);
% ODE file for generating the synthetic ECG
% This file provides dxdt = F(t,x) taking input paramters: 
% rr: rr process 
% sfint: Internal sampling frequency [Hertz]
% Order of extrema: [P Q R S T]
% ti = angles of extrema [radians] 
% ai = z-position of extrema 
% bi = Gaussian width of peaks 
% Copyright (c) 2003 by Patrick McSharry & Gari Clifford, All Rights Reserved  
% See IEEE Transactions On Biomedical Engineering, 50(3), 289-294, March 2003.
% Contact P. McSharry (patrick AT mcsharry DOT net) or 
% G.D. Clifford (gari AT mit DOT edu)

%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
% 
% ecgsyn.m and its dependents are freely availble from Physionet - 
% http://www.physionet.org/ - please report any bugs to the authors above.

