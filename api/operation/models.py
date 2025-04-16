import uuid
from django.db import models
from authentication.models import User
from django.utils.timezone import now

##################################################################################################################
# GESTIONNAIRE DE REQUETE POUR RENVOYER UNIQUEMENT UNE LISTE FILTRER SUR LES ELEMENTS NON SUPPRIMER POUR LE MODEL
##################################################################################################################
class ModelManager(models.Manager):
    def get_queryset(self):
        return super().get_queryset().filter(is_deleted=False)
    
    
###############################################################################################################



# Create your models here.
class TypeVisibility(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording

    class Meta:
        verbose_name_plural = "TypeVisibilities"


class TypeStat(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording


# class Statistique(models.Model):
#     id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
#     type_stat = models.ForeignKey(TypeStat, on_delete=models.CASCADE, related_name='statistiques')
#     is_deleted = models.BooleanField(default=False)
#     # Le champ subscription sera défini après la définition de la classe Subscription

#     def __str__(self):
#         return f"{self.type_stat.wording}"

class Subscription(models.Model):
    SUBSCRIPTION_TYPES = (
        ('Free', 'Gratuit'),
        ('Intermediate', 'Intermédiaire'),
        ('Premium', 'Premium')
    )
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=50, choices=SUBSCRIPTION_TYPES)
    nbre_annoucement = models.IntegerField()
    type_visibility = models.ForeignKey(TypeVisibility, on_delete=models.SET_NULL, null=True)
    duree_publication = models.IntegerField()  # en jours
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='subscriptions', null=True)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording
    
# class Subscription(models.Model):
#     id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
#     wording = models.CharField(max_length=100)
#     nbre_annoucement = models.CharField(max_length=50)
#     type_visibility = models.ForeignKey(TypeVisibility, on_delete=models.CASCADE, related_name='subscriptions')
#     duree_publication = models.CharField(max_length=50)
#     statistique = models.ManyToManyField(TypeStat,  related_name='subscriptions')

#     objects = ModelManager()

#     def __str__(self):
#         return self.wording


class Category(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording

    class Meta:
        verbose_name_plural = "Categories"


class SubCategory(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='subcategories')
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording

    class Meta:
        verbose_name_plural = "SubCategories"


class AnnoucementStatus(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording

class Announcement(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    title = models.CharField(max_length=255)
    description = models.TextField()
    # Pour les images multiples, on peut utiliser un modèle distinct avec une relation
    rental_price = models.FloatField()
    status = models.ForeignKey(AnnoucementStatus, on_delete=models.CASCADE, related_name='announcements')
    availability_startDate = models.DateTimeField()
    availability_endDate = models.DateTimeField()
    expiration_date = models.DateTimeField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='announcements')
    rental_terms = models.TextField()
    location = models.CharField(max_length=255)
    extra_options = models.TextField(blank=True, null=True)
    proprietaire = models.ForeignKey(User, on_delete=models.CASCADE, related_name='announcements')
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    # objects = ModelManager()

    def __str__(self):
        return self.title


class AnnouncementPicture(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name='pictures')
    image = models.ImageField(upload_to='announcement_pics/')
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    # objects = ModelManager()

    def __str__(self):
        return f"Image pour {self.announcement.title}"


class BookingStatus(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording

    class Meta:
        verbose_name_plural = "BookingStatuses"


class Booking(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    date_reservation = models.DateTimeField()
    date_fin = models.DateTimeField()
    status = models.ForeignKey(BookingStatus, on_delete=models.CASCADE, related_name='bookings')
    annonce = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name='bookings')
    locataire = models.ForeignKey(User, on_delete=models.CASCADE, related_name='bookings')
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    # objects = ModelManager()

    def __str__(self):
        return f"Réservation de {self.locataire.username} pour {self.annonce.title}"


class TypeDocument(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording


class Document(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    type = models.ForeignKey(TypeDocument, on_delete=models.CASCADE, related_name='documents')
    numero_document = models.CharField(max_length=100)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='documents')
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    # objects = ModelManager()

    def __str__(self):
        return f"{self.type.wording} - {self.numero_document}"


class KycStatus(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording

    class Meta:
        verbose_name_plural = "KycStatuses"


class Type(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    wording = models.CharField(max_length=100)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return self.wording




class Review(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reviews')
    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name='reviews')
    rating = models.IntegerField()
    comment = models.TextField()
    created_date = models.DateTimeField(auto_now_add=True)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    # objects = ModelManager()

    def __str__(self):
        return f"Évaluation de {self.user.username} pour {self.announcement.title}"


class Rating(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    comment = models.TextField()
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='ratings')
    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name='ratings')
    rate = models.FloatField()
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return f"Note de {self.user.username} pour {self.announcement.title}: {self.rate}"



class Invoice(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='invoices')
    subscription = models.ForeignKey(Subscription, on_delete=models.CASCADE, related_name='invoices')
    startDate = models.DateTimeField()
    endDate = models.DateTimeField()
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    objects = ModelManager()

    def __str__(self):
        return f"Facture de {self.user.username} pour {self.subscription.wording}"
