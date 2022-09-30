function [d,deltaT] = corr_fast_v4_westerberg(st1,st2,Ta,Tb) %#codegen

% Tlist_pre : presynaptic spiking times
% Tlist_post : postsynaptic spiking times
% Ta : starting point of the histogram before the presynaptic onset
% Tb : ending interval

N1 = length(st1);
N2 = length(st2);

if N1 == 0 || N2 == 0
    d = [];
    deltaT = [];
    warning('No Spikes Present in one/both input vector(s)')
    return;
end

deltaT = [];
for n = 1:N1

    timeDiff_2 = st2 - st1(n);
    deltaT = [deltaT; [timeDiff_2(timeDiff_2 <= Tb & timeDiff_2 >= Ta), ...
        repmat(n, numel(timeDiff_2(timeDiff_2 <=Tb & timeDiff_2 >= Ta)), 1), ...
        find(timeDiff_2 <= Tb & timeDiff_2 >= Ta)]];

end
edges = linspace(Ta,Tb,bin);
d = histc(deltaT(:,1),edges);

end