# Generated by Django 5.1.3 on 2025-01-20 09:16

from django.db import migrations
import uuid

class Migration(migrations.Migration):

    dependencies = [
        ('authentication', '0001_initial'),
    ]
    

    def insert_countries(apps, schema_editor):
        # Obtenir le modèle sans le charger directement (compatibilité migrations)
        Pays = apps.get_model('authentication', 'Pays')

        # Liste des pays à insérer
        countries = [
            {"wording": "Afghanistan", "code": "AF"},
            {"wording": "Albania", "code": "AL"},
            {"wording": "Algeria", "code": "DZ"},
            {"wording": "Andorra", "code": "AD"},
            {"wording": "Angola", "code": "AO"},
            {"wording": "Argentina", "code": "AR"},
            {"wording": "Armenia", "code": "AM"},
            {"wording": "Australia", "code": "AU"},
            {"wording": "Austria", "code": "AT"},
            {"wording": "Azerbaijan", "code": "AZ"},
            {"wording": "Bahamas", "code": "BS"},
            {"wording": "Bahrain", "code": "BH"},
            {"wording": "Bangladesh", "code": "BD"},
            {"wording": "Barbados", "code": "BB"},
            {"wording": "Belarus", "code": "BY"},
            {"wording": "Belgium", "code": "BE"},
            {"wording": "Benin", "code": "BJ"},
            {"wording": "Bhutan", "code": "BT"},
            {"wording": "Bolivia", "code": "BO"},
            {"wording": "Bosnia and Herzegovina", "code": "BA"},
            {"wording": "Botswana", "code": "BW"},
            {"wording": "Brazil", "code": "BR"},
            {"wording": "Brunei", "code": "BN"},
            {"wording": "Bulgaria", "code": "BG"},
            {"wording": "Burkina Faso", "code": "BF"},
            {"wording": "Burundi", "code": "BI"},
            {"wording": "Cabo Verde", "code": "CV"},
            {"wording": "Cambodia", "code": "KH"},
            {"wording": "Cameroon", "code": "CM"},
            {"wording": "Canada", "code": "CA"},
            {"wording": "Chad", "code": "TD"},
            {"wording": "Chile", "code": "CL"},
            {"wording": "China", "code": "CN"},
            {"wording": "Colombia", "code": "CO"},
            {"wording": "Comoros", "code": "KM"},
            {"wording": "Congo (Congo-Brazzaville)", "code": "CG"},
            {"wording": "Congo (Congo-Kinshasa)", "code": "CD"},
            {"wording": "Costa Rica", "code": "CR"},
            {"wording": "Croatia", "code": "HR"},
            {"wording": "Cuba", "code": "CU"},
            {"wording": "Cyprus", "code": "CY"},
            {"wording": "Czechia (Czech Republic)", "code": "CZ"},
            {"wording": "Denmark", "code": "DK"},
            {"wording": "Djibouti", "code": "DJ"},
            {"wording": "Dominica", "code": "DM"},
            {"wording": "Dominican Republic", "code": "DO"},
            {"wording": "Ecuador", "code": "EC"},
            {"wording": "Egypt", "code": "EG"},
            {"wording": "El Salvador", "code": "SV"},
            {"wording": "Estonia", "code": "EE"},
            {"wording": "Eswatini", "code": "SZ"},
            {"wording": "Ethiopia", "code": "ET"},
            {"wording": "Fiji", "code": "FJ"},
            {"wording": "Finland", "code": "FI"},
            {"wording": "France", "code": "FR"},
            {"wording": "Gabon", "code": "GA"},
            {"wording": "Gambia", "code": "GM"},
            {"wording": "Georgia", "code": "GE"},
            {"wording": "Germany", "code": "DE"},
            {"wording": "Ghana", "code": "GH"},
            {"wording": "Greece", "code": "GR"},
            {"wording": "Grenada", "code": "GD"},
            {"wording": "Guatemala", "code": "GT"},
            {"wording": "Guinea", "code": "GN"},
            {"wording": "Guinea-Bissau", "code": "GW"},
            {"wording": "Guyana", "code": "GY"},
            {"wording": "Haiti", "code": "HT"},
            {"wording": "Honduras", "code": "HN"},
            {"wording": "Hungary", "code": "HU"},
            {"wording": "Iceland", "code": "IS"},
            {"wording": "India", "code": "IN"},
            {"wording": "Indonesia", "code": "ID"},
            {"wording": "Iran", "code": "IR"},
            {"wording": "Iraq", "code": "IQ"},
            {"wording": "Ireland", "code": "IE"},
            {"wording": "Israel", "code": "IL"},
            {"wording": "Italy", "code": "IT"},
            {"wording": "Jamaica", "code": "JM"},
            {"wording": "Japan", "code": "JP"},
            {"wording": "Jordan", "code": "JO"},
            {"wording": "Kazakhstan", "code": "KZ"},
            {"wording": "Kenya", "code": "KE"},
            {"wording": "Kiribati", "code": "KI"},
            {"wording": "Kuwait", "code": "KW"},
            {"wording": "Kyrgyzstan", "code": "KG"},
            {"wording": "Laos", "code": "LA"},
            {"wording": "Latvia", "code": "LV"},
            {"wording": "Lebanon", "code": "LB"},
            {"wording": "Lesotho", "code": "LS"},
            {"wording": "Liberia", "code": "LR"},
            {"wording": "Libya", "code": "LY"},
            {"wording": "Liechtenstein", "code": "LI"},
            {"wording": "Lithuania", "code": "LT"},
            {"wording": "Luxembourg", "code": "LU"},
            {"wording": "Madagascar", "code": "MG"},
            {"wording": "Malawi", "code": "MW"},
            {"wording": "Malaysia", "code": "MY"},
            {"wording": "Maldives", "code": "MV"},
            {"wording": "Mali", "code": "ML"},
            {"wording": "Malta", "code": "MT"},
            {"wording": "Marshall Islands", "code": "MH"},
            {"wording": "Mauritania", "code": "MR"},
            {"wording": "Mauritius", "code": "MU"},
            {"wording": "Mexico", "code": "MX"},
            {"wording": "Micronesia", "code": "FM"},
            {"wording": "Moldova", "code": "MD"},
            {"wording": "Monaco", "code": "MC"},
            {"wording": "Mongolia", "code": "MN"},
            {"wording": "Montenegro", "code": "ME"},
            {"wording": "Morocco", "code": "MA"},
            {"wording": "Mozambique", "code": "MZ"},
            {"wording": "Myanmar (Burma)", "code": "MM"},
            {"wording": "Namibia", "code": "NA"},
            {"wording": "Nauru", "code": "NR"},
            {"wording": "Nepal", "code": "NP"},
            {"wording": "Netherlands", "code": "NL"},
            {"wording": "New Zealand", "code": "NZ"},
            {"wording": "Nicaragua", "code": "NI"},
            {"wording": "Niger", "code": "NE"},
            {"wording": "Nigeria", "code": "NG"},
            {"wording": "North Korea", "code": "KP"},
            {"wording": "North Macedonia", "code": "MK"},
            {"wording": "Norway", "code": "NO"},
            {"wording": "Oman", "code": "OM"},
            {"wording": "Pakistan", "code": "PK"},
            {"wording": "Palau", "code": "PW"},
            {"wording": "Palestine", "code": "PS"},
            {"wording": "Panama", "code": "PA"},
            {"wording": "Papua New Guinea", "code": "PG"},
            {"wording": "Paraguay", "code": "PY"},
            {"wording": "Peru", "code": "PE"},
            {"wording": "Philippines", "code": "PH"},
            {"wording": "Poland", "code": "PL"},
            {"wording": "Portugal", "code": "PT"},
            {"wording": "Qatar", "code": "QA"},
            {"wording": "Romania", "code": "RO"},
            {"wording": "Russia", "code": "RU"},
            {"wording": "Rwanda", "code": "RW"},
            {"wording": "Saint Kitts and Nevis", "code": "KN"},
            {"wording": "Saint Lucia", "code": "LC"},
            {"wording": "Saint Vincent and the Grenadines", "code": "VC"},
            {"wording": "Samoa", "code": "WS"},
            {"wording": "San Marino", "code": "SM"},
            {"wording": "Sao Tome and Principe", "code": "ST"},
            {"wording": "Saudi Arabia", "code": "SA"},
            {"wording": "Senegal", "code": "SN"},
            {"wording": "Serbia", "code": "RS"},
            {"wording": "Seychelles", "code": "SC"},
            {"wording": "Sierra Leone", "code": "SL"},
            {"wording": "Singapore", "code": "SG"},
            {"wording": "Slovakia", "code": "SK"},
            {"wording": "Slovenia", "code": "SI"},
            {"wording": "Solomon Islands", "code": "SB"},
            {"wording": "Somalia", "code": "SO"},
            {"wording": "South Africa", "code": "ZA"},
            {"wording": "South Korea", "code": "KR"},
            {"wording": "South Sudan", "code": "SS"},
            {"wording": "Spain", "code": "ES"},
            {"wording": "Sri Lanka", "code": "LK"},
            {"wording": "Sudan", "code": "SD"},
            {"wording": "Suriname", "code": "SR"},
            {"wording": "Sweden", "code": "SE"},
            {"wording": "Switzerland", "code": "CH"},
            {"wording": "Syria", "code": "SY"},
            {"wording": "Tajikistan", "code": "TJ"},
            {"wording": "Tanzania", "code": "TZ"},
            {"wording": "Thailand", "code": "TH"},
            {"wording": "Timor-Leste", "code": "TL"},
            {"wording": "Togo", "code": "TG"},
            {"wording": "Tonga", "code": "TO"},
            {"wording": "Trinidad and Tobago", "code": "TT"},
            {"wording": "Tunisia", "code": "TN"},
            {"wording": "Turkey", "code": "TR"},
            {"wording": "Turkmenistan", "code": "TM"},
            {"wording": "Tuvalu", "code": "TV"},
            {"wording": "Uganda", "code": "UG"},
            {"wording": "Ukraine", "code": "UA"},
            {"wording": "United Arab Emirates", "code": "AE"},
            {"wording": "United Kingdom", "code": "GB"},
            {"wording": "United States", "code": "US"},
            {"wording": "Uruguay", "code": "UY"},
            {"wording": "Uzbekistan", "code": "UZ"},
            {"wording": "Vanuatu", "code": "VU"},
            {"wording": "Vatican City", "code": "VA"},
            {"wording": "Venezuela", "code": "VE"},
            {"wording": "Vietnam", "code": "VN"},
            {"wording": "Yemen", "code": "YE"},
            {"wording": "Zambia", "code": "ZM"},
            {"wording": "Zimbabwe", "code": "ZW"}
        ]

        # Insérer les données
        for country in countries:
            Pays.objects.create(**country)

    def insert_type_document(apps, schema_editor):
        # Obtenir le modèle sans le charger directement (compatibilité migrations)
        TypeDocument = apps.get_model('authentication', 'TypeDocument')

        # Liste des pays à insérer
        type_documents = [
            {"wording" : "Carte d'identité"},
            {"wording" : "Passeport"},
            {"wording" : "Permis de conduire"},
            {"wording" : "Facture"},
            {"wording" : "Quittance"},
        ]
        # Insérer les données
        for type_document in type_documents:
            TypeDocument.objects.create(**type_document)


    def insert_role(apps, schema_editor):
        # Obtenir le modèle sans le charger directement (compatibilité migrations)
        Role = apps.get_model('authentication', 'Role')

        # Liste des pays à insérer
        roles = [
            {"libelle" : "ADMINISTRATEUR" , "description" : "ADMINISTRATEUR"},
            {"libelle" : "USER" , "description" : "USER"},
        ]
        # Insérer les données
        for role in roles:
            Role.objects.create(**role)


    operations = [
        migrations.RunPython(insert_countries),
        migrations.RunPython(insert_type_document),
        migrations.RunPython(insert_role),
    ]
