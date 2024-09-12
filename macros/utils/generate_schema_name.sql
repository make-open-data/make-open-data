--- Way to have dbt enforce custom schema without the <target>_<custom>
--- https://docs.getdbt.com/docs/build/custom-schemas#advanced-custom-schema-configuration

{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name }}

    {%- endif -%}

{%- endmacro %}