En este lab vamos a ver la forma de a traves de terraform:

1. Generar un SA que pueda listar y ver todos los proyectos
2. Encender las APIS que requiere dome9
~~~
1. Navigate to **Enable APIs & Services** page 
2. Click the **“ENABLE APIS AND SERVICES”** button 
3. Search for **Compute Engine API** and verify it is enabled 
4. Search for **Cloud Resource Manager API** and verify it is enabled 
5. Search for the following APIs, and enable them:
    - Kubernetes API 
    - KMS API 
    - IAM API 
    - App Engine Admin API 
    - BigQuery API 
    - Admin SDK API
    - Cloud Functions API 
    - Cloud SQL Admin API 
    - Cloud BigTable Admin API
    - Cloud Pub/Sub API
    - Cloud Memorystore Redis
    - Service Usage API
    - Cloud Filestore API
    - API Keys API
    - Cloud Logging API
    - Cloud DNS API
    - Cloud Asset API
    - Essential Contacts API
    - Access Approval API
~~~

La cuenta de pruebas es KLNTECH

*Archivo requerido de obsidian*

Se genera un service account con los roles

- resourcemanager.projects.get
- resourcemanager.projects.list
- resourcemanager.folders.get
- resourcemanager.folders.list

Also, please note that the predefined role `roles/browser` regroup most of this scope without being overly permissive.


Este SA se tiene que replicar el principal a todos los proyectos

Ejemplo con GC-Project1

*Pantalla de proyecto GCP obisidian*

Despues de esto el terraform debera poder listar los proyectos **Esto puede tardar hasta 10 mins**

*Pantalla de ejemplo de listado obsidian*

Para poder encender y apagar los servicios de goole se requiere "Service Management Admi"

*Pantalla de ejempo*
