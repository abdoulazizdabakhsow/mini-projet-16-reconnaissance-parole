% EXP02_ROBUSTESSE_SNR  Accuracy en fonction du SNR, pour chaque type de bruit.
%   Conditions NON APPARIÉES : références propres, test bruité 
%   Le bruit est ajouté au clip complet AVANT toute la chaîne (VAD comprise).
%   Résultats : rapport/resultats/exp02_snr.mat et exp02_snr.png
%

cfg = configProjet();

refs = lireListe(fullfile(cfg.dossierListes, 'liste_references.txt'));
test = lireListe(fullfile(cfg.dossierListes, 'liste_test.txt'));
motsRef  = infoFichiers(refs);
motsTest = infoFichiers(test);
refsF = extraireListe(refs, cfg);            % références PROPRES

acc = zeros(numel(cfg.bruits), numel(cfg.snrs));
for ib = 1:numel(cfg.bruits)
    b = chargerBruit(cfg, cfg.bruits{ib});
    for is = 1:numel(cfg.snrs)
        rng(cfg.graine);                     % mêmes extraits de bruit pour chaque SNR
        preds = cell(numel(test), 1);
        for t = 1:numel(test)
            x = audioread(fullfile(cfg.racineDonnees, test{t}));
            x = ajouterBruit(x, b, cfg.snrs(is));
            preds{t} = classifierDTW(extraireCaracteristiques(x, cfg), refsF, motsRef);
        end
        acc(ib, is) = mean(strcmp(preds, motsTest));
        fprintf('%-16s SNR %4g dB : %.1f %%\n', cfg.bruits{ib}, cfg.snrs(is), 100*acc(ib, is));
    end
end

etiquettes = arrayfun(@num2str, cfg.snrs, 'UniformOutput', false);
etiquettes(isinf(cfg.snrs)) = {'propre'};
figure;
plot(1:numel(cfg.snrs), 100*acc', '-o', 'LineWidth', 1.5);
xticks(1:numel(cfg.snrs));  xticklabels(etiquettes);
xlabel('SNR (dB)');  ylabel('Accuracy (%)');  grid on;
legend(strrep(cfg.bruits, '_', ' '), 'Location', 'southwest');
title('DTW + MFCC : robustesse au bruit');

if ~isfolder(cfg.dossierResultats), mkdir(cfg.dossierResultats); end
save(fullfile(cfg.dossierResultats, 'exp02_snr.mat'), 'acc');
saveas(gcf, fullfile(cfg.dossierResultats, 'exp02_snr.png'));
