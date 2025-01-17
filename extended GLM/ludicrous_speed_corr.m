function [d,deltaT] = ludicrous_speed_corr(st1,st2,Ta,Tb,bin,params) %#codegen

% Ludicrous speed update - Westerberg JA (2022-09-30)

% Tlist_pre : presynaptic spiking times
% Tlist_post : postsynaptic spiking times
% Ta : starting point of the histogram before the presynaptic onset
% Tb : ending interval

params.max_mem_util = 100;

edges = linspace(Ta,Tb,bin);

N1 = length(st1);
N2 = length(st2);

if N1 == 0 || N2 == 0
    d = [];
    deltaT = [];
    warning('No Spikes Present in one/both input vector(s)')
    return;
end

LAS = N1*N2/1000000000*8;
batch_size = LAS*2.5/params.max_mem_util;
batches = ceil(batch_size);

deltaT = [];
for ii = 1 : batches

    batch_val = ceil(N1/batches);
    batch_idx = batch_val*ii - batch_val + 1 : batch_val*ii;
    while batch_idx(end) > numel(st1)
        batch_idx = batch_idx(1:end-1);
    end
    Nbatch = numel(st1(batch_idx));
       
    d1 = repmat(st1(batch_idx), 1, N2);
    d2 = repmat(st2', Nbatch, 1);

    dmat = d2 - d1; dmat = dmat(:); clear d1 d2
    imat = dmat >= Ta & dmat <= Tb;

    [rind, cind] = ind2sub([Nbatch, N2], find(imat));

    deltaTt = dmat(imat); clear dmat imat
    deltaTt = [deltaTt rind+(batch_val*ii-batch_val)]; clear rind
    deltaTt = [deltaTt cind]; clear cind

    deltaT = [deltaT; deltaTt]; clear deltaTt

end

d = histc(deltaT(:,1),edges);

end