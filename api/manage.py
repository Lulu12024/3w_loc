#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys
from django.core.management import call_command
from django.db import OperationalError, connection
import django
import psycopg2
from django.conf import settings
import subprocess


def apply_custom_migrations():
    try:
        connection.ensure_connection()
    except OperationalError:
        print("Impossible de se connecter à la base de données. Création de la base de données en cours...")
        create_database()
        print("La base de données a été créée avec succès")
    
    django.setup()

# Appliquer les migrations de votre application
    print("Appliquer les migrations de base de Django...")
    call_command("migrate")
    print("Migrations de base de Django appliquées avec succès.")


def create_database():
    try:
        print('Début de la création de la base de données...')
        db_settings = settings.DATABASES['default']
        db_name = db_settings['NAME']
        print(db_name)
        # Connexion au serveur PostgreSQL par défaut pour créer la base de données
        conn = psycopg2.connect(
            dbname="postgres",
            user=db_settings['USER'],
            password=db_settings['PASSWORD'],
            host=db_settings['HOST'],
            port=db_settings['PORT']
        )
        conn.autocommit = True
        cur = conn.cursor()

        # Création de la base de données (assurez-vous qu'elle n'existe pas déjà)
        cur.execute(f'CREATE DATABASE "{db_name}";')

        cur.close()
        conn.close()

        # Maintenant, mettez à jour la connexion pour utiliser la nouvelle base de données
        db_settings['NAME'] = db_name
        conn = psycopg2.connect(
            dbname=db_settings['NAME'],
            user=db_settings['USER'],
            password=db_settings['PASSWORD'],
            host=db_settings['HOST'],
            port=db_settings['PORT']
        )
        conn.autocommit = True
        cur = conn.cursor()
        print("connexion établie à la base de donnée créée")

        print(f"Base de données '{db_name}' créée avec succès.")

    except psycopg2.OperationalError as e:
        # En cas d'erreur, affichez le message d'erreur
        print(f"Erreur lors de la création de la base de données : {e}")

    except psycopg2.errors.DuplicateDatabase as e:
        # En cas d'erreur, affichez le message d'erreur
        print(f"Erreur : la base de données existe déjà : {e}")
        pass


def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'api.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    
    # Vérifiez si la commande est 'runserver'
    if 'runserver' in sys.argv:

        apply_custom_migrations()
        django.setup()



    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
