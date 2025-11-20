function par_coe=participation_coefficient(matrix,module)
%% module :  cell for each cluster 
    for iNode = 1:size(matrix,1)
        ipar=0;
        for icluster = 1:size(module,2)
            kis = sum(matrix(iNode,module{icluster}));% connect in module
            ki = sum(matrix(iNode,:));
            ipar=ipar + (kis/ki).^2;
        end
        par_coe(iNode) = 1-ipar;
    end
end