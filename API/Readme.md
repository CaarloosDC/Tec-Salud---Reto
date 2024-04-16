# API
Se cambió de framework de django a FastAPI,
Las dependencias requeridas son fastapi supabase y uvicorn:

    pipenv install fastapi supabase "uvicorn[standard]"
  
  Para correr el servidor lo hacemos con:

    uvicorn main:app --reload
La única ruta programada es la /getall
Se puede acceder a Swagger a través de la ruta /docs y a una alternativa con la ruta /redocs

