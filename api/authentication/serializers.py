import random , string
from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import *
from django.core.files.base import ContentFile
import base64
from rest_framework.fields import ImageField



User = get_user_model()



class Base64ImageField(ImageField):
    def to_internal_value(self, data):
        if isinstance(data, str) and data.startswith('data:image'):
            format, imgstr = data.split(';base64,')  # décoder Base64
            ext = format.split('/')[-1]
            data = ContentFile(base64.b64decode(imgstr), name=f'temp.{ext}')
        return super().to_internal_value(data)



class PaysSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pays
        fields = '__all__'



class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = '__all__'



class UserSerializer(serializers.ModelSerializer):
    username = serializers.CharField(required=False, allow_blank=True)
    user_code = serializers.CharField(read_only=True)
    sexe = serializers.CharField(required=False, allow_blank=True)
    country = serializers.SerializerMethodField()
    poste = serializers.CharField(required=False, allow_blank=True)
    role  = RoleSerializer(read_only=True)
    city = serializers.CharField(required=False, allow_blank=True)
    department = serializers.CharField(required=False, allow_blank=True)
    zip_code = serializers.CharField(required=False, allow_blank=True)
    main_address = serializers.CharField(required=False, allow_blank=True)
    secondary_address = serializers.CharField(required=False, allow_blank=True)
    type_compte = serializers.CharField(required=False, allow_blank=True)
    last_name = serializers.CharField(required=False, allow_blank=True)
    first_name = serializers.CharField(required=False, allow_blank=True)
    phone_number = serializers.CharField(required=False, allow_blank=True)
    birthdate = serializers.CharField(required=False, allow_blank=True)
    civility= serializers.CharField(required=False, allow_blank=True)

    class Meta:
        model = User
        fields = '__all__'
        extra_kwargs = {'password': {'write_only': True}}

    def get_country(self, obj):
        # Charger et retourner l'objet Domain correspondant
        if obj.country_id:
            from authentication.models import Pays  # Remplace par le chemin correct de ton modèle
            try:
                country = Pays.objects.get(id=obj.country_id)
                data = PaysSerializer(country)
                return data.data  # Modifie selon les champs que tu veux retourner
            except Pays.DoesNotExist:
                return None
        return None

 
    def create(self, validated_data):
        user_code = generate_unique_user_code()
        validated_data['user_code'] = user_code
        user = User.objects.create_user(**validated_data)
        return user
    
class UserSigninSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('email', 'password')

class UserEditSerializer(serializers.ModelSerializer):
    user_code = serializers.CharField(read_only=True)
    sexe = serializers.CharField(required=False, allow_blank=True)
    country = serializers.SerializerMethodField()
    poste = serializers.CharField(required=False, allow_blank=True)
    role  = RoleSerializer(read_only=True)
    city = serializers.CharField(required=False, allow_blank=True)
    department = serializers.CharField(required=False, allow_blank=True)
    zip_code = serializers.CharField(required=False, allow_blank=True)
    main_address = serializers.CharField(required=False, allow_blank=True)
    secondary_address = serializers.CharField(required=False, allow_blank=True)
    type_compte = serializers.CharField(required=False, allow_blank=True)
    last_name = serializers.CharField(required=False, allow_blank=True)
    first_name = serializers.CharField(required=False, allow_blank=True)
    phone_number = serializers.CharField(required=False, allow_blank=True)
    birthdate = serializers.CharField(required=False, allow_blank=True)
    civility= serializers.CharField(required=False, allow_blank=True)


    class Meta:
        model = User
        fields = '__all__'



def generate_unique_user_code():
    # Générer un code unique de 5 caractères (lettres et chiffres)
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=5))
