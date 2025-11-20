function pearsonCorr = matrixCorr(Matrix1,Matrix2)

vector1 = squareform(tril(Matrix1,-1))';
vector2 = squareform(tril(Matrix2,-1))';

pearsonCorr = corr(vector1,vector2);

end