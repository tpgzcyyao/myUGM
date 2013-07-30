clear
clc

load('waterSystem2.mat'); %load adj
nNodes = length(adj);
nStates = 4;
edgeStruct = UGM_makeEdgeStruct(adj,nStates);
source = [1 6 7 8 11 12 15 17 19 20];

%% make node potential
nodePot = ones(nNodes,nStates);
nodePot(source,:) = repmat([0.9 0.09 0.009 0.001],length(source),1);

%% make edge potential
transition = [ 0.9890 0.0099 0.0010 0.0001
			   0.1309 0.8618 0.0066 0.0007
			   0.0420 0.0841 0.8682 0.0057
			   0.0667 0.0333 0.1667 0.7333];
colored = zeros(nNodes,1);
colored(source) = 1;
coloredEdges = zeros(edgeStruct.nEdges,1);
done = 0;
edgePot = zeros(nStates,nStates,edgeStruct.nEdges);
while ~done
	done = 1;
	colored_old = colored;

	for e = 1:edgeStruct.nEdges
		if sum(colored_old(edgeStruct.edgeEnds(e,:))) == 1
			% determine direction of edge and color nodes
			if colored(edgeStruct.edgeEnds(e,1)) == 1
				edgePot(:,:,e) = transition;
			else
				edgePot(:,:,e) = transition';
			end
			colored(edgeStruct.edgeEnds(e,:)) = 1;
			coloredEdges(e) = 1;
			done = 0;
		end
	end
end
for e = 1:edgeStruct.nEdges
	if coloredEdges(e) == 0
		edgePot(:,:,e) = (transition+transition')/2;
	end
end

%% inference (unconditional marginals for the first 20 nodes)
[nodeBel,edgeBel,logZ] = UGM_Infer_Tree(nodePot,edgePot,edgeStruct);

%% make clamped vector
clamped = zeros(nNodes,1);
clamped(300) = 4;
samples = UGM_Sample_Conditional(nodePot,edgePot,edgeStruct,clamped,@UGM_Sample_Tree);
figure;
imagesc(samples');
xlabel('Node');
ylabel('Sample');
colorbar;
[nodeBel,edgeBel,logZ] = UGM_Infer_Conditional(nodePot,edgePot,edgeStruct,clamped,@UGM_Infer_Tree);

