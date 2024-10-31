#!/usr/bin/env bash

# Exécuter les tests et générer les rapports dans le répertoire `reports` :
#  - `reports/junit.xml` : rapport XML des résultats des tests.
#  - `reports/coverage.xml` : rapport XML de couverture de code.
#  - `reports/htmlcov` : rapport HTML de couverture de code.

trap "result=1" ERR

rm -rf reports
python -m pytest --cov=load --cov-report=xml --cov-report=html --junitxml="reports/junit.xml" tests
mkdir -p reports
mv coverage.xml htmlcov reports/.

echo "Rapport de couverture de code disponible à : file://$(pwd)/reports/htmlcov/index.html"

exit $result
