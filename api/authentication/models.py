import uuid
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth.models import Permission , Group
from datetime import timezone
from django.utils.timezone import now
# Create your models here.

# GESTIONNAIRE DE REQUETE POUR RENVOYER UNIQUEMENT UNE LISTE FILTRER SUR LES ELEMENTS NON SUPPRIMER POUR LE MODEL
class ModelManager(models.Manager):
    def get_queryset(self):
        return super().get_queryset().filter(is_deleted=False)
    

class Role(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=255 , default='')
    description = models.CharField(max_length=255 , default='')
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    
    # Gestionnaire des requetes 
    objects = ModelManager()

    def __str__(self):
        return self.wording
    

class Pays(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=255 , default='')
    code = models.CharField(max_length=255 , default='')
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)
    # Gestionnaire des requetes 
    # objects = ModelManager()

    def __str__(self):
        return self.wording
    

class User(AbstractUser):
    KYC_STATUS_CHOICES = [
        ('NOT_SUBMITTED', 'Non soumis'),
        ('PENDING', 'En attente'),
        ('VERIFIED', 'Vérifié'),
        ('REJECTED', 'Rejeté'),
    ]
    
    kyc_status = models.CharField(
        max_length=20,
        choices=KYC_STATUS_CHOICES,
        default='NOT_SUBMITTED'
    )

    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    is_active = models.BooleanField(default=True)
    is_deleted = models.BooleanField(default=False)
    last_name = models.CharField(max_length=255, default="")
    first_name = models.CharField(max_length=255 ,default="")
    phone_number = models.CharField(max_length=255 ,default="")
    birthdate = models.DateField(null=True)
    civility = models.CharField(max_length=255 ,default="")
    country =  models.ForeignKey(Pays,  on_delete=models.SET_NULL, null=True, blank=True)
    city = models.CharField(max_length=255 ,default="")
    department = models.CharField(max_length=255 ,default="")
    zip_code = models.CharField(max_length=255 ,default="")
    main_address = models.CharField(max_length=255 ,default="")
    secondary_address = models.CharField(max_length=255 ,default="")
    email = models.EmailField(_('email address'), unique=True)
    type_compte = models.CharField(max_length=255 ,default="")
    password_reset_token = models.CharField(max_length=128, null=True, blank=True)
    password_reset_token_expiration = models.DateTimeField(null=True, blank=True)
    user_code = models.CharField(max_length=7, unique=True)
    photo_profil = models.ImageField(upload_to="document/photo_profil" , null=True)
    role = models.ForeignKey(Role, related_name='users', on_delete=models.SET_NULL, null=True, blank=True)
    # groups = models.ManyToManyField(Group , related_name='users' , default= '', blank=True )
    is_notification_actif = models.BooleanField(default=True)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)
    # user_permissions= models.ManyToManyField(Permission, related_name='users' , blank=True)
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []  
    
    def generate_token(self):
        return default_token_generator.make_token(self) + "-" + str(int(timezone.now().timestamp()) + 120)
    

    class Meta:
        ordering = ['-date_joined']



class TypeDocument(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=255 , default='')
    # Gestionnaire des requetes 
    objects = ModelManager()
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    def __str__(self):
        return self.wording
    

class Document(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    type =  models.ForeignKey(TypeDocument, on_delete=models.SET_NULL, null=True, blank=True)
    numero_document = models.CharField(max_length=255 , default='')
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)
    # Gestionnaire des requetes 
    objects = ModelManager()

    def __str__(self):
        return self.numero_document

