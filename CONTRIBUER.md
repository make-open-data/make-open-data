Le projet make-open-data est ouvert à la contribution et toute proposition est la bienvenue !
Cette page donne des indications sur la structure et les conventions du code du projet.




- [Code of Conduct](#coc)
- [Bug ou typo?](#bugtypo)
- [Il manque une feature?](#feature)
- [Soumettre une Issue](#submit-issue)
- [Soumettre une Pull Request (PR)](#submit-pr)


## <a name="coc"></a> Code de Conduite


make-open-data est une communauté ouverte et inclusive. Pour contribuer veuillez lire et suivre notre [code de conduite][coc].


## <a name="bugtypo"></a> Bug ou typo?


Si vous trouvez un bug dans le code source ou une typo dans la documentation, vous pouvez aider en [soumettant une issue](#submit-issue) dans notre [Repo GitHub][github].
Encore mieux, vous pouvez [soumettre une Pull Request](#submit-pr) avec la correction.




## <a name="feature"></a> Il manque une feature?
Vous pouvez *faire une demande* pour une nouvelle feature (dataset ou différent traitement de la donnée) en[soumettant une issue](#submit-issue) dans notre Repo GitHub.
Si vous voulez *ajouter* une nouvelle feature, veuillez considérer la taille du changement pour déterminer la marche à suivre:


* Pour des **Major Feature**, veuillez d'abord ouvrir une issue et décrivez votre proposition pour qu'elle puisse être discutée.
 Ce processus nous permet de coordonner nos efforts, d'éviter le travail redondant, et de vous aider à formater le changement pour qu'il soit accepté dans le projet.


 **Note**: Ajouter un topic a la documentation, ou complètement ré-écrire un topic, est considéré comme une major feature.


* **Small Features** peuvent être ajoutée directement en [soumettant une Pull Request](#submit-pr).


## <a name="submit-issue"></a> Soumettre une issue
Avant de soumettre une issue, veuillez d'abord rechercher si elle existe déjà.


Si vous créez une nouvelle issue, ajouter le plus de détails possible sur :
- ce que vous essayez de faire
- le problème rencontré
- qu'est ce qui devrait se passer s'il n'y avait pas de problème.


## <a name="submit-issue"></a> Soumettre une Pull Request (PR)
Pour soumettre une PR:


1. Foucher (fork) le repo make-open-data/make-open-data.


2. Dans votre nouveau repo, créer vos changements dans une nouvelle branche:


```shell
git checkout -b my-fix-branch main
```

3. Lancer les tests unitaires:
```shell
./scripts/run_tests.sh
```

4. Faites un Commit de vos changements en ajoutant une description dans le message du commit (ex: correction de typo, amélioration du SQL, ajout d'une colonne qui calcule xyz.. )
```shell
git commit --all
```
5. Pousser votre branche sur GitHub:
```shell
git push origin my-fix-branch
```
6. Creer une pull request a make-open-data:staging.


Après revue de la PR, il est possible que nous vous demandions des modifications avant de fusionner la branche.


#### Une fois la PR fusionnée


Une fois que votre PR est fusionnée, vous pouvez supprimer votre branche et "pull" les changements de la branche `staging`:


* Supprimer votre branche:


   ```shell
   git push origin --delete my-fix-branch
   ```


* Check out la branche staging:


   ```shell
   git checkout staging -f
   ```


* Supprimer votre branche en local:


   ```shell
   git branch -D my-fix-branch
   ```


* Mettre à jour votre branche `staging` en local avec la version la plus récente:


   ```shell
   git pull --ff upstream staging
   ```


## <a name="commit"></a> Format du message de Commit


Voici le format suggéré pour les messages de Commit. Nous acceptons les messages en français ou en anglais.
Le respect de ce format permet de rendre la lecture de l'historique des Commits plus facile.


Le message de Commit peut se composer d'un **header**, d'un **body**, et d'un **footer**.




```
<header>
<BLANK LINE>
<body>
<BLANK LINE>
<BLANK LINE>
<footer>
```


Le `header` est obligatoire et doit suivre le format du [Commit Message Header](#commit-header).


Le `body` est obligatoire pour tous les Commits sauf pour ceux de type "docs".


Le `footer` est optionnel. The [Commit Message Footer](#commit-footer) format describes what the footer is used for and the structure it must have.




#### <a name="commit-header"></a>Le Header du message de Commit


```
<type>(<scope>): <short summary>
 │       │             │
 │       │             └─⫸ Résumé au présent. Pas de majuscule. Pas de point final.
 │       │
 │       └─⫸ Commit Scope: workflow|dbt
 │
 └─⫸ Commit Type: ci|docs|feat|fix|test
```


Le `<type>` et `<summary>` sont obligatoires, le `(<scope>)` est optionnel.




##### Type


Le type doit être un des suivants:


* **ci**: Changements liés à la CI (Continuous Integration)
* **docs**: Changements liés à la Documentation
* **feat**: Ajout de nouvelle feature
* **fix**: fixe un bug
* **perf**: Changement du code qui améliore la performance
* **refactor**: Changement du code qui ne fixe pas de bug et qui n'ajoute pas de feature
* **test**: Ajoute des tests ou améliore des tests existants


##### Scope
(optionnel)
* **workflow**: Changement aux actions du github Workflow
* **dbt**: Changement lié à dbt (ajout de source, model, test...)


##### Résumé


* On conjugue à la 3e personne du temps présent: "change" pas "changer" ni "changé"
* Pas de majuscule pour la première lettre
* Pas de point (.) a la fin




#### <a name="commit-body"></a>Le Body du message de Commit


Même instructions que pour le résumé.


On explique les motivations pour le changement. Le message doit expliquer _pourquoi_ vous suggérez ce changement.
Vous pouvez inclure une comparaison de ce qu'effectue le nouveau code comparé à avant pour illustrer le changement.




#### <a name="commit-footer"></a>Footer du message de Commit


Le footer est utilisé pour indiquer si la PR fixe une "issue" en particulier:


```
BREAKING CHANGE: <breaking change summary>
<BLANK LINE>
<breaking change description + migration instructions>
<BLANK LINE>
<BLANK LINE>
Fixe #<issue number>
```


## Remerciement
Merci d'avoir lu ce document jusqu'à la fin et pour votre aide et contribution au projet make-open-data!




[coc]: https://github.com/make-open-data/make-open-data/blob/main/CODE_DE_CONDUITE.md