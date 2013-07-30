clear
clc
 
nNodes = 4;
adj = zeros(nNodes);
adj(1,2) = 1;
adj(2,3) = 1;
adj(3,4) = 1;
adj = adj+adj';
nStates = 2;
edgeStruct = UGM_makeEdgeStruct(adj,nStates);

%% make node potential
nodePot = [1 3
		   9 1
		   1 3
		   9 1];

%% make edge potential
edgePot = zeros(nStates,nStates,edgeStruct.nEdges);
edgePot(:,:,1) = [2 1
				  1 2];
edgePot(:,:,2) = [2 1
				  1 2];
edgePot(:,:,3) = [2 1
				  1 2];

%% make clamped vector
clamped = zeros(nNodes,1);
clamped(1) = 2;
clamped(3) = 2;

%% do conditional inference
[nodeBel,edgeBel,logZ] = UGM_Infer_Conditional(nodePot,edgePot,edgeStruct,clamped,@UGM_Infer_Exact);