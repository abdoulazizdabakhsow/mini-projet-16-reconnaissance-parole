# Mini-projet 16 : reconnaissance automatique de commandes vocales

Traitement du signal, DIC1 GIT, École Polytechnique de Thiès (2026-2027).

**Question** : comment reconnaître automatiquement des mots ou des commandes vocales à partir d'un signal audio bruité et variable en locuteur ?

Sous MATLAB, nous comparons une corrélation, la DTW et deux HMM (discret et HMM-GMM) sur 10 mots de la base Speech Commands v2 : yes, no, up, down, left, right, on, off, stop, go.

## Chaîne de traitement

Signal, VAD, préaccentuation, MFCC + deltas + delta-deltas + CMVN (39 coefficients par trame), puis DTW ou HMM.

## Résultats principaux

1 000 mots de test, locuteurs jamais vus.

| Méthode | Apprentissage | Précision (IC 95 %) |
|---|---|---|
| DTW + MFCC | 20 références par mot | 57,2 % (±3,1) |
| HMM discret | 200 exemples par mot | 74,7 % (±2,7) |
| HMM-GMM (6 états, 4 gaussiennes) | 200 exemples par mot | 86,4 % (±2,1) |

Autres résultats (DTW) :

- locuteurs connus : 83,5 %, contre 57,2 % pour des locuteurs inconnus ;
- bruit : 36 à 37 % à 10 dB, 19 à 22 % à 5 et 0 dB ;
- le choix des caractéristiques (FBANK, MFCC, deltas, CMVN) change la précision de moins de 3 points.

Réserve : les HMM apprennent sur 10 fois plus d'exemples que la DTW. Le test à 20 exemples par mot (`exp08b_hmm_20ex.m`) n'a pas abouti.

## Organisation

- `matlab/` : tout le code (prétraitement, caractéristiques, DTW, HMM, évaluation, expériences `exp01` à `exp08`)
- `donnees/listes/` : listes de test, de validation et de références figées (protocole commun)
- `rapport/` : rapport LaTeX et résultats des expériences (`resultats/`)
- `sauvegarde_echafaudage/` : adaptateurs d'origine, fondés sur les fonctions MATLAB
- `presentation/` : diapositives de la soutenance

## Prérequis

MATLAB R2021b ou plus récent, avec Signal Processing Toolbox, Audio Toolbox et Statistics and Machine Learning Toolbox.

## Données

La base Speech Commands v2 (2,3 Go) n'est pas incluse. Téléchargez `speech_commands_v0.02.tar.gz`, placez-la dans `donnees/`, puis :

    mkdir -p donnees/speech_commands
    tar -xzf donnees/speech_commands_v0.02.tar.gz -C donnees/speech_commands

Les listes de `donnees/listes/` sont déjà fournies : ne relancez pas `figerProtocole.m`.

## Reproduire les expériences

Dans MATLAB, placez-vous dans `matlab/`, puis lancez par exemple `exp01_chaine_complete`. Les résultats sont enregistrés dans `rapport/resultats/`.

## Auteurs

Abdoul Aziz Dabakh SOW, Amadou DIALLO, Mourtalla NDIAYE.

## Licences

Code : à définir. Base Speech Commands : CC BY 4.0 (Google).
