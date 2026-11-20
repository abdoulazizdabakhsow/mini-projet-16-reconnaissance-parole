function F = extraireCaracteristiques(x, cfg)
% EXTRAIRECARACTERISTIQUES  Signal brut -> matrice de caractéristiques (une ligne par trame).
%   F = extraireCaracteristiques(x, cfg)
%

    x = x(:, 1);
    x = x - mean(x);

    % VAD provisoire : on garde de la première à la dernière zone de parole
    idx = detectSpeech(x, cfg.fs);
    if ~isempty(idx)
        xc = x(idx(1,1) : idx(end,2));
        if numel(xc) >= 0.05 * cfg.fs        % garde-fou : au moins 50 ms
            x = xc;
        end
    end

    x = filter([1 -0.97], 1, x);                         % préaccentuation
    [c, d] = mfcc(x, cfg.fs, ...
        'Window', hamming(round(0.025*cfg.fs), 'periodic'), ...   % trames de 25 ms
        'OverlapLength', round(0.015*cfg.fs), ...                 % pas de 10 ms
        'NumCoeffs', 13, ...
        'LogEnergy', 'Ignore');
    F = [c, d];                                          % MFCC + deltas
    F = (F - mean(F, 1)) ./ (std(F, 0, 1) + 1e-8);      % CMVN
end
