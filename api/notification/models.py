from django.utils import timezone 
import uuid
from django.db import models
from operation.models import *
from django.utils.timezone import now
# Create your models here.

class Message(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    contenu = models.TextField()
    date_envoi = models.DateTimeField(default=timezone.now)
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sent_messages')
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='received_messages')
    type = models.ForeignKey(Type, on_delete=models.CASCADE, related_name='messages')
    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name='messages', null=True, blank=True)
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name='messages', null=True, blank=True)
    is_read = models.BooleanField(default=False)

    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    def __str__(self):
        return f"Message de {self.sender.username} à {self.recipient.username}"



class Notification(models.Model):
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    notification = models.TextField()
    date_envoi = models.DateTimeField(auto_now_add=True)
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    type = models.ForeignKey(Type, on_delete=models.CASCADE, related_name='notifications')
    announcement = models.ForeignKey(Announcement, on_delete=models.CASCADE, related_name='notifications', null=True, blank=True)
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name='notifications', null=True, blank=True)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    def __str__(self):
        return f"Notification pour {self.recipient.username}: {self.notification[:30]}..."


class History(models.Model):
    ACTIONS = [
        ('CREATE', 'Création'),
        ('UPDATE', 'Mise à jour'),
        ('DELETE', 'Suppression'),
    ]
    
    STATUSES = [
        ('SUCCESS', 'Succès'),
        ('FAILURE', 'Échec'),
    ]
    
    ENTITIES = [
        ('USER', 'Utilisateur'),
        ('ANNOUNCEMENT', 'Annonce'),
        ('BOOKING', 'Réservation'),
        ('SUBSCRIPTION', 'Abonnement'),
    ]
    id = models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    created_at = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='histories')
    entity = models.CharField(max_length=50, choices=ENTITIES)
    action = models.CharField(max_length=50, choices=ACTIONS)
    statut = models.CharField(max_length=50, choices=STATUSES)
    is_deleted = models.BooleanField(default=False)
    created_at = models.DateTimeField(default=now)
    updated_at = models.DateTimeField(default=now)

    def __str__(self):
        return f"{self.action} de {self.entity} par {self.user.username} - {self.statut}"

    class Meta:
        verbose_name_plural = "Histories"