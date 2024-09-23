"""
Aide pour générer la documentations des schémas. 

A vérifier avant de copier coller
- Ex : Les libellés qui concernent plusieurs modalités

Terminal : 
- clear
- python 1_data/prepare/recensement/generer_doc.py
"""

import pandas as pd

logement_valeurs = pd.read_csv('4_seeds/logement_2020_valeurs.csv')


scope = "la commune" # l'IRIS ou la commune
scope_logement_values = logement_valeurs[logement_valeurs['theme'] == 'demographie'].drop_duplicates('libelle_a_afficher_apres_aggregation')


for index, row in scope_logement_values.iterrows():
    if '_et_plus' in row["libelle_a_afficher_apres_aggregation"]:
        vide_ou_et_plus = ' et plus' 
    else:
        vide_ou_et_plus = ''
    print(f'  - name: {row["libelle_a_afficher_apres_aggregation"]}')
    print(f'    data_type: {row["TYPE_VAR"]}')
    print(f'    description: \"Nombre de ménages dans {scope} qui ont répondu \'{row["LIB_MOD"]}\'{vide_ou_et_plus} (valeur: {row["COD_MOD"]} {vide_ou_et_plus}) à la question \'{row["LIB_VAR"]}\' (code: {row["COD_VAR"]})\"')
    print('   ')