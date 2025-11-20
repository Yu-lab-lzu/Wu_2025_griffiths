function [FCmatrix] = extractMatrix(Bold_siganl,nNode)

Bold_siganl = squeeze(Bold_siganl);
if size(Bold_siganl,1) == nNode
    Bold_siganl = Bold_siganl';
end

FCmatrix = corr(Bold_siganl);

FCmatrix = FCmatrix - diag(diag(FCmatrix));

FCmatrix = abs(FCmatrix);