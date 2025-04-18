# Generated by Django 5.1.3 on 2025-03-25 19:00

from django.db import migrations


class Migration(migrations.Migration):

    def add_type_visibility_data(apps, schema_editor):
        TypeVisibility = apps.get_model('operation', 'TypeVisibility')
        type_visibilities = [
            {'wording': 'Standard', 'is_deleted': False},
            {'wording': 'Prioritaire', 'is_deleted': False},
            {'wording': 'Premium', 'is_deleted': False}
        ]
        TypeVisibility.objects.bulk_create([
            TypeVisibility(**data) for data in type_visibilities
        ])

    def add_type_stat_data(apps, schema_editor):
        TypeStat = apps.get_model('operation', 'TypeStat')
        type_stats = [
            {'wording': 'Vues', 'is_deleted': False},
            {'wording': 'Clics', 'is_deleted': False},
            {'wording': 'Réservations', 'is_deleted': False},
            {'wording': 'Messages', 'is_deleted': False},
            {'wording': 'Taux de Conversion', 'is_deleted': False},
            {'wording': 'Localisation', 'is_deleted': False},
            {'wording': 'Sources de Trafic', 'is_deleted': False}
        ]
        TypeStat.objects.bulk_create([
            TypeStat(**data) for data in type_stats
        ])

    def add_category_data(apps, schema_editor):
        Category = apps.get_model('operation', 'Category')
        categories = [
            {'wording': 'Électronique', 'is_deleted': False},
            {'wording': 'Véhicules', 'is_deleted': False},
            {'wording': 'Outils et Équipements', 'is_deleted': False},
            {'wording': 'Matériel de Bureau', 'is_deleted': False},
            {'wording': 'Équipements de Loisirs', 'is_deleted': False},
            {'wording': 'Événements', 'is_deleted': False},
            {'wording': 'Électroménager', 'is_deleted': False},
            {'wording': 'Matériel Audiovisuel', 'is_deleted': False},
            {'wording': 'Bricolage et Jardinage', 'is_deleted': False},
            {'wording': 'Équipements de Transport', 'is_deleted': False}
        ]
        Category.objects.bulk_create([
            Category(**data) for data in categories
        ])

    def add_subcategory_data(apps, schema_editor):
        SubCategory = apps.get_model('operation', 'SubCategory')
        Category = apps.get_model('operation', 'Category')
        
        subcategories = [
            # Électronique
            {'wording': 'Appareils photo', 'is_deleted': False, 
            'category': Category.objects.get(wording='Électronique')},
            {'wording': 'Caméras', 'is_deleted': False, 
            'category': Category.objects.get(wording='Électronique')},
            
            
        ]
        SubCategory.objects.bulk_create([
            SubCategory(**data) for data in subcategories
        ])
    
    def add_announcement_status_data(apps, schema_editor):
        AnnoucementStatus = apps.get_model('operation', 'AnnoucementStatus')
        announcement_statuses = [
            {'wording': 'Disponible', 'is_deleted': False},
            {'wording': 'En cours de réservation', 'is_deleted': False},
            {'wording': 'En location', 'is_deleted': False},
            {'wording': 'Expiré', 'is_deleted': False}
        ]
        AnnoucementStatus.objects.bulk_create([
            AnnoucementStatus(**data) for data in announcement_statuses
        ])

    def add_booking_status_data(apps, schema_editor):
        BookingStatus = apps.get_model('operation', 'BookingStatus')
        booking_statuses = [
            {'wording': 'En attente', 'is_deleted': False},
            {'wording': 'Confirmée', 'is_deleted': False},
            {'wording': 'Annulée', 'is_deleted': False},
            {'wording': 'Terminée', 'is_deleted': False}
        ]
        BookingStatus.objects.bulk_create([
            BookingStatus(**data) for data in booking_statuses
        ])

    def add_type_document_data(apps, schema_editor):
        TypeDocument = apps.get_model('operation', 'TypeDocument')
        type_documents = [
            {'wording': 'Carte d\'identité', 'is_deleted': False},
            {'wording': 'Passeport', 'is_deleted': False},
            {'wording': 'Permis de conduire', 'is_deleted': False},
            {'wording': 'Justificatif de domicile', 'is_deleted': False},
        ]
        TypeDocument.objects.bulk_create([
            TypeDocument(**data) for data in type_documents
        ])

    def add_kyc_status_data(apps, schema_editor):
        KycStatus = apps.get_model('operation', 'KycStatus')
        kyc_statuses = [
            {'wording': 'Non vérifié', 'is_deleted': False},
            {'wording': 'En attente de vérification', 'is_deleted': False},
            {'wording': 'Vérifié', 'is_deleted': False},
            {'wording': 'Rejeté', 'is_deleted': False}
        ]
        KycStatus.objects.bulk_create([
            KycStatus(**data) for data in kyc_statuses
        ])

    def add_type_data(apps, schema_editor):
        Type = apps.get_model('operation', 'Type')
        types = [
            {'wording': 'Réservation', 'is_deleted': False},
            {'wording': 'Annonce', 'is_deleted': False},
            {'wording': 'Support', 'is_deleted': False},
            {'wording': 'Compte', 'is_deleted': False},
            {'wording': 'Facturation', 'is_deleted': False}
        ]
        Type.objects.bulk_create([
            Type(**data) for data in types
        ])

    dependencies = [
        ('operation', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(add_type_visibility_data),
        migrations.RunPython(add_type_stat_data),
        migrations.RunPython(add_category_data),
        migrations.RunPython(add_subcategory_data),
        migrations.RunPython(add_announcement_status_data),
        migrations.RunPython(add_booking_status_data),
        migrations.RunPython(add_type_document_data),
        migrations.RunPython(add_kyc_status_data),
        migrations.RunPython(add_type_data),
    ]
