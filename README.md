# MedVision

## Concepto

MedVision es un proyecto innovador diseñado para ayudar a estudiantes de medicina en el estudio de anatomía y cirugía. Utilizando la aplicación compatible con los Vision Pro de Apple, los usuarios pueden aprender procedimientos quirúrgicos mediante el uso de maniquíes en un entorno presencial o a través de modelos 3D interactivos en un entorno virtual. La aplicación también ofrece módulos detallados de anatomía que permiten explorar y manipular modelos 3D de partes del cuerpo. Además, incluye un chatbot de IA especializado en medicina para responder preguntas durante el estudio.

## Tecnologías Utilizadas

- **Framework web:** FastAPI
- **Base de datos:** PostgreSQL
- **Host:** Supabase

## API

### Descripción general

La API de MedVision facilita el acceso a datos y funciones específicas mediante rutas web. Recientemente hemos migrado de Django a FastAPI para mejorar el rendimiento y simplificar el mantenimiento.

### Cómo empezar

#### Requisitos Previos

Antes de usar la API, es necesario preparar el entorno. Sigue estos pasos:

1. En caso de no tener instalado Homebrew en tu Mac, puedes hacerlo con el cómando:

   `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

2. Instalar pipenv:
   
   `brew install pipenv`

3. Inicia el entorno virtual con:
   
   `pipenv shell`

4. Instala las dependencias necesarias ejecutando:

   `pipenv install fastapi supabase "uvicorn[standard]"`

#### Ejecución la API

1. Accede al directorio de la API:

   `cd API`

2. Inicia el servidor en modo de desarrollo, lo que permite la recarga automática al modificar el código:

   `uvicorn main:app --reload`

Este comando inicia el servidor en modo de desarrollo, permitiendo que los cambios que hagas en el código se apliquen automáticamente.

### Uso de la API

#### Rutas disponibles

- **GET `/getall`**: Obtiene todos los datos disponibles a través de la API.

### Documentación interactiva

Accede a la documentación interactiva para ver y probar las rutas disponibles directamente desde tu navegador en:

- **Swagger UI**: `/docs`
- **ReDoc**: `/redocs`

## Aplicación Vision Pro

Para ejecutar la aplicación Vision Pro en Xcode, sigue estos pasos:

1. Abre la carpeta `Reto-Tec-Salud` en Xcode.
2. Selecciona el proyecto correspondiente y ejecútalo en un dispositivo compatible o en el simulador.
