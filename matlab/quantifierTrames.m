function seq = quantifierTrames(F, dictionnaire)
% QUANTIFIERTRAMES  Remplace chaque trame par le numéro du vecteur type le plus proche.
%   seq = quantifierTrames(F, dictionnaire)
%   F : une ligne par trame ; dictionnaire : M x D (sortie de kmeans)
%   seq : vecteur LIGNE d'entiers entre 1 et M (format attendu par hmmtrain et hmmdecode)

    seq = knnsearch(dictionnaire, F)';
end
