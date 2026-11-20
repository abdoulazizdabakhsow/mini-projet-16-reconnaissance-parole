function [C, fbank] = mesMFCC(x, cfg)
% MESMFCC  MFCC calculés « à la main » (étape A8, document 02, sections 3 à 5).
%   [C, fbank] = mesMFCC(x, cfg)
%   x     : signal prétraité (sortie de pretraiter)
%   C     : MFCC, matrice K x cfg.nCoeffs, UNE LIGNE PAR TRAME (comme la fonction mfcc)
%   fbank : log-énergies des filtres Mel (FBANK), matrice K x cfg.nFiltres

    N = round(cfg.dureeTrame * cfg.fs);
    H = round(cfg.pasTrame * cfg.fs);

    T = decouperTrames(x, N, H);                     % N x K
    w = feval(cfg.fenetre, N, 'periodic');           % fenêtre de Hamming (ou Hann)
    X = fft(T .* w, cfg.nfft);                       % FFT de chaque colonne (complétée par des zéros)
    P = abs(X(1:cfg.nfft/2 + 1, :)).^2 / cfg.nfft;   % spectre de puissance, 257 x K

    Hm = bancFiltresMel(cfg);                        % M x 257
    S = Hm * P;                                      % énergie de chaque filtre, M x K
    fbank = log(S + 1e-10)';                         % logarithme -> FBANK, K x M

    Cfull = dct(fbank')';                            % DCT de type II (normalisée) sur les M filtres
    C = Cfull(:, 1:cfg.nCoeffs);                     % on garde les 13 premiers coefficients
end
