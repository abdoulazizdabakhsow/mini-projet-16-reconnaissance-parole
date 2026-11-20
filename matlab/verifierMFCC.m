% VERIFIERMFCC  Valide bancFiltresMel et mesMFCC contre les fonctions de MATLAB.

cfg = configProjet();
refs = lireListe(fullfile(cfg.dossierListes, 'liste_references.txt'));

% 1. Banc de filtres : le tien contre designAuditoryFilterBank
Hm = bancFiltresMel(cfg);
Hmat = designAuditoryFilterBank(cfg.fs, 'FFTLength', cfg.nfft, 'NumBands', cfg.nFiltres, ...
    'FrequencyScale', 'mel', 'FrequencyRange', [0 cfg.fs/2], 'Normalization', 'none');
f = (0:cfg.nfft/2) * cfg.fs / cfg.nfft;
figure;
subplot(2, 1, 1);  plot(f, Hm');    title('Mon banc de filtres Mel');  xlim([0 cfg.fs/2]);
subplot(2, 1, 2);  plot(f, Hmat');  title('designAuditoryFilterBank');  xlim([0 cfg.fs/2]);
xlabel('Fréquence (Hz)');
fprintf('Écart maximal entre les deux bancs : %.3f\n', max(abs(Hm(:) - Hmat(:))));

% 2. MFCC : les tiens contre mfcc avec les mêmes réglages
x = audioread(fullfile(cfg.racineDonnees, refs{1}));
y = pretraiter(x, cfg);
C = mesMFCC(y, cfg);
N = round(cfg.dureeTrame * cfg.fs);  H = round(cfg.pasTrame * cfg.fs);
[~, fBords] = bancFiltresMel(cfg);
Cm = mfcc(y, cfg.fs, 'Window', feval(cfg.fenetre, N, 'periodic'), 'OverlapLength', N - H, ...
    'FFTLength', cfg.nfft, 'BandEdges', fBords, 'NumCoeffs', cfg.nCoeffs, 'LogEnergy', 'Ignore');
K = min(size(C, 1), size(Cm, 1));
for k = 1:min(5, cfg.nCoeffs)
    r = corrcoef(C(1:K, k), Cm(1:K, k));
    fprintf('c%d : corrélation avec mfcc = %.3f\n', k - 1, r(1, 2));
end
figure;  plot([C(1:K, 2), Cm(1:K, 2)]);  legend('mesMFCC', 'mfcc');
title('Coefficient c1 trame par trame');  xlabel('Trame');
