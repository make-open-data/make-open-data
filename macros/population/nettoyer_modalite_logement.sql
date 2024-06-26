{% macro nettoyer_modalite_logement(nom_colonne) %}
  CASE 
    WHEN right(lower(regexp_replace(
        regexp_replace(
          regexp_replace(
            regexp_replace(
              regexp_replace(
                regexp_replace(
                  regexp_replace(
                    regexp_replace(
                      regexp_replace(
                        regexp_replace(
                          unaccent({{ nom_colonne }}), 
                          'm²', '', 'g'
                        ), 
                        '[ ''(),\-:]+', '_', 'g'
                      ),
                      'de_', '', 'g'
                    ),
                    'la_', '', 'g'
                  ),
                  'du_', '', 'g'
                ),
                'd_un_', '', 'g'
              ),
              'dans_', '', 'g'
            ),
            'un_', '', 'g'
          ),
          'une_', '', 'g'
        ),
        'd_une_', '', 'g'
      )), 1) = '_' THEN
      left(lower(regexp_replace(
        regexp_replace(
          regexp_replace(
            regexp_replace(
              regexp_replace(
                regexp_replace(
                  regexp_replace(
                    regexp_replace(
                      regexp_replace(
                        regexp_replace(
                          unaccent({{ nom_colonne }}), 
                          'm²', '', 'g'
                        ), 
                        '[ ''(),\-:]+', '_', 'g'
                      ),
                      'de_', '', 'g'
                    ),
                    'la_', '', 'g'
                  ),
                  'du_', '', 'g'
                ),
                'd_un_', '', 'g'
              ),
              'dans_', '', 'g'
            ),
            'un_', '', 'g'
          ),
          'une_', '', 'g'
        ),
        'd_une_', '', 'g'
      )), -1)
    ELSE
      lower(regexp_replace(
        regexp_replace(
          regexp_replace(
            regexp_replace(
              regexp_replace(
                regexp_replace(
                  regexp_replace(
                    regexp_replace(
                      regexp_replace(
                        regexp_replace(
                          unaccent({{ nom_colonne }}), 
                          'm²', '', 'g'
                        ), 
                        '[ ''(),\-:]+', '_', 'g'
                      ),
                      'de_', '', 'g'
                    ),
                    'la_', '', 'g'
                  ),
                  'du_', '', 'g'
                ),
                'd_un_', '', 'g'
              ),
              'dans_', '', 'g'
            ),
            'un_', '', 'g'
          ),
          'une_', '', 'g'
        ),
        'd_une_', '', 'g'
      ))
  END
{% endmacro %}