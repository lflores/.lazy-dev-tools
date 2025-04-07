#!/bin/bash

base=./
folders=$(find $base \( -name .git -o -name node_modules -o -name cdk.out -o -name dist \) -prune -o -type d -print)
folders=$(echo $folders | sort)

if [ ${#folders} -gt 0 ]; then
    echo "\`\`\`mermaid"
    echo "mindmap"
    echo " root((mindmap))"
fi
for folder in $folders; do
    folder=${folder#"$base"}
    alias=${folder##*/}
    alias="$(tr '[:lower:]' '[:upper:]' <<< ${alias:0:1})${alias:1}"
    slashes=$(grep -o "/" <<< $folder | wc -l)
    hashes="  "
    for ((i=0; i<$slashes; i++)); do
        hashes+=" "
    done
    title="$hashes $alias"
    if [ ${#folder} -gt 0 ]; then
        echo "$title" 
    fi
done
if [ ${#folders} -gt 0 ]; then
    echo "\`\`\`"
fi

## Ejemplo viaje a Rio
# prompt Por favor, crea un extenso mapa mental en Mermaid siguiendo el estilo del ejemplo proporcionado para planificar un [VIAJE A RIO DE JANEIRO] incluyendo algunos ejemplos de cada item. Asegúrate de usar los íconos apropiados y tener el número correcto de espacios para la jerarquía de capas. El ejemplo proporcionado es el siguiente:
# mindmap
# root((Ejemplo))
#   Categoria1
#   Subcategoria1
#   ::icon(fa fa-icon1)
#   Subcategoria2
#   ::icon(fa fa-icon2)
#   Categoria2
#   Subcategoria3
#   ::icon(fa fa-icon3)
# mindmap
#     root((VIAJE A RIO DE JANEIRO))
#         Categoria1
#             Subcategoria1
#             ::icon( fa fa-calendar-check)
#                 Preparativos
#                 ::icon(fa fa-calendar-check)
#                 Documentos de viaje
#                 ::icon(fa fa-passport)
#                 Reservas de vuelo
#                 ::icon(fa fa-ticket-alt)
#                 Reservas de hotel
#                 ::icon(fa fa-hotel)
#                 Itinerario
#                 ::icon(fa fa-map)
#                 Lista de equipaje
#                 ::icon(fa fa-suitcase)
#             Subcategoria2
#             ::icon(fa fa-money-bill-wave)
#                 Presupuesto
#                 ::icon(fa fa-money-check-alt)
#                 Gastos previstos
#                 ::icon(fa fa-receipt)
#                 Divisas
#                 ::icon(fa fa-money-bill-wave)
#                 Cambio de moneda
#                 ::icon(fa fa-exchange-alt)
#                 Tarjetas de crédito
#                 ::icon(fa fa-credit-card)
#         Categoria2
#             Subcategoria3
#             ::icon(fa fa-map-marked-alt)
#                 Atracciones turísticas
#                 ::icon(fa fa-umbrella-beach)
#                 Playas famosas
#                 ::icon(fa fa-sun)
#                 Cristo Redentor
#                 ::icon(fa fa-church)
#                 Pan de Azúcar
#                 ::icon(fa fa-mountain)
#                 Jardín Botánico
#                 ::icon(fa fa-tree)
#                 Escaleras de Selarón
#                 ::icon(fa fa-street-view)
#             Subcategoria4
#             ::icon(fa fa-utensils)
#                 Gastronomía
#                 ::icon(fa fa-cocktail)
#                 Platos típicos
#                 ::icon(fa fa-utensils)
#                 Feijoada
#                 ::icon(fa fa-pepper-hot)
#                 Coxinha
#                 ::icon(fa fa-drumstick-bite)
#                 Churrasco
#                 ::icon(fa fa-drumstick-bite)
#                 Caipirinha
#                 ::icon(fa fa-glass-martini)
#             Subcategoria5
#             ::icon(fa fa-shopping-bag)
#                 Compras
#                 ::icon(fa fa-tshirt)
#                 Souvenirs
#                 ::icon(fa fa-gift)
#                 Artesanías
#                 ::icon(fa fa-paint-brush)
#                 Ropa de playa
#                 ::icon(fa fa-swimmer)