function [s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi)
    [s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi);
% Produces synthetic ECG with the following outputs:
% s: ECG (mV)
% ipeaks: labels for PQRST peaks: P(1), Q(2), R(3), S(4), T(5)
% A zero lablel is output otherwise ... use R=find(ipeaks==3); 
% to find the R peaks s(R), etc. 
% 
% Operation uses the following parameters (default values in []s):
% sfecg: ECG sampling frequency [256 Hertz]
% N: approximate number of heart beats [256]
% Anoise: Additive uniformly distributed measurement noise [0 mV]
% hrmean: Mean heart rate [60 beats per minute]
% hrstd: Standard deviation of heart rate [1 beat per minute]
% lfhfratio: LF/HF ratio [0.5]
% sfint: Internal sampling frequency [256 Hertz]
% Order of extrema: [P Q R S T]
% ti = angles of extrema [-70 -15 0 15 100] degrees
% ai = z-position of extrema [1.2 -5 30 -7.5 0.75]
% bi = Gaussian width of peaks [0.25 0.1 0.1 0.1 0.4]
% Copyright (c) 2003 by Patrick McSharry & Gari Clifford, All Rights Reserved  
% See IEEE Transactions On Biomedical Engineering, 50(3), 289-294, March 2003.
% Contact P. McSharry (patrick@mcsharry.net) or G. Clifford (gari@mit.edu)

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
