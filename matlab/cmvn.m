function F = cmvn(F)
% CMVN  Normalisation de la moyenne et de la variance cepstrales (document 02, section 7).
%   F = cmvn(F) : chaque colonne (chaque coefficient) est centrée et réduite
%   sur l'enregistrement. Retire l'effet du micro et du volume.

    F = (F - mean(F, 1)) ./ (std(F, 0, 1) + 1e-8);
end
