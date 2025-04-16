from rest_framework import serializers
from notification.models import *
from authentication.models import User
from authentication.serializers import *
from operation.serializers import * 



class MessageSerializer(serializers.ModelSerializer):
    sender = UserSerializer(read_only=True)
    recipient = UserSerializer(read_only=True)
    type = TypeSerializer(read_only=True)

    class Meta:
        model = Message
        fields = [
            'id', 'contenu', 'date_envoi', 'sender', 'recipient', 
            'type', 'announcement', 'booking', 'is_read'
        ]
        read_only_fields = ['sender', 'is_read']