# Container projet
1. Recevoir une requête POST avec du XML (Content-Type: application/xml)
2. Convertir ce XML en HTML via un fichier XSLT (script commenté dans app/main.py)
3. Traiter un dossier complet (panel-xml) 

Extraire tous les résultats HTML dans un .zip

# Configuration 
## Installation préalable via Colima (MacOS Apple Silicon)
    brew install colima
    colima start
    colima list --> statut
## Socket
    sudo nano ~/.zshrc --> ouvrir le fichier de configuration du shell
    export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock" --> collé à la fin du fichier de configuration du shell après '# <<< conda initialize <<<'
    source ~/.zshrc --> recharger 
    docker run hello-world --> test docker
## Suivi des dockers
    docker ps --> lister les dockers
    docker stop <CONTAINER_id> + docker rm <CONTAINER_id> --> libérer un port
    docker info

## Structure du projet de container 
xml-to-html-service
├── app
│ ├── main.py--> Script FastAPI avec endpoints
├── converted/ --> dossier et sous-dossiers convertis en .html
├── panel-xml/
├── .dockerignore
├── converted.zip  --> dossier converted/ zippé
├── Dockerfile --> Instructions de construction du conteneur
├── dodis-61431.xml --> Fichier XML d'entrée
├── README.md
├── requirements.txt --> Liste des dépendances Python
└── xml_to_html.xsl --> Script XSLT pour la transformation

## Commandes d'exécution
    docker build -t xml-to-html-service --> Construction de l'image Docker
    
    docker run -p 8000:8000 xml-to-html-service --> Lancement du conteneur (OK ? Lancement sans volume car problème de permission)
    
    curl -X POST http://localhost:8000/convert-folder-recursive/ \
  -H "Content-Type: application/json" \
  -d '{"folder_path": "/app/panel-xml"}' --> Appel API de conversion
  
  Réponse attendue : {"converted": 1251, "output_dir": "/app/converted"}

4. Récupérer les fichiers en local
docker ps --> trouver <CONTAINER_id>
docker cp <CONTAINER_id>:/app/converted ./converted --> copie en local
zip -r output.zip converted/ --> Archiver les résultats (optionnel?)
