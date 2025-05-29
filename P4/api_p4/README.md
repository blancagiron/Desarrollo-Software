# README
2. Listar todos los envíos:
curl http://localhost:3000/envios
3. Ver un envío específico:
curl http://localhost:3000/envios/1
4. Cambiar estado a "en_transito":
curl -X PUT http://localhost:3000/envios/1 \
  -H "Content-Type: application/json" \
  -d '{
    "envio": {
      "estado": "en_transito"
    }
  }'
5. Cambiar estado a "entregado":
curl -X PUT http://localhost:3000/envios/1 \
  -H "Content-Type: application/json" \
  -d '{
    "envio": {
      "estado": "entregado"
    }
  }'
6. Eliminar envío:
curl -X DELETE http://localhost:3000/envios/1
