clear
clc

nNodes = 60;
nStates = 7;
adj = zeros(nNodes);
for i = 1:nNodes-1
	adj(i,i+1) = 1;
end
adj = adj+adj';
edgeStruct = UGM_makeEdgeStruct(adj,nStates);

drawNetwork(adj);

%% make nodePot 
initial = [0.3 0.6 0.1 0 0 0 0];
nodePot = zeros(nNodes,nStates);
nodePot(1,:) = initial;
nodePot(2:end,:) = 1;

%% make edgePot 
transitions = [.08 .9 .01 0 0 0 .01
			   .03 .95 .01 0 0 0 .01
			   .06 .06 .75 .05 .05 .02 .01
			   0 0 0 .3 .6 .09 .01
               0 0 0 .02 .95 .02 .01
               0 0 0 .01 .01 .97 .01 
               0 0 0 0 0 0 1];             
edgePot = repmat(transitions,[1 1 edgeStruct.nEdges]);

%% decoding
optimalDecoding = UGM_Decode_Chain(nodePot,edgePot,edgeStruct);

%% inference
[nodeBel,edgeBel,logZ] = UGM_Infer_Chain(nodePot,edgePot,edgeStruct);
figure;
imagesc(nodeBel);
colorbar;

%% sampling
edgeStruct.macIter = 100;
samples = UGM_Sample_Chain(nodePot,edgePot,edgeStruct);
figure
imagesc(samples');
xlabel('Year after graduation');
ylabel('Graduate');
colorbar;