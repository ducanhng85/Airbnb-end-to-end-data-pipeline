{% set config = [
    {
        "table": "AIRBNB.gold.obt",
        "columns": "gold_obt.booking_id, gold_obt.listing_id, gold_obt.host_id, gold_obt.total_amount, gold_obt.service_fee, gold_obt.cleaning_fee, gold_obt.accommodates, gold_obt.bedrooms, gold_obt.bathrooms, gold_obt.price_per_night, gold_obt.response_rate",
        "alias": "gold_obt"
    },
    {
        "table": "AIRBNB.gold.dim_LISTINGS",
        "columns": "        
        ",
        "alias": "dim_listings",
        "join_condition": "gold_obt.listing_id = dim_listings.listing_id"
    },
    {
        "table": "AIRBNB.gold.dim_HOSTS",
        "columns": "
        ",
        "alias": "dim_hosts",
        "join_condition": "gold_obt.host_id = dim_hosts.host_id"
    }
] %}

select 
   {{ config[0].columns }}
from
    {% for table_config in config %} 
    {% if loop.first %}
    {{ table_config['table'] }} as {{ table_config['alias'] }}
{% else %}
    LEFT JOIN {{ table_config['table'] }} as {{ table_config['alias'] }}
    ON {{ table_config['join_condition'] }}
    {% endif %}
{% endfor %}