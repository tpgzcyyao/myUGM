clear
clc

nNodes = 60;
nStates = 7;

%% make adjacency matrix
adj = zeros(nNodes);
for i = 1:nNodes-1
	adj(i,i+1) = 1;
end
adj = adj+adj';

edgeStruct = UGM_makeEdgeStruct(adj,nStates);

%% make node potential
initial = [0.3 0.6 0.1 0 0 0 0];
nodePot = zeros(nNodes,nStates);
nodePot(1,:) = initial;
nodePot(2:end,:) = 1;

%% make edge potential
transitions = [0.08  0.9  0.01 0    0    0    0.01
			   0.03  0.95 0.01 0    0    0    0.01
			   0.06  0.06 0.75 0.05 0.05 0.02 0.01
			   0     0    0    0.3  0.6  0.09 0.01
               0     0    0    0.02 0.95 0.02 0.01
               0     0    0    0.01 0.01 0.97 0.01 
               0     0    0    0    0    0    1]; 
edgePot = repmat(transitions,[1 1 edgeStruct.nEdges]);

%% make clamped vector
clamped = zeros(nNodes,1);
clamped(10) = 6;

%% decode
optimalDecoding = UGM_Decode_Conditional(nodePot,edgePot,edgeStruct,clamped,@UGM_Decode_Tree);

%% inference
[nodeBel,edgeBel,logZ] = UGM_Infer_Conditional(nodePot,edgePot,edgeStruct,clamped,@UGM_Infer_Tree);
figure;
imagesc(nodeBel);
colorbar;

%% sampling
samples = UGM_Sample_Conditional(nodePot,edgePot,edgeStruct,clamped,@UGM_Sample_Tree);
figure;
imagesc(samples');
xlabel('Year after graduation');
ylabel('Graduate');
colorbar;