clear
clc

%% the edgeStruct
nNodes = 4;
nStates = 2;
adj = zeros(nNodes,nNodes);
adj(1,2) = 1;
adj(2,1) = 1;
adj(2,3) = 1;
adj(3,2) = 1;
adj(3,4) = 1;
adj(4,3) = 1;
edgeStruct = UGM_makeEdgeStruct(adj,nStates);

% edgeStruct.nStates
% edgeStruct.edgeEnds
% UGM_getEdges(3,edgeStruct)

%% the nodePot
% nodePot = [0.25 0.75; 0.9 0.1; 0.25 0.75; 0.9 0.1];
nodePot = [1 3; 9 1; 1 3; 9 1];

%% the edgePot
maxState = max(edgeStruct.nStates);
edgePot = zeros(maxState,maxState,edgeStruct.nEdges);
for e = 1:edgeStruct.nEdges
	edgePot(:,:,e) = [2 1; 1 2];
end

%% decoding
% find the most likely configuration, namely the row in the 'prodPot' columb that has the larget value
optimalDecoding = UGM_Decode_Exact(nodePot,edgePot,edgeStruct);

%% inference
% find the normalizing constant Z, as well as the marginal probabilities of indivdual nodes taking individual states
[nodeBel, edgeBel, logZ] = UGM_Infer_Exact(nodePot,edgePot,edgeStruct)

%% sampling
edgeStruct.maxIter = 100;
samples = UGM_Sample_Exact(nodePot,edgePot,edgeStruct);
imagesc(samples');
ylabel('Question');
xlabel('Student');