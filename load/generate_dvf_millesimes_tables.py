import os


def generate_model_file(millesime, model_template, file_name_pattern, models_dir):
    # Ensure the directory exists
    os.makedirs(models_dir, exist_ok=True)

    # Replace the millesime placeholder in the template
    model_content = model_template.replace('{{ millesime }}', str(millesime))

    # Generate the model file name and file path
    model_filename = file_name_pattern.format(millesime=millesime)
    model_filepath = os.path.join(models_dir, model_filename)

    # Write the model content to the file
    with open(model_filepath, 'w') as model_file:
        model_file.write(model_content)

    print(f'Generated model: {model_filepath}')


def generate_intermediate_tables(millesime, models_dir='1_data/intermediaires/immobilier'):
    model_template = '''
        -- Auto-generated model for millesime {{ millesime }}
        {{ generate_dvf_for_millesime({{ millesime }}) }}
    '''
    file_name_pattern = 'dvf_{millesime}.sql'

    generate_model_file(millesime, model_template, file_name_pattern, models_dir)


def generate_prepared_enriched_mutations(millesime, models_dir='1_data/prepare/immobilier'):
    model_template = '''
    -- Auto-generated model for millesime {{ millesime }}
    -- Enrichie la base dvf groupée par mutation
    -- Ajoute le knn des prix au m2
    {{ knn_with_mutations_foncieres('dvf_{{ millesime }}') }}
    '''
    file_name_pattern = 'mutations_foncieres_enrichies_dvf_{millesime}.sql'

    generate_model_file(millesime, model_template, file_name_pattern, models_dir)

def generate_prepared_enriched_mutations_union_of_millesimes(millesimes, models_dir='1_data/prepare/immobilier'):
    depends_template = "-- Auto-generated model for union of millesimes (depends_on block cannot be generated dynamically in a model interation)\n\n\n"
    for millesime in millesimes:
        print(f"Creating enriched mutations for {millesime}")
        depends_template += f"-- depends_on: {{{{ ref('mutations_foncieres_enrichies_dvf_{millesime}') }}}}\n"

    millesimes_var_template = "{%- set millesimes = [" + ", ".join(
        [f"'{millesime}'" for millesime in millesimes]) + "] -%}\n"

    model_template = '''
{{ log("Millesimes retrieved: " ~ millesimes, info=True) }}

{{
    config(
        materialized='table'
    ) 
}}

{% for millesime in millesimes %}
    {{ log("Millesimes retrieved: " ~ millesime, info=True) }}

    SELECT *
    FROM {{ ref('mutations_foncieres_enrichies_dvf_' ~ millesime) }}

    {% if not loop.last %}
    UNION ALL
    {% endif %}
{% endfor %}
    '''
    file_name_pattern = 'mutations_foncieres_enrichies.sql'

    generate_model_file(millesimes, depends_template + millesimes_var_template + model_template, file_name_pattern, models_dir)