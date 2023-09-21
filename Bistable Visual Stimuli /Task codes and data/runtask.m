clear;
close all;
clc;

%% ///////////////////////////////////////////////////////////////// block1
%load('block15')
%%
block(30);

%fp2 failed 12/ o1  11   \ 27ki

function [] = block(n)


[bn1 , bn2 , bn3] = starttrial();

blocks = cat(2 , bn1 , bn2 , bn3 );

%
savename = sprintf('block%d.mat' , n);
save(savename,'blocks')   % save the combined vector out in test.mat

end