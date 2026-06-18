{% set config = [
    {
        "table": "AIRBNB.SILVER.SILVER_BOOKINGS",
        "columns": "silver_bookings.*",
        "alias": "silver_bookings"
    },
    {
        "table": "AIRBNB.SILVER.SILVER_LISTINGS",
        "columns": "
            silver_listings.host_id,
            silver_listings.property_type,
            silver_listings.room_type,
            silver_listings.city,
            silver_listings.country,
            silver_listings.accommodates,
            silver_listings.bedrooms,
            silver_listings.bathrooms,
            silver_listings.price_per_night,
            silver_listings.price_category,
            silver_listings.created_at as listing_created_at
        ",
        "alias": "silver_listings",
        "join_condition": "silver_bookings.listing_id = silver_listings.listing_id"
    },
    {
        "table": "AIRBNB.SILVER.SILVER_HOSTS",
        "columns": "
            silver_hosts.host_name, 
            silver_hosts.host_since, 
            silver_hosts.is_superhost, 
            silver_hosts.response_rate, 
            silver_hosts.response_rate_quality, 
            silver_hosts.created_at as host_created_at",
        "alias": "silver_hosts",
        "join_condition": "silver_listings.host_id = silver_hosts.host_id"
    }
] %}

select 
    {% for table_config in config %}
        {{ table_config.columns }}
        {% if not loop.last %},{% endif %}
    {% endfor %}
from
    {% for table_config in config %} 
    {% if loop.first %}
    {{ table_config['table'] }} as {{ table_config['alias'] }}
{% else %}
    LEFT JOIN {{ table_config['table'] }} as {{ table_config['alias'] }}
    ON {{ table_config['join_condition'] }}
    {% endif %}
{% endfor %}