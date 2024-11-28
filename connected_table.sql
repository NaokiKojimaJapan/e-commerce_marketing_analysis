-- connect events, orders, products, and users table and create one table for further analysis

with orders_table as (
  select
    order_items.user_id,
    count(*) as total_items, 
    count(distinct order_id) as total_orders,
    sum(sale_price) as total_sales,
    SUM(CASE WHEN category = 'Accessories' THEN retail_price ELSE 0 END) AS category_Accessories,
    SUM(CASE WHEN category = 'Intimates' THEN retail_price ELSE 0 END) AS category_Intimates,
    SUM(CASE WHEN category = 'Plus' THEN retail_price ELSE 0 END) AS category_Plus,
    SUM(CASE WHEN category = 'Active' THEN retail_price ELSE 0 END) AS category_Active,
    SUM(CASE WHEN category = 'Socks & Hosiery' THEN retail_price ELSE 0 END) AS category_Socks_and_Hosiery,
    SUM(CASE WHEN category = 'Maternity' THEN retail_price ELSE 0 END) AS category_Maternity,
    SUM(CASE WHEN category = 'Socks' THEN retail_price ELSE 0 END) AS category_Socks,
    SUM(CASE WHEN category = 'Sleep & Lounge' THEN retail_price ELSE 0 END) AS category_Sleep_and_Lounge,
    SUM(CASE WHEN category = 'Tops & Tees' THEN retail_price ELSE 0 END) AS category_Tops_and_Tees,
    SUM(CASE WHEN category = 'Leggings' THEN retail_price ELSE 0 END) AS category_Leggings,
    SUM(CASE WHEN category = 'Shorts' THEN retail_price ELSE 0 END) AS category_Shorts,
    SUM(CASE WHEN category = 'Swim' THEN retail_price ELSE 0 END) AS category_Swim,
    SUM(CASE WHEN category = 'Sweaters' THEN retail_price ELSE 0 END) AS category_Sweaters,
    SUM(CASE WHEN category = 'Underwear' THEN retail_price ELSE 0 END) AS category_Underwear,
    SUM(CASE WHEN category = 'Skirts' THEN retail_price ELSE 0 END) AS category_Skirts,
    SUM(CASE WHEN category = 'Blazers & Jackets' THEN retail_price ELSE 0 END) AS category_Blazers_and_Jackets,
    SUM(CASE WHEN category = 'Pants & Capris' THEN retail_price ELSE 0 END) AS category_Pants_and_Capris,
    SUM(CASE WHEN category = 'Dresses' THEN retail_price ELSE 0 END) AS category_Dresses,
    SUM(CASE WHEN category = 'Jumpsuits & Rompers' THEN retail_price ELSE 0 END) AS category_Jumpsuits_and_Rompers,
    SUM(CASE WHEN category = 'Fashion Hoodies & Sweatshirts' THEN retail_price ELSE 0 END) AS category_Fashion_Hoodies_and_Sweatshirts,
    SUM(CASE WHEN category = 'Suits & Sport Coats' THEN retail_price ELSE 0 END) AS category_Suits_and_Sport_Coats,
    SUM(CASE WHEN category = 'Jeans' THEN retail_price ELSE 0 END) AS category_Jeans,
    SUM(CASE WHEN category = 'Pants' THEN retail_price ELSE 0 END) AS category_Pants,
    SUM(CASE WHEN category = 'Outerwear & Coats' THEN retail_price ELSE 0 END) AS category_Outerwear_and_Coats,
    SUM(CASE WHEN category = 'Suits' THEN retail_price ELSE 0 END) AS category_Suits,
    SUM(CASE WHEN category = 'Clothing Sets' THEN retail_price ELSE 0 END) AS category_Clothing_Sets
  from bigquery-public-data.thelook_ecommerce.order_items
  left join bigquery-public-data.thelook_ecommerce.products
  on order_items.product_id = products.id
  where order_items.user_id is not null
  group by order_items.user_id
),
events_table as (
  select 
    user_id, 
    count(*) as total_events,
    COUNT(CASE WHEN event_type = 'cancel' THEN 1 ELSE NULL END) AS event_type_cancel,
    COUNT(CASE WHEN event_type = 'cart' THEN 1 ELSE NULL END) AS event_type_cart,
    COUNT(CASE WHEN event_type = 'department' THEN 1 ELSE NULL END) AS event_type_department,
    COUNT(CASE WHEN event_type = 'home' THEN 1 ELSE NULL END) AS event_type_home,
    COUNT(CASE WHEN event_type = 'product' THEN 1 ELSE NULL END) AS event_type_product,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 ELSE NULL END) AS event_type_purchase
  from bigquery-public-data.thelook_ecommerce.events
  where user_id is not null
  group by user_id
)
select *
from orders_table
full outer join events_table
on orders_table.user_id = events_table.user_id
