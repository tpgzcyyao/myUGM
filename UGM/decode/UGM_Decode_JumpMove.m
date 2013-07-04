function  [y] = UGM_Decode_JumpMove(nodePot, edgePot, edgeStruct, decodeFunc,y)
% INPUT
% nodePot(node,class)
% edgePot(class,class,edge) where e is referenced by V,E (must be the same
% between feature engine and inference engine)
%
% OUTPUT
% nodeLabel(node)

[nNodes,maxStates] = size(nodePot);
nEdges = size(edgePot,3);
edgeEnds = edgeStruct.edgeEnds;
V = edgeStruct.V;
E = edgeStruct.E;
nStates = edgeStruct.nStates;
maxState = max(nStates);

% Initialize
if nargin < 5
    [junk y] = max(nodePot,[],2);
end
UGM_ConfigurationPotential(y,nodePot,edgePot,edgeStruct.edgeEnds);

% Do Alpha-Expansions until convergence
while 1
    y_old = y;
    
    for k = [-maxState+1:-1 1:maxState-1]
        fprintf('Jumping by %d\n',k);
        modifiedNP = zeros(nNodes,2);
        for n = 1:nNodes
            modifiedNP(n,:) = [nodePot(n,y(n)) nodePot(n,mod(y(n)+k,maxState)+1)];
        end
        modifiedEP = zeros(2,2,nEdges);
        for e = 1:nEdges
            n1 = edgeEnds(e,1);
            n2 = edgeEnds(e,2);
            modifiedEP(:,:,e) = [edgePot(y(n1),y(n2),e) edgePot(y(n1),mod(y(n2)+k,maxState)+1,e)
                edgePot(mod(y(n1)+k,maxState)+1,y(n2),e) edgePot(mod(y(n1)+k,maxState)+1,mod(y(n2)+k,maxState)+1,e)];
        end
        modifiedEP
        modifiedES = edgeStruct;
        modifiedES.nStates(:) = 2;
        ytmp = decodeFunc(modifiedNP,modifiedEP,modifiedES);
        swapInd = find(ytmp == 2);
        y(swapInd) = mod(y(swapInd)+k,maxState)+1;
    end
    
    if all(y==y_old)
        break;
    end
end
