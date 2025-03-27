from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from lxml import etree
import os
import logging

logging.basicConfig(level=logging.INFO)

# Charger XSLT 
XSLT_FILE = "xml_to_html.xsl"
if not os.path.exists(XSLT_FILE):
    raise RuntimeError(f"Fichier XSLT non trouvé : {XSLT_FILE}")

try:
    xslt = etree.parse(XSLT_FILE)
    transform = etree.XSLT(xslt)
    logging.info(f"Fichier XSLT chargé : {XSLT_FILE}")
except Exception as e:
    logging.error(f"Erreur XSLT : {e}")
    raise RuntimeError(f"Erreur pour le chargement du fichier XSLT : {e}")

app = FastAPI()

class FolderRequest(BaseModel): # Utilisation du format JSON pour envoyer des données structurées dans le corps de la requête HTTP cf. Commandes d'exécution n°3
    folder_path: str

# POST un fichier XML unique, par exemple dodis-61431.xml

"""
@app.post("/convert", response_class=HTMLResponse)
async def convert_xml_to_html(request: Request):
    try:
        body = await request.body()
        xml_content = body.decode("utf-8")
        logging.info(f"XML reçu :\n{xml_content}")

        try:
            xml_tree = etree.fromstring(xml_content.encode('utf-8'))
        except etree.XMLSyntaxError as e:
            logging.error(f"Format XML invalide : {e}")
            raise HTTPException(status_code=400, detail=f"Format XML invalide : {e}")

        try:
            html_result = transform(xml_tree)
            html_content = str(html_result)
        except Exception as e:
            logging.error(f"Erreur XSLT : {e}")
            raise HTTPException(status_code=500, detail="Erreur lors de la transformation")

        logging.info(f"HTML généré.")
        return HTMLResponse(content=html_content)

    except Exception as e:
        logging.error(f"Erreur serveur : {e}")
        raise HTTPException(status_code=500, detail="Erreur du serveur")
"""

# POST un dossier complet, en traitant chaque fichier .xml des sous-dossiers de manière récursive

@app.post("/convert-folder-recursive/")
def convert_all_xml_in_folder(request: FolderRequest):
    folder_path = request.folder_path

    if not os.path.isdir(folder_path):
        raise HTTPException(status_code=400, detail=f"Dossier non valide : {folder_path}")

    output_root = "/app/converted"
    os.makedirs(output_root, exist_ok=True)

    converted_count = 0

    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".xml"):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, folder_path)
                output_file = os.path.join(output_root, rel_path.replace(".xml", ".html"))
                os.makedirs(os.path.dirname(output_file), exist_ok=True)

                try:
                    with open(full_path, "rb") as f:
                        xml_tree = etree.parse(f)
                        html_result = transform(xml_tree)
                        with open(output_file, "w", encoding="utf-8") as out:
                            out.write(str(html_result))
                        logging.info(f"Converti avec succès !: {rel_path}")
                        converted_count += 1
                except Exception as e:
                    logging.warning(f"Erreur sur {rel_path} : {e}")

    if converted_count == 0:
        raise HTTPException(status_code=204, detail="Aucun XML valide trouvé.")

    logging.info(f" {converted_count} fichiers XML convertis dans {output_root}")
    return {"converted": converted_count, "output_dir": output_root}
