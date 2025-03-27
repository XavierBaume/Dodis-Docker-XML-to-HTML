# Utiliser une image Python légère
FROM python:3.11-slim

# Créer un dossier de travail
WORKDIR /app

# Copier les fichiers
COPY app /app/app
COPY xml_to_html.xsl /app/xml_to_html.xsl
COPY requirements.txt /app/requirements.txt

# Installer les dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port de l'app
EXPOSE 8000

# Lancer FastAPI avec Uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
