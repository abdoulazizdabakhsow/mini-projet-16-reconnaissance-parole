% FIGURESSIGNAL  Spectrogrammes de mots proches pour le rapport.
%   Produit rapport/resultats/spectrogrammes_mots_proches.png

cfg = configProjet();
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
motsTest = infoFichiers(test);
paires = {'on', 'off', 'no', 'go'};
N = round(cfg.dureeTrame * cfg.fs);  H = round(cfg.pasTrame * cfg.fs);

figure('Position', [100 100 900 600]);
for k = 1:numel(paires)
    i = find(strcmp(motsTest, paires{k}), 1);        % premier fichier de ce mot
    x = audioread(fullfile(cfg.racineDonnees, test{i}));
    subplot(2, 2, k);
    spectrogram(x(:, 1), feval(cfg.fenetre, N), N - H, cfg.nfft, cfg.fs, 'yaxis');
    title(sprintf('« %s »', paires{k}));
    colormap(flipud(gray));
end
if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
saveas(gcf, fullfile(cfg.dossierResultats, 'spectrogrammes_mots_proches.png'));
