function [d,deltaT] = corr_fast_v5_westerberg(st1,st2,Ta,Tb,bin) %#codegen

% Ludicrous speed update - Westerberg JA (2022-09-30)

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

d1 = repmat(st1, 1, N2);
d2 = repmat(st2', N1, 1);

dmat = d2 - d1; dmat = dmat(:); clear d1 d2
imat = dmat >= Ta & dmat <= Tb;

[rind, cind] = ind2sub([N1, N2], find(imat));

deltaT = dmat(imat); clear dmat imat
deltaT = [deltaT rind]; clear rind
deltaT = [deltaT cind]; clear cind

edges = linspace(Ta,Tb,bin);
d = histc(deltaT(:,1),edges);

end